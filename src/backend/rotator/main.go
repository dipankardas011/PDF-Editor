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
	fmt.Printf("ENV{Port}: %v\n", port)
	return ":" + port
}

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "[ %s ] Hello from PDF-Rotator", time.Now())
}

func main() {
	http.HandleFunc("/greet", greet)
	http.ListenAndServe(getPort(), nil)
}
