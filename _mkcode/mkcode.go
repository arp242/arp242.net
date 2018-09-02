package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"text/template"
	"time"

	"arp242.net/hubhub"
)

const user = "/users/Carpetsmoker/repos"

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
	fmt.Println("writing to", root)

	hubhub.User = "Carpetsmoker"
	hubhub.Token = os.Getenv("GITHUB_PASS")

	// Read repos
	var allRepos []repository
	err := hubhub.Paginate(&allRepos, user, 0)
	check(err)

	allRepos = filter(allRepos)

	// Write files
	numRequests := 0
	ch := make(chan bool)
	for _, v := range allRepos {
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

// Don't list stuff I forked, only repos I created.
func filter(allRepos []repository) []repository {
	myRepos := []repository{}
	for _, v := range allRepos {
		if v.Fork {
			continue
		}

		// Ignore my "test" repo as well.
		if v.Name == "test" {
			continue
		}

		myRepos = append(myRepos, v)
	}
	return myRepos
}

// Read some extra repository info and write to /code/<project>/index.markdown
func readAndWriteRepo(ch chan bool, repo repository) {
	l := strings.Split(repo.HTMLLink, "/")
	repo.LinkName = l[len(l)-1]
	repo.LinkNameLower = strings.ToLower(repo.LinkName)

	resp, err := http.Get(fmt.Sprintf(
		"https://raw.githubusercontent.com/Carpetsmoker/%v/master/README.markdown?v=%v",
		repo.LinkName, time.Now().Unix()))
	if err != nil {
		check(err)
	}
	defer resp.Body.Close() // nolint: errcheck

	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		check(err)
	}

	repo.READMEContents = string(data)

	// Extract some data from the README
	repo.LastVersion = lastTag(repo)

	// Write code/<project>/index.markdown
	dir := root + "/code/" + repo.LinkNameLower
	err = os.MkdirAll(dir, 0755)
	check(err)

	f, err := os.Create(dir + "/index.markdown")
	check(err)
	defer func() {
		err := f.Close()
		check(err)
	}()

	out := bufio.NewWriter(f)
	err = pageTemplate.Execute(out, repo)
	check(err)
	err = out.Flush()
	check(err)

	ch <- true
}

// Find the last tag, or "master".
func lastTag(repo repository) (tagname string) {
	// Most stuff is tagged as "version-1.2", so sorting descending gives the
	// most recent version first (can't sort by date)

	var tags []struct{ Name string }
	_, err := hubhub.Request(&tags, "GET", repo.TagsLink+"?sort=-name")
	check(err)

	if len(tags) == 0 {
		return "master"
	}
	return tags[0].Name
}

// Panic if err is non-nil
func check(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
