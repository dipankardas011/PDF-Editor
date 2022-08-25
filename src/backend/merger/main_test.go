// UNIT Testing
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

func TestNoOfFiles(t *testing.T) {
	no := NUMBEROFDOCS
	if no != 2 {
		t.Fatalf("Number of Docs to be uploaded must be `2`\n")
	}
}

// func TestCleaner(t *testing.T) {
// 	_, err := os.Stat("uploads")
// 	if os.IsNotExist(err) {
// 		// log.Fatal("upload/ does not exist")
// 		err = os.MkdirAll("./uploads", os.ModePerm)
// 		if err != nil {
// 			log.Fatal("Couldn't create a folder")
// 		}
// 	}
// 	ctx := context.Background()
// 	_ = helperCleaner(ctx)
// 	_, err = os.Stat("uploads")
// 	if os.IsNotExist(err) == false {
// 		log.Fatal("CRITICAL ❌ uploads/ exist")
// 	}
// }
