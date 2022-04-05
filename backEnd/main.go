package main

import (
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"time"
)

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World! 🐳☸️🚀👍🏼🥳✅ %s", time.Now())
}

func html(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		http.ServeFile(w, r, "web/index.html")
	}
}

func MergePdf() {
	cmd := exec.Command("qpdf", "--empty", "--pages", "01.pdf", "02.pdf", "--", "../home/newDocker.pdf")
	err := cmd.Run()
	if err != nil {
		log.Fatal("Error in MergePDF", err)
	}
}

func main() {
	MergePdf()
	http.HandleFunc("/greet", greet)
	http.HandleFunc("/", html)
	http.ListenAndServe(":8080", nil)
}
