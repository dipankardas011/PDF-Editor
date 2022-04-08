package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

var (
	numberOfFilesUploaded int
)

func uploadFile(w http.ResponseWriter, r *http.Request) {

	if numberOfFilesUploaded == 2 {
		fmt.Fprintf(w, "File upload limit exceded !!!\n")
		return
	}

	// detectedFileType := http.DetectContentType(fileBytes)
	// switch detectedFileType {
	// case "image/jpeg", "image/jpg":
	// case "image/gif", "image/png":
	// case "application/pdf":
	// 		break
	// default:
	// 		renderError(w, "INVALID_FILE_TYPE", http.StatusBadRequest)
	// 		return
	// }
	// Maximum upload of 10 MB files
	r.ParseMultipartForm(10 << 20)
	numberOfFilesUploaded++

	// Get handler for filename, size and headers
	file, handler, err := r.FormFile("myFile")
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	defer file.Close()

	fmt.Printf("Uploaded File: %+v\n", handler.Filename)
	fmt.Printf("File Size: %+v\n", handler.Size)
	fmt.Printf("MIME Header: %+v\n", handler.Header)

	// Create file
	dst, err := os.Create(fmt.Sprintf("./uploads/0%d.pdf", numberOfFilesUploaded))
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
	if numberOfFilesUploaded == 2 {
		MergePdf()
	}
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	// case "GET":
	// display(w, "upload", nil)
	case "POST":
		uploadFile(w, r)
	}
}
