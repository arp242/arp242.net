package main

import (
	"fmt"
	"html/template"
	"os"
	"regexp"
	"time"
)

var root string

type projects_t []project

type project_t struct {
	Name        string
	Description string
	Language    string
	UpdatedOn   time.Time
	LinkName    string // e.g. nordavind instead of Nordavind
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

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "First argument must be the root directory to write to (e.g. use ./_mkcode.sh).\n")
		os.Exit(1)
	}
	root = os.Args[1]

	for name, project := range getProjects() {
		fmt.Println(name, project)
	}
}

func getProjects() projects projects_t {
	all := map[string]string{
		"dnsblock":     "/data/code/dnsblock",
		"config":       "/data/code/config",
		"download-npo": "/data/code/download-npo",
		"battray":      "/data/code/battray",
	}

	for name, path := range all {
		project := project_t{
			Name: name,
		}
		projects = append(projects, project)
	}
}

// Make code/index.html
func makeIndex(projects *projects_t) {
	f, err := os.Create(root + "/code/index.html")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = tpl_index.Execute(out, projects)
	check(err)
	out.Flush()

	// Write first five entries for the home page
	f, err = os.Create(root + "/_index-code.html")
	check(err)
	defer f.Close()

	out = bufio.NewWriter(f)
	for i := 0; i < 5; i += 1 {
		err = tpl_brief.Execute(out, projects[i])
		check(err)
	}
	out.Flush()
}
