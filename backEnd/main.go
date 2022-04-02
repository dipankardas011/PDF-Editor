package main

import (
	"fmt"
	"log"
	"net/http"
	"text/template"
	"time"
)

type PageVars struct {
	Message  string
	Language string
}

func getPort() string {
	return ":8080"
}

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World! 🐳☸️🚀👍🏼🥳✅ %s", time.Now())
}

func render(w http.ResponseWriter, tmpl string, pageVars PageVars) {

	tmpl = fmt.Sprintf("web/%s", tmpl)
	t, err := template.ParseFiles(tmpl)

	if err != nil { // if there is an error
		log.Print("template parsing error: ", err) // log it
	}

	err = t.Execute(w, pageVars) //execute the template and pass in the variables to fill the gaps

	if err != nil { // if there is an error
		log.Print("template executing error: ", err) //log it
	}
}

func Home(w http.ResponseWriter, req *http.Request) {
	pageVars := PageVars{
		Message:  "Success!",
		Language: "Go Lang",
	}
	render(w, "index.html", pageVars)
}

func main() {
	http.HandleFunc("/greet", greet)
	// http.ListenAndServe(":8080", nil)
	http.HandleFunc("/", Home)
	http.ListenAndServe(getPort(), nil)
}
