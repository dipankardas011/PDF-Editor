package main

import (
	"fmt"
	"net/http"
	"os/exec"
)

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		curl := exec.Command("curl", "backend:8080/pdf/clear") // this line is modified
		out, err := curl.Output()
		if err != nil {
			fmt.Println("erorr", err)
			return
		}
		w.Write(out)
	})
	http.ListenAndServe(":80", nil)
}
