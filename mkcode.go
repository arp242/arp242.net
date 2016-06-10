// Make a better looking "profile overview" than what BitBucket offers these days
package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"net/http"
	"os"
	"regexp"
	"sort"
	"strings"
	"text/template"
	"time"
)

var statusmaps = map[string][]string{
	"arp242.net": []string{"stable", "stable"},
	"config":     []string{"stable", "stable"},

	// Vim stuff, doing the vimtomd.py crap doesn't help :-/
	"complete_email.vim": []string{"stable", "stable"},
	"confirm_quit.vim":   []string{"finished", "finished (it does what it needs to do and there are no known bugs)."},
	"helplink.vim":       []string{"stable", "stable"},
	"startscreen.vim":    []string{"stable", "stable"},
	"undofile_warn.vim":  []string{"stable", "stable"},
}

// Options
const user = "https://api.bitbucket.org/2.0/repositories/Carpetsmoker"

var pages = 4

// JSON structs
type repositories struct {
	Next    string
	Page    int
	Pagelen float64
	Size    float64
	Values  []repository
}

type repository struct {
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Language    string    `json:"language"`
	UpdatedOn   time.Time `json:"updated_on"`
	LinkName    string    // e.g. nordavind instead of Nordavind
	Readme      string
	ExtraLink   string
	Status      string
	ShortStatus string
	LastVersion string

	// We need to use interface here since some values are Objects and some are Arrays
	Links       map[string]interface{}
	CommitsLink string
	TagsLink    string
	HTMLLink    string
}

// HTML templates
var funcs = template.FuncMap{
	"date_human": func(t time.Time) string { return t.Format("2 Jan 2006") },
	"date_sort":  func(t time.Time) string { return t.Format("20060102") },
}

const html_brief = `
<div class="weblog-brief lang-{{.Language}} status-{{.ShortStatus}}" data-updated="{{.UpdatedOn|date_sort}}" data-name="{{.Name}}" data-status="{{.ShortStatus}}">
	<em>Status: {{.ShortStatus}}, last updated: {{.UpdatedOn|date_human}}</em>
	<h2><a href="/code/{{.LinkName}}/">{{.Name}}</a></h2>
	<p>{{.Description|html}}</p>
</div>
`

var tpl_brief = template.Must(template.New("brief").Funcs(funcs).Parse(html_brief))

const html_index = `---
layout: default
title: Code projects
---

<div class="weblog-overview code-projects">
	{% include_relative top.html %}
	{{range .Values}}
		` + html_brief + `
	{{end}}
</div>
`

var tpl_index = template.Must(template.New("index").Funcs(funcs).Parse(html_index))

const html_project = `---
layout: code
title: "{{.Name}}"
link: "{{.LinkName}}"
last_version: "{{.LastVersion}}"
{{if .Status}}pre1: "{{.Status}}"{{end}}
{{if .ExtraLink}}post1: "{{.ExtraLink}}"{{end}}
---

{{.Readme}}`

var tpl_project = template.Must(template.New("project").Parse(html_project))

//var extra_links_regexp = regexp.MustCompile(`^- (.*)+\s+-{41}`)
// Everything before exactly 41 -'s at the start of the file
var extra_links_regexp = regexp.MustCompile(`(?s)(.+)\n-{41}\n`)

// Sort by date
type ByDate []repository

func (arr ByDate) Len() int           { return len(arr) }
func (arr ByDate) Swap(i, j int)      { arr[i], arr[j] = arr[j], arr[i] }
func (arr ByDate) Less(i, j int) bool { return arr[i].UpdatedOn.Unix() > arr[j].UpdatedOn.Unix() }

var root string

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "First argument must be the root directory to write to (e.g. use ./_mkcode.sh).\n")
		os.Exit(1)
	}
	root = os.Args[1]

	var repos, all_repos repositories
	ch := make(chan repositories)
	for i := 1; i <= pages; i += 1 {
		go read_repositories(fmt.Sprintf("%s?page=%d", user, i), ch)
	}

	// Check for more pages
	repos = <-ch
	if int(repos.Size) > int(repos.Pagelen)*pages {
		n_pages := int(math.Ceil(repos.Size / repos.Pagelen))
		fmt.Fprintf(os.Stderr,
			"Warning: pages is set to %v, but there are %v pages.\n",
			pages, n_pages)

		for i := pages + 1; i <= n_pages; i += 1 {
			go read_repositories(fmt.Sprintf("%s?page=%d", user, i), ch)
		}

		pages = n_pages
	}

	for i := 1; i <= pages; i++ {
		// We already read the first page
		if i != 1 {
			repos = <-ch
		}
		for _, v := range repos.Values {
			all_repos.Values = append(all_repos.Values, v)
		}
	}

	sort.Sort(ByDate(all_repos.Values))
	make_index(&all_repos)
}

// Make code/index.html
func make_index(all_repos *repositories) {
	f, err := os.Create(root + "/code/index.html")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = tpl_index.Execute(out, all_repos)
	check(err)
	out.Flush()

	// Write first five entries for the home page
	f, err = os.Create(root + "/_index-code.html")
	check(err)
	defer f.Close()

	out = bufio.NewWriter(f)
	for i := 0; i < 5; i += 1 {
		err = tpl_brief.Execute(out, all_repos.Values[i])
		check(err)
	}
	out.Flush()
}

// Read one repository page; calls read_and_write_repository() so it writes out
// some files
func read_repositories(url string, ch chan<- repositories) {
	data := read_url(url)
	var repos repositories
	err := json.Unmarshal(data, &repos)
	check(err)

	ch2 := make(chan repository)
	for i, v := range repos.Values {
		go read_and_write_repository(v, i, ch2)
	}

	for i := 0; len(repos.Values) > i; i++ {
		repo := <-ch2
		repos.Values[i] = repo
	}

	ch <- repos
}

// Read some extra repository info and write to /code/<project>/index.markdown
func read_and_write_repository(repo repository, index int, ch chan<- repository) {
	repo.HTMLLink = get_link(&repo, "html")
	repo.CommitsLink = get_link(&repo, "commits")
	repo.TagsLink = get_link(&repo, "tags")
	l := strings.Split(repo.HTMLLink, "/")
	repo.LinkName = l[len(l)-1]

	repo.Readme = string(read_url(repo.HTMLLink + "/raw/tip/README.markdown"))

	// Extract metadata from the README
	match := extra_links_regexp.FindStringSubmatch(repo.Readme)
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
		repo.Readme = extra_links_regexp.ReplaceAllString(repo.Readme, "")
	}

	if repo.Status == "" {
		repo.Status = "Project status: experimental"
		repo.ShortStatus = "experimental"
	}

	if m, hm := statusmaps[repo.Name]; hm {
		repo.ShortStatus = m[0]
		repo.Status = "Project status: " + m[1]
	}

	repo.UpdatedOn = find_updated(repo)
	repo.LastVersion = last_tag(repo)

	ch <- repo

	// Write code/<project>/index.markdown
	dir := root + "/code/" + repo.LinkName
	os.MkdirAll(dir, 0755)
	f, err := os.Create(dir + "/index.markdown")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = tpl_project.Execute(out, repo)
	check(err)
	out.Flush()
}

type commits_t struct {
	Values []commit_t
}

type commit_t struct {
	Date    time.Time
	Message string
}

// Try and find updated_on from last commit that is *not* to the README
func find_updated(repo repository) (updated_on time.Time) {
	data := read_url(repo.CommitsLink)
	var commits commits_t
	err := json.Unmarshal(data, &commits)
	check(err)

	for _, commit := range commits.Values {
		if strings.Index(strings.ToLower(commit.Message), "readme") == -1 {
			return commit.Date
		}
	}

	return repo.UpdatedOn
}

type tags_t struct {
	Values []tag_t
}

type tag_t struct {
	Name string
}

// Find the last tag, or "tip"
func last_tag(repo repository) (tagname string) {
	// Most stuff is tagged as "version-1.2", so sorting descending gives the
	// most recent version first (can't sort by date)
	data := read_url(repo.TagsLink + "?sort=-name")
	var tags tags_t
	err := json.Unmarshal(data, &tags)
	check(err)

	// "tip" tag should always be present.
	return tags.Values[0].Name
}

// Read text from an URL
func read_url(url string) []byte {
	resp, err := http.Get(url)
	defer resp.Body.Close()
	if err != nil || resp.StatusCode != 200 {
		fmt.Fprintf(os.Stderr, "mkcode: %v %v %v\n", url, resp.StatusCode, err)
		os.Exit(1)
	}

	b, err := ioutil.ReadAll(resp.Body)
	check(err)
	return b
}

// Get a link.href fields. Special foo is needed because "clone" is an Array and
// not an Object like the other fields...
func get_link(value *repository, which string) string {
	for k, v := range value.Links {
		if k == which {
			switch x := v.(type) {
			case map[string]interface{}:
				return x["href"].(string)
			}
		}
	}
	return ""
}

// Panic if err is non-nil
func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
