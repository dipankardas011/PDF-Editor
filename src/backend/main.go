package main

import (
	"fmt"
	"html/template"
	"net/http"
	"os"
	"os/exec"
	"time"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World! 🐳☸️🚀👍🏼🥳✅ %s", time.Now())
}

func MergePdf() error {
	cmd := exec.Command("qpdf", "--empty", "--pages", "./uploads/00.pdf", "./uploads/01.pdf", "--", "./uploads/resrelt.pdf")
	err := cmd.Run()
	if err != nil {
		fmt.Println("Error in MergePDF", err)
	}
	return err
}

func getPort() string {
	port := os.Getenv("PORT")

	if port == "" {
		port = "8080"
	}
	fmt.Printf("ENV{Port}: %v\n", port)
	return ":" + port
}

func main() {
	uploadedStat = false
	err := os.MkdirAll("./uploads", os.ModePerm)
	if err != nil {
		panic(err)
	}
	http.HandleFunc("/greet", greet)
	http.HandleFunc("/upload", uploadHandler)
	http.HandleFunc("/downloads", DownloadFile)
	http.HandleFunc("/pdf/clear", clearExistingpdfs)

	// prometheus metrics
	http.Handle("/metrics", promhttp.Handler())

	http.ListenAndServe(getPort(), nil)
}

func DownloadFile(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		http.ServeFile(w, r, "uploads/resrelt.pdf")
	}
}

func helperCleaner() (err error) {
	cmd := exec.Command("rm", "-Rf", "./uploads/")
	return cmd.Run()
}

func clearExistingpdfs(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	t, err := template.ParseFiles("./templates/upload.html")

	var x templateStat
	if err != nil {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "Internal Server error 501 ⚠️",
		}
	}

	err = helperCleaner()

	if err != nil {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "CRITICAL ERROR 503 ❌",
		}
	}
	err = os.MkdirAll("./uploads", os.ModePerm)
	if err != nil {
		panic(err)
	} else {
		x = templateStat{
			Header: "alert alert-success",
			Status: fmt.Sprintf("Cleared the data!!✅\t%s", time.Now()),
		}
	}
	t.Execute(w, x)
}
