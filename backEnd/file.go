package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

var (
	numberOfFilesUploaded int
	uploadedStat          bool
)

const NUMBEROFDOCS int = 2

func uploadFile(w http.ResponseWriter, r *http.Request) {

	// Maximum upload of 10 MB files
	r.ParseMultipartForm(10 << 20)

	file, handler, err := r.FormFile("myFile")
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	defer file.Close()

	fmt.Printf("Uploaded File: %+v\n", handler.Filename)
	fmt.Printf("File Size: %+v\n", handler.Size)
	fmt.Printf("MIME Header: %+v\n", handler.Header)

	if handler.Header["Content-Type"][0] != "application/pdf" {
		http.Error(w, "Invalid file format use PDF!!", http.StatusBadRequest)
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
		return
	}

	// Copy the uploaded file to the created file on the filesystem
	if _, err := io.Copy(dst, file); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "Successfully Uploaded File\n")
	if uploadedStat {
		MergePdf()
		uploadedStat = false
		//TODO: condition check to automatically delete the uploads/ by clearExistingpdfs(w, r)
	}
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "POST":
		uploadFile(w, r)
	default:
		w.WriteHeader(http.StatusBadRequest)
	}
}
