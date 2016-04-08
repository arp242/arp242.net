// Make a better looking "profile overview" than what BitBucket offers these days
package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math"
	"net/http"
	"os"
	"regexp"
	"sort"
	"strings"
	"text/template"
	"time"
)

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

	// We need to use interface here since some values are Objects and some are Arrays
	Links       map[string]interface{}
	CommitsLink string
	HTMLLink    string
}

// HTML templates
var funcs = template.FuncMap{
	"date_human": func(t time.Time) string { return t.Format("2 Jan 2006") },
	"date_sort":  func(t time.Time) string { return t.Format("20060102") },
}

const html_brief = `<div class="weblog-brief lang-{{.Language}}" data-updated="{{.UpdatedOn|date_sort}}" data-name="{{.Name}}">
	<em>{{.UpdatedOn|date_human}}</em>
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
<script src="/script/jquery.js"></script>
<script src="/script/main.js"></script>
`

var tpl_index = template.Must(template.New("index").Funcs(funcs).Parse(html_index))

const html_project = `---
layout: code
title: {{.Name}}
link: {{.LinkName}}
{{if .ExtraLink}}extra_links: "{{.ExtraLink}}"
{{end}}---

{{.Readme}}`

var tpl_project = template.Must(template.New("project").Parse(html_project))

var extra_links_regexp = regexp.MustCompile(`^- (.*)+\s+-{41}`)

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
	l := strings.Split(repo.HTMLLink, "/")
	repo.LinkName = l[len(l)-1]

	repo.Readme = string(read_url(repo.HTMLLink + "/raw/tip/README.markdown"))
	match := extra_links_regexp.FindStringSubmatch(repo.Readme)
	if match != nil && len(match) > 1 {
		repo.ExtraLink = match[1]
		repo.Readme = extra_links_regexp.ReplaceAllString(repo.Readme, "")
	}

	ch <- repo

	// Write code/<project>/index.markdown
	f, err := os.Create(root + "/code/" + repo.LinkName + "/index.markdown")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = tpl_project.Execute(out, repo)
	check(err)
	out.Flush()
}

// Read text from an URL
func read_url(url string) []byte {
	resp, err := http.Get(url)
	defer resp.Body.Close()
	if err != nil || resp.StatusCode != 200 {
		fmt.Fprintf(os.Stderr, "mkcode: %v\n", resp.StatusCode, err)
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
		panic(err)
	}
}
