package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"text/template"
	"time"
)

var pw = ``

var defaults = map[string]repository{
	"arp242.net":             {Language: "ruby", Status: "stable"},
	"dotfiles":               {Language: "python", Status: "stable"},
	"MediaWiki-FontAwesome":  {Language: "php"},
	"MediaWiki-Scepticismus": {Language: "php"},
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

const htmlProject = `---
layout: code
title: "{{.Name}}"
link: "{{.LinkName}}"
last_version: "{{.LastVersion}}"
{{if .ExtraLink}}post1: "{{.ExtraLink}}"{{end}}
---

{{.Readme}}`

var tplProject = template.Must(template.New("project").Parse(htmlProject))

var statusRegexp = regexp.MustCompile(`https:\/\/arp242.net\/status\/(\w+)`)

// ByDate sorts by date
type ByDate []repository

func (arr ByDate) Len() int           { return len(arr) }
func (arr ByDate) Swap(i, j int)      { arr[i], arr[j] = arr[j], arr[i] }
func (arr ByDate) Less(i, j int) bool { return arr[i].UpdatedOn.Unix() > arr[j].UpdatedOn.Unix() }

var root string

func main() {
	root, _ = filepath.Abs(os.Args[0])
	root = filepath.Dir(filepath.Dir(root))

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

	// Only include repos on the cmdline, of any
	if len(os.Args) > 2 {
		var newAll repositories
		for _, sel := range os.Args[2:] {
			for _, v := range allRepos {
				if v.Name == sel {
					newAll = append(newAll, v)
					break
				}
			}
		}

		allRepos = newAll
	}

	sort.Sort(ByDate(allRepos))

	// Write files
	for i, v := range allRepos {
		readAndWriteRepo(&v)
		allRepos[i] = v
	}
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
	if repo.Language == "vim script" {
		repo.Language = "viml"
	}

	repo.Readme = string(readURL(fmt.Sprintf(
		"https://raw.githubusercontent.com/Carpetsmoker/%v/master/README.markdown?v=%v",
		repo.LinkName, time.Now().Unix())))

	// Extract some data from the README
	findStatus := statusRegexp.FindStringSubmatch(repo.Readme)
	if len(findStatus) == 2 {
		repo.Status = findStatus[1]
	}

	if repo.Status == "" {
		repo.Status = "experimental"
	}

	if def, has := defaults[repo.Name]; has {
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
		req.SetBasicAuth("arpetsmoker", pw)
	}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "mkcode error: %v %v\n", url, err)
		os.Exit(1)
	}
	b, err := ioutil.ReadAll(resp.Body)
	check(err)
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		fmt.Fprintf(os.Stderr, "mkcode code %v: %v %v\n%v", resp.StatusCode,
			string(b), url, err)
		os.Exit(1)
	}

	return b
}

// Panic if err is non-nil
func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
