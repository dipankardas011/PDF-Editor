// UNIT Testing
package main

import (
	"context"
	"log"
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
	if w != ":8081" {
		t.Fatalf("Port number assigned was `incorrect`\n")
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
