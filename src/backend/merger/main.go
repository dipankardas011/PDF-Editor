package main

import (
	"context"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"os/exec"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/exporters/jaeger"
	"go.opentelemetry.io/otel/sdk/resource"
	tracesdk "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.10.0"
)

const (
	service     = "PDF Editor tracing"
	environment = "production"
	id          = 1
)

var (
	tp *tracesdk.TracerProvider
)

func tracerProvider(url string) (*tracesdk.TracerProvider, error) {
	// Create the Jaeger exporter
	exp, err := jaeger.New(jaeger.WithCollectorEndpoint(jaeger.WithEndpoint(url)))
	if err != nil {
		return nil, err
	}
	tp := tracesdk.NewTracerProvider(
		// Always be sure to batch in production.
		tracesdk.WithBatcher(exp),
		// Record information about this application in a Resource.
		tracesdk.WithResource(resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceNameKey.String(service),
			attribute.String("environment", environment),
			attribute.Int64("ID", id),
		)),
	)
	return tp, nil
}

func loadConfigsTracing() {
	var err error
	tp, err = tracerProvider("http://trace:14268/api/traces")
	if err != nil {
		log.Fatal(err)
	}
	otel.SetTracerProvider(tp)
}

var requestsProcessed = promauto.NewCounter(prometheus.CounterOpts{
	Name: "go_request_operations_total",
	Help: "The total number of processed requests",
})

var requestsProcessedError = promauto.NewCounter(prometheus.CounterOpts{
	Name: "go_request_operations_error_total",
	Help: "The total number of HTTP requests Errors",
})

var requestsProcessedSuccess = promauto.NewCounter(prometheus.CounterOpts{
	Name: "go_request_operations_success_total",
	Help: "The total number of HTTP 200 requests",
})

func greet(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	tr := tp.Tracer("/greet")
	_, span := tr.Start(ctx, "have a nice day!")
	defer span.End()

	requestsProcessed.Inc()
	fmt.Fprintf(w, "[ %s ] Hello from PDF-Merger", time.Now())
	requestsProcessedSuccess.Inc()
}

func MergePdf(ctx context.Context) error {
	tr := otel.Tracer("Merge")
	_, span := tr.Start(ctx, "merging")
	defer span.End()

	cmd := exec.Command("qpdf", "--empty", "--pages", "./uploads/00.pdf", "./uploads/01.pdf", "--", "./uploads/resrelt.pdf")
	err := cmd.Run()
	if err != nil {
		fmt.Println("Error in MergePDF", err)
		fmt.Println("{\"Source\": \"pdf-merger\", \"FileNo\": [\"1\", \"2\"], \"operation\": \"Merge\", \"Status\": \"Merge ERROR\"}")
		requestsProcessedError.Inc()
	} else {
		fmt.Println("{\"Source\": \"pdf-merger\", \"FileNo\": [\"1\", \"2\"], \"operation\": \"Merge\", \"Status\": \"Merged\"}")
		requestsProcessedSuccess.Inc()
	}
	return err
}

func getPort() string {
	port := os.Getenv("PORT")

	if port == "" {
		port = "8080"
	}
	fmt.Printf("{\"Source\": \"pdf-merger\", \"operation\": \"Merge\", \"Status\": {\"Port\": \"%v\"}}\n", port)
	return ":" + port
}

func main() {
	loadConfigsTracing()
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
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	tr := tp.Tracer("PDF download time")
	_, span := tr.Start(ctx, "Download")
	defer span.End()

	requestsProcessed.Inc()
	if r.Method == "GET" {
		fmt.Println("{\"Source\": \"pdf-merger\", \"operation\": \"Merge\", \"Status\": \"Sending MergedPDF\"}")
		http.ServeFile(w, r, "uploads/resrelt.pdf")
		requestsProcessedSuccess.Inc()
	} else {
		requestsProcessedError.Inc()
	}
}

func helperCleaner(ctx context.Context) (err error) {
	tr := otel.Tracer("Clean Helper")
	_, span := tr.Start(ctx, "helpCleaner")
	defer span.End()

	cmd := exec.Command("rm", "-Rf", "./uploads/")
	return cmd.Run()
}

func clearExistingpdfs(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	tr := tp.Tracer("Clearing PDF's")
	ctxIn, span := tr.Start(ctx, "Clearing")
	defer span.End()

	requestsProcessed.Inc()
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	t, err := template.ParseFiles("./templates/upload.html")

	var x templateStat
	if err != nil {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "Internal Server error 501 ⚠️",
		}
		requestsProcessedError.Inc()
	}

	err = helperCleaner(ctxIn)

	if err != nil {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "CRITICAL ERROR 503 ❌",
		}
		requestsProcessedError.Inc()
	}
	err = os.MkdirAll("./uploads", os.ModePerm)
	if err != nil {
		requestsProcessedError.Inc()
		panic(err)
	} else {
		x = templateStat{
			Header: "alert alert-success",
			Status: fmt.Sprintf("Cleared the data!!✅\t%s", time.Now()),
		}
		requestsProcessedSuccess.Inc()
	}
	t.Execute(w, x)
}
