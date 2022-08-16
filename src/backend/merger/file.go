package main

import (
	"context"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"

	"go.opentelemetry.io/otel"
)

var (
	numberOfFilesUploaded int
	uploadedStat          bool
)

type templateStat struct {
	Header string `json:"Header"`
	Status string `json:"Status"`
}

const NUMBEROFDOCS int = 2

func uploadFile(w http.ResponseWriter, r *http.Request, ctx context.Context) {
	tr := otel.Tracer("uploadFile")
	ctxinn, span := tr.Start(ctx, "uploading")
	defer span.End()

	// Maximum upload of 10 MB files
	r.ParseMultipartForm(10 << 20)

	file, handler, err := r.FormFile("File")
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		requestsProcessedError.Inc()
		return
	}

	defer file.Close()

	if handler.Header["Content-Type"][0] != "application/pdf" {
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		// t, err := template.ParseFiles("./upload.html")
		t, err := template.ParseFiles("./templates/upload.html")
		var x templateStat
		if err != nil {
			x = templateStat{
				Header: "alert alert-danger",
				Status: "Internal Server error 501 ⚠️",
			}
			requestsProcessedError.Inc()
		} else {
			x = templateStat{
				Header: "alert alert-danger",
				Status: "Invalid file format error 415 ⚠️",
			}
			requestsProcessedError.Inc()
		}

		t.Execute(w, x)
		return
	}

	dst, err := os.Create(fmt.Sprintf("./uploads/0%d.pdf", numberOfFilesUploaded))
	if numberOfFilesUploaded == 1 {
		uploadedStat = true
	}
	numberOfFilesUploaded = (numberOfFilesUploaded + 1) % NUMBEROFDOCS
	defer dst.Close()

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		requestsProcessedError.Inc()
		return
	}

	// Copy the uploaded file to the created file on the filesystem
	if _, err := io.Copy(dst, file); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		requestsProcessedError.Inc()
		return
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	// t, err := template.ParseFiles("./upload.html")
	t, err := template.ParseFiles("./templates/upload.html")

	var x templateStat

	if err != nil {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "Internal Server error 501 ⚠️",
		}
		requestsProcessedError.Inc()
	} else {
		x = templateStat{
			Header: "alert alert-success",
			Status: "Uploaded ✅",
		}
		requestsProcessedSuccess.Inc()
	}

	if uploadedStat {
		if MergePdf(ctxinn) == nil {
			uploadedStat = false
		} else {
			x = templateStat{
				Header: "alert alert-danger",
				Status: "CRITICAL ERROR 502 ❌",
			}
			requestsProcessedError.Inc()
		}
		//TODO: condition check to automatically delete the uploads/ by clearExistingpdfs(w, r)
	}
	t.Execute(w, x)
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	tr := tp.Tracer("uploadingMain")
	ctxIn, span := tr.Start(ctx, "mainBlock")
	defer span.End()

	requestsProcessed.Inc()
	switch r.Method {
	case "POST":
		uploadFile(w, r, ctxIn)
	default:
		w.WriteHeader(http.StatusBadRequest)
		requestsProcessedError.Inc()
	}
}
