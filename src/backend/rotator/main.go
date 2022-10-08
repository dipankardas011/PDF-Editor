package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var requestsProcessed = promauto.NewCounter(prometheus.CounterOpts{
	Name: "go_request_operations_rotator_total",
	Help: "The total number of processed requests",
})

var requestsProcessedError = promauto.NewCounter(prometheus.CounterOpts{
	Name: "go_request_operations_rotator_error_total",
	Help: "The total number of HTTP requests Errors",
})

var requestsProcessedSuccess = promauto.NewCounter(prometheus.CounterOpts{
	Name: "go_request_operations_rotator_success_total",
	Help: "The total number of HTTP 200 requests",
})

func getPort() string {
	port := os.Getenv("PORT")

	if port == "" {
		port = "8081"
	}
	fmt.Printf("{\"Source\": \"pdf-merger\", \"operation\": \"Merge\", \"Status\": {\"Port\": \"%v\"}}\n", port)
	return ":" + port
}

func greet(w http.ResponseWriter, r *http.Request) {
	requestsProcessed.Inc()
	fmt.Fprintf(w, "[ %s ] Hello from PDF-Rotator", time.Now())
	requestsProcessedSuccess.Inc()
}

func DownloadFile(w http.ResponseWriter, r *http.Request) {
	requestsProcessed.Inc()
	if r.Method == "GET" {
		requestsProcessedSuccess.Inc()
		fmt.Println("{\"Source\": \"pdf-rotator\", \"operation\": \"Rotator\", \"Status\": \"Sending RotatedPDF\"}")
		http.ServeFile(w, r, "uploads/resrelt.pdf")
	} else {
		requestsProcessedError.Inc()
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
	http.ListenAndServe(getPort(), nil)
	http.Handle("/metrics", promhttp.Handler())
}
