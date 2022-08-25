package main

import (
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"
	"os/exec"
)

type templateStat struct {
	Header string `json:"Header"`
	Status string `json:"Status"`
}

const NUMBEROFDOCS int = 1

func RotatePdf(pages string) error {
	// specify the clockwise or anti clockwise direction
	// Rotate the all the pages
	rotateOptions := "--rotate=+90:" + pages[:(len(pages)-1)]

	cmd := exec.Command("qpdf", rotateOptions, "./uploads/00.pdf", "./uploads/resrelt.pdf")
	err := cmd.Run()
	if err != nil {
		fmt.Println(">>> Error in RotatePDF", err)
		fmt.Println("{\"Source\": \"pdf-rotator\", \"FileNo\": \"1\", \"operation\": \"Rotate\", \"Status\": \"Rotate ERROR\"}")
	} else {
		fmt.Println("{\"Source\": \"pdf-rotator\", \"FileNo\": \"1\", \"operation\": \"Rotate\", \"Status\": \"Rotated\"}")
	}
	return err
}

func uploadFile(w http.ResponseWriter, r *http.Request) {
	// Maximum upload of 10 MB files
	r.ParseMultipartForm(10 << 20)

	file, handler, err := r.FormFile("File")
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	pages := r.FormValue("Pages")

	defer file.Close()

	if handler.Header["Content-Type"][0] != "application/pdf" {
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		t, err := template.ParseFiles("./templates/upload.html")
		var x templateStat
		if err != nil {
			x = templateStat{
				Header: "alert alert-danger",
				Status: "Internal Server error 501 ⚠️",
			}
		} else {
			x = templateStat{
				Header: "alert alert-danger",
				Status: "Invalid file format error 415 ⚠️",
			}
		}

		t.Execute(w, x)
		return
	}

	dst, err := os.Create("./uploads/00.pdf")
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

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	t, err := template.ParseFiles("./templates/upload.html")

	var x templateStat

	if err != nil {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "Internal Server error 501 ⚠️",
		}
	} else {
		x = templateStat{
			Header: "alert alert-success",
			Status: "Uploaded ✅",
		}
	}

	if RotatePdf(pages) == nil {
		fmt.Println("{\"Source\": \"Backend-Rotate\",\"Status\": \"Came back from RotatePdf\"}")
	} else {
		x = templateStat{
			Header: "alert alert-danger",
			Status: "CRITICAL ERROR 502 ❌",
		}
	}
	t.Execute(w, x)
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {

	switch r.Method {
	case "POST":
		uploadFile(w, r)
	default:
		w.WriteHeader(http.StatusBadRequest)
	}
}
