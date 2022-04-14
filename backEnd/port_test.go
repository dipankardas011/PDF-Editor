package main

import (
	"os"
	"testing"
)

func TestPortNumber(t *testing.T) {
	os.Setenv("PORT", "10000")
	w := getPort()
	if w != ":"+os.Getenv("PORT") {
		t.Fatalf("Port number assigned was `incorrect`\n")
	}
	os.Unsetenv("PORT")
	w = getPort()
	if w != ":8080" {
		t.Fatalf("Port number assigned was `incorrect`\n")
	}
}
