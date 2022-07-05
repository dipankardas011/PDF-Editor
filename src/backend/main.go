package main

import (
	"context"
	"fmt"
	"html/template"
	"io"
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
	"go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
)

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

const name = "pdf-editor-backend"

var ctx = context.Background()

func greet(w http.ResponseWriter, r *http.Request) {
	_, span := otel.Tracer(name).Start(ctx, "Greet")
	requestsProcessed.Inc()
	defer span.End()

	fmt.Fprintf(w, "Hello World! 🐳☸️🚀👍🏼🥳✅ %s", time.Now())
	requestsProcessedSuccess.Inc()
}

func MergePdf() error {
	cmd := exec.Command("qpdf", "--empty", "--pages", "./uploads/00.pdf", "./uploads/01.pdf", "--", "./uploads/resrelt.pdf")
	err := cmd.Run()
	if err != nil {
		fmt.Println("Error in MergePDF", err)
		requestsProcessedError.Inc()
	}
	requestsProcessedSuccess.Inc()
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

// ---------------------------------------------------------------
func newExporter(w io.Writer) (trace.SpanExporter, error) {
	return stdouttrace.New(
		stdouttrace.WithWriter(w),
		// Use human-readable output.
		stdouttrace.WithPrettyPrint(),
		// Do not print timestamps for the demo.
		stdouttrace.WithoutTimestamps(),
	)
}

// newResource returns a resource describing this application.
func newResource() *resource.Resource {
	r, _ := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceNameKey.String("pdf-editor-backend"),
			semconv.ServiceVersionKey.String("v0.1.0"),
			attribute.String("environment", "demo"),
		),
	)
	return r
}

// ---------------------------------------------------------------

func main() {
	// ---------------------------------------------------------------

	l := log.New(os.Stdout, "", 0)
	f, err := os.Create("traces.json")
	if err != nil {
		l.Fatal(err)
	}
	defer f.Close()

	exp, err := newExporter(f)
	if err != nil {
		l.Fatal(err)
	}

	tp := trace.NewTracerProvider(
		trace.WithBatcher(exp),
		trace.WithResource(newResource()),
	)
	defer func() {
		if err := tp.Shutdown(context.Background()); err != nil {
			l.Fatal(err)
		}
	}()
	otel.SetTracerProvider(tp)
	// ---------------------------------------------------------------

	uploadedStat = false
	err = os.MkdirAll("./uploads", os.ModePerm)
	if err != nil {
		panic(err)
	}
	http.HandleFunc("/greet", greet)
	http.HandleFunc("/upload", uploadHandler)
	http.HandleFunc("/downloads", DownloadFile)
	http.HandleFunc("/pdf/clear", clearExistingpdfs)

	// prometheus metrics
	http.Handle("/metrics", promhttp.Handler())
	// http.Handle("/traces", _)
	// http.Handle("/logs", _)

	http.ListenAndServe(getPort(), nil)
}

func DownloadFile(w http.ResponseWriter, r *http.Request) {
	requestsProcessed.Inc()
	if r.Method == "GET" {
		http.ServeFile(w, r, "uploads/resrelt.pdf")
		requestsProcessedSuccess.Inc()
	} else {
		requestsProcessedError.Inc()
	}
}

func helperCleaner() (err error) {
	cmd := exec.Command("rm", "-Rf", "./uploads/")
	return cmd.Run()
}

func clearExistingpdfs(w http.ResponseWriter, r *http.Request) {
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

	err = helperCleaner()

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
