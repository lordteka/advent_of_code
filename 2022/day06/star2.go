package main

import (
	"bufio"
	"fmt"
	"os"
)

func check_marker(buf []byte) bool {
	for i, b := range buf {
		for j := i + 1; j < len(buf); j += 1 {
			if b == buf[j] {
				return false
			}
		}
	}
	return true
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	data := []byte(scanner.Text())
	for i, _ := range data {
		if check_marker(data[i : i+14]) {
			fmt.Println(i + 14)
			break
		}
	}
}
