package main

import (
	"fmt"
	"net/http"
	"os"
	"time"
)

func getPort() string {
	port := os.Getenv("PORT")

	if port == "" {
		port = "8081"
	}
	fmt.Printf("{\"Source\": \"pdf-merger\", \"operation\": \"Merge\", \"Status\": {\"Port\": \"%v\"}}\n", port)
	return ":" + port
}

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "[ %s ] Hello from PDF-Rotator", time.Now())
}

func DownloadFile(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		fmt.Println("{\"Source\": \"pdf-rotator\", \"operation\": \"Rotator\", \"Status\": \"Sending RotatedPDF\"}")
		http.ServeFile(w, r, "uploads/resrelt.pdf")
	}
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
	http.ListenAndServe(getPort(), nil)
}
