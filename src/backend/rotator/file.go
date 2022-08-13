package main

import (
	"fmt"
	"os/exec"
)

func RotatePdf() error {
	cmd := exec.Command("qpdf", "--rotate=+90:1", "01.pdf", "01111.pdf")
	err := cmd.Run()
	if err != nil {
		fmt.Println("Error in MergePDF", err)
	}
	return err
}
