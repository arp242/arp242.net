package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"
	"text/template"
	"time"
)

var pw = ""

var defaults = map[string]repository{
	"arp242.net": {ShortStatus: "stable", Status: "Project status: stable", Language: "ruby"},
	"config":     {ShortStatus: "stable", Status: "Project status: stable"},

	"MediaWiki-FontAwesome":  {Language: "php"},
	"MediaWiki-Scepticismus": {Language: "php"},

	// Vim stuff, doing the vimtomd.py crap doesn't help :-/
	"confirm_quit.vim":   {ShortStatus: "finished", Status: "Project status: finished (it does what it needs to do and there are no known bugs)."},
	"complete_email.vim": {ShortStatus: "stable", Status: "Project status: stable"},
	"helplink.vim":       {ShortStatus: "stable", Status: "Project status: stable"},
	"startscreen.vim":    {ShortStatus: "stable", Status: "Project status: stable"},
	"undofile_warn.vim":  {ShortStatus: "stable", Status: "Project status: stable"},
}

// Options
const user = "https://api.github.com/users/Carpetsmoker/repos?affiliation=owner"

// Knowing how many pages there are in advance helps speed things up later
var pages = 2

// JSON structs
type repositories []repository

type repository struct {
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Language    string    `json:"language"`
	UpdatedOn   time.Time `json:"updated_at"`
	Fork        bool      `json:"fork"`

	LinkName      string // e.g. nordavind instead of Nordavind
	LinkNameLower string // e.g. nordavind instead of Nordavind
	Readme        string
	ExtraLink     string
	Status        string
	ShortStatus   string
	LastVersion   string

	// We need to use interface here since some values are Objects and some are Arrays
	//Links       map[string]interface{}
	CommitsLink string `json:"commits_url"` // git_commits_url?
	TagsLink    string `json:"tags_url"`    // git_tags_url?
	HTMLLink    string `json:"html_url"`
}

// HTML templates
var funcs = template.FuncMap{
	"date_human": func(t time.Time) string { return t.Format("2 Jan 2006") },
	"date_sort":  func(t time.Time) string { return t.Format("20060102") },
}

const htmlBrief = `
<div class="weblog-brief lang-{{.Language}} status-{{.ShortStatus}}" data-updated="{{.UpdatedOn|date_sort}}" data-name="{{.Name}}" data-status="{{.ShortStatus}}">
	<em>Status: {{.ShortStatus}}, last updated: {{.UpdatedOn|date_human}}</em>
	<h2><a href="/code/{{.LinkNameLower}}/">{{.Name}}</a></h2>
	<p>{{.Description|html}}</p>
</div>
`

var tplBrief = template.Must(template.New("brief").Funcs(funcs).Parse(htmlBrief))

const htmlIndex = `---
layout: default
title: Code projects
---

<div class="weblog-overview code-projects">
	{% include_relative top.html %}
	{{range .Values}}
		` + htmlBrief + `
	{{end}}
</div>
<script>
{% include script/main.js  %}
</script>
`

var tplIndex = template.Must(template.New("index").Funcs(funcs).Parse(htmlIndex))

const htmlProject = `---
layout: code
title: "{{.Name}}"
link: "{{.LinkName}}"
last_version: "{{.LastVersion}}"
{{if .Status}}pre1: "{{.Status}}"{{end}}
{{if .ExtraLink}}post1: "{{.ExtraLink}}"{{end}}
---

{{.Readme}}`

var tplProject = template.Must(template.New("project").Parse(htmlProject))

//var extra_links_regexp = regexp.MustCompile(`^- (.*)+\s+-{41}`)
// Everything before exactly 41 -'s at the start of the file
var extraLinksRegexp = regexp.MustCompile(`(?s)(.+)\n-{41}\n`)

// ByDate sorts by date
type ByDate []repository

func (arr ByDate) Len() int           { return len(arr) }
func (arr ByDate) Swap(i, j int)      { arr[i], arr[j] = arr[j], arr[i] }
func (arr ByDate) Less(i, j int) bool { return arr[i].UpdatedOn.Unix() > arr[j].UpdatedOn.Unix() }

var root string

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr,
			"First argument must be the root directory to write to (e.g. use ./_mkcode.sh).\n")
		os.Exit(1)
	}
	root = os.Args[1]

	// Read repos
	var allRepos repositories
	for i := 1; i <= pages; i++ {
		repos := readRepositories(fmt.Sprintf("%s&page=%d", user, i))
		allRepos = append(allRepos, repos...)
	}
	// Don't list stuff I forked, only repos I created
	for i, v := range allRepos {
		if v.Fork {
			allRepos = append(allRepos[:i], allRepos[i+1:]...)
		}
	}

	// Write files
	for i, v := range allRepos {
		readAndWriteRepo(&v)
		allRepos[i] = v
	}
	makeIndex(allRepos)
}

// Make code/index.html
func makeIndex(allRepos repositories) {
	f, err := os.Create(root + "/code/index.html")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = tplIndex.Execute(out, map[string]repositories{
		"Values": allRepos,
	})
	check(err)
	out.Flush()

	// Write first five entries for the home page
	f, err = os.Create(root + "/_index-code.html")
	check(err)
	defer f.Close()

	out = bufio.NewWriter(f)
	for i := 0; i < 5; i++ {
		err = tplBrief.Execute(out, allRepos[i])
		check(err)
	}
	out.Flush()
}

// Read one repository page
func readRepositories(url string) (repos repositories) {
	data := readURL(url)

	err := json.Unmarshal(data, &repos)
	check(err)

	return repos
}

// Read some extra repository info and write to /code/<project>/index.markdown
func readAndWriteRepo(repo *repository) {
	l := strings.Split(repo.HTMLLink, "/")
	repo.LinkName = l[len(l)-1]
	repo.LinkNameLower = strings.ToLower(repo.LinkName)
	repo.Language = strings.ToLower(repo.Language)

	//repo.Readme = string(readURL(repo.HTMLLink + "/raw/tip/README.markdown"))
	repo.Readme = string(readURL("https://raw.githubusercontent.com/Carpetsmoker/" + repo.LinkName + "/master/README.markdown"))
	//https://raw.githubusercontent.com/Carpetsmoker/password-bunny/master/README.markdown

	// Extract metadata from the README
	match := extraLinksRegexp.FindStringSubmatch(repo.Readme)
	if match != nil && len(match) > 1 {
		for _, m := range strings.Split(match[1], "\n") {
			if m == "" {
				continue
			}
			if m[0] == '[' || m[0] == '-' {
				// Markdown link
				repo.ExtraLink = strings.TrimSpace(strings.TrimLeft(m, "-"))
			} else {
				// Project status

				// Append
				if repo.Status != "" {
					repo.Status += " " + strings.TrimSpace(m)
					continue
				}

				repo.Status = strings.TrimSpace(m)
				end := strings.Index(m, "(")
				if end < 0 {
					end = strings.Index(m, ";")
					if end < 0 {
						end = len(m)
					}
				}

				repo.ShortStatus = strings.ToLower(strings.TrimSpace(m[strings.Index(m, ":")+1 : end]))
			}
		}
		repo.Readme = extraLinksRegexp.ReplaceAllString(repo.Readme, "")
	}

	if repo.Status == "" {
		repo.Status = "Project status: experimental"
		repo.ShortStatus = "experimental"
	}

	if def, has := defaults[repo.Name]; has {
		if def.ShortStatus != "" {
			repo.ShortStatus = def.ShortStatus
		}
		if def.Status != "" {
			repo.Status = def.Status
		}
		if def.Language != "" {
			repo.Language = def.Language
		}
	}

	repo.UpdatedOn = findUpdated(*repo)
	repo.LastVersion = lastTag(*repo)

	// Write code/<project>/index.markdown
	dir := root + "/code/" + repo.LinkNameLower
	os.MkdirAll(dir, 0755)
	f, err := os.Create(dir + "/index.markdown")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = tplProject.Execute(out, repo)
	check(err)
	out.Flush()
}

type commitT struct {
	Date    time.Time
	Message string
}
type commitsT []commitT

// Try and find updated_on from last commit that is *not* to the README
func findUpdated(repo repository) time.Time {
	// "commit": {
	//   "author": {
	//     "name": "Martin Tournoij",
	//     "email": "martin@arp242.net",
	//     "date": "2011-09-26T00:59:29Z"
	//   },
	//data := readURL("https://api.github.com/repos/Carpetsmoker/" + repo.LinkName + "/commits")
	//var commits commitsT
	//err := json.Unmarshal(data, &commits)
	//check(err)
	//for _, commit := range commits {
	//	if strings.Index(strings.ToLower(commit.Message), "readme") == -1 {
	//		return commit.Date
	//	}
	//}

	return repo.UpdatedOn
}

type tagsT []tagT

type tagT struct {
	Name string
}

// Find the last tag, or "tip"
func lastTag(repo repository) (tagname string) {
	// Most stuff is tagged as "version-1.2", so sorting descending gives the
	// most recent version first (can't sort by date)
	data := readURL(repo.TagsLink + "?sort=-name")
	var tags tagsT
	err := json.Unmarshal(data, &tags)
	check(err)

	if len(tags) == 0 {
		return "master"
	}
	return tags[0].Name
}

// Read text from an URL
func readURL(url string) []byte {
	fmt.Println(url)
	client := &http.Client{Timeout: 5 * time.Second}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Fprintf(os.Stderr, "mkcode error: %v %v\n", url, err)
		os.Exit(1)
	}

	if pw != "" {
		req.SetBasicAuth("Carpetsmoker", pw)
	}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "mkcode error: %v %v\n", url, err)
		os.Exit(1)
	}
	if resp.StatusCode != 200 {
		fmt.Fprintf(os.Stderr, "mkcode code %v: %v %v\n", resp.StatusCode, url, err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	b, err := ioutil.ReadAll(resp.Body)
	check(err)
	return b
}

// Panic if err is non-nil
func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
