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
	"strings"
	"text/template"
	"time"
)

const user = "https://api.github.com/users/Carpetsmoker/repos"

type repository struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Fork        bool   `json:"fork"`

	LinkName       string // e.g. nordavind instead of Nordavind
	LinkNameLower  string // e.g. nordavind instead of Nordavind
	READMEContents string
	LastVersion    string

	// We need to use interface here since some values are Objects and some are Arrays
	//Links       map[string]interface{}
	TagsLink string `json:"tags_url"` // git_tags_url?
	HTMLLink string `json:"html_url"`
}

var pageTemplate = template.Must(template.New("project").Parse(
	`---
layout: code
title: "{{.Name}}"
link: "{{.LinkName}}"
last_version: "{{.LastVersion}}"
---

{{.READMEContents}}`))

var root string

func main() {
	root, _ = filepath.Abs(os.Args[0])
	root = filepath.Dir(filepath.Dir(root))

	// Read repos
	var allRepos []repository
	for i := 1; i <= 10; i++ {
		var repos []repository
		err := json.Unmarshal(readURL(fmt.Sprintf("%s?page=%d", user, i)), &repos)
		check(err)

		if len(repos) == 0 {
			break
		}
		allRepos = append(allRepos, repos...)
	}

	// Don't list stuff I forked, only repos I created.
	myRepos := []repository{}
	for _, v := range allRepos {
		if v.Fork {
			continue
		}

		myRepos = append(myRepos, v)
	}

	// Write files
	numRequests := 0
	ch := make(chan bool)
	for _, v := range myRepos {
		go readAndWriteRepo(ch, v)
		numRequests++
	}

	// Wait for everything to finish.
	fmt.Println("")
	for i := 1; i <= numRequests; i++ {
		fmt.Printf("\rFinished request %v / %v   ", i, numRequests)
		_ = <-ch
	}
	fmt.Println("")
}

// Read some extra repository info and write to /code/<project>/index.markdown
func readAndWriteRepo(ch chan bool, repo repository) {
	l := strings.Split(repo.HTMLLink, "/")
	repo.LinkName = l[len(l)-1]
	repo.LinkNameLower = strings.ToLower(repo.LinkName)
	repo.READMEContents = string(readURL(fmt.Sprintf(
		"https://raw.githubusercontent.com/Carpetsmoker/%v/master/README.markdown?v=%v",
		repo.LinkName, time.Now().Unix())))

	// Extract some data from the README
	repo.LastVersion = lastTag(repo)

	// Write code/<project>/index.markdown
	dir := root + "/code/" + repo.LinkNameLower
	os.MkdirAll(dir, 0755)
	f, err := os.Create(dir + "/index.markdown")
	check(err)
	defer f.Close()

	out := bufio.NewWriter(f)
	err = pageTemplate.Execute(out, repo)
	check(err)
	out.Flush()

	ch <- true
}

type tagT struct {
	Name string
}

type tagsT []tagT

// Find the last tag, or "master".
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
	//fmt.Println(url)
	client := &http.Client{Timeout: 5 * time.Second}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Fprintf(os.Stderr, "mkcode error: %v %v\n", url, err)
		os.Exit(1)
	}

	req.Header.Set("User-Agent", "Carpetsmoker/mkcode")
	if _, err := os.Stat(root + "/_mkcode/_secret"); err == nil {
		pw, err := ioutil.ReadFile(root + "/_mkcode/_secret")
		if err != nil {
			fmt.Fprintf(os.Stderr, "mkcode error: could not read _secret: %v\n", err)
			os.Exit(1)
		}
		req.SetBasicAuth("Carpetsmoker", strings.TrimSpace(string(pw)))
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
