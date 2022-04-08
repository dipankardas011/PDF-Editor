package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
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
	cmd := exec.Command("qpdf", "--empty", "--pages", "./uploads/01.pdf", "./uploads/02.pdf", "--", "resrelt.pdf")
	err := cmd.Run()
	if err != nil {
		log.Fatal("Error in MergePDF", err)
	}
}

func main() {
	err := os.MkdirAll("./uploads", os.ModePerm)
	if err != nil {
		panic(err)
	}
	http.HandleFunc("/greet", greet)
	http.HandleFunc("/upload", uploadHandler)
	http.HandleFunc("/downloads", DownloadFile)
	http.HandleFunc("/", html)

	http.ListenAndServe(":8080", nil)
}

func DownloadFile(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		http.ServeFile(w, r, "resrelt.pdf")
	}
}
