package main

import (
	"bufio"
	"fmt"
	"os"
)

func check_marker(buf []byte) bool {
	return buf[0] != buf[1] && buf[0] != buf[2] && buf[0] != buf[3] &&
		buf[1] != buf[2] && buf[1] != buf[3] &&
		buf[2] != buf[3]
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	data := []byte(scanner.Text())
	for i, _ := range data {
		if check_marker(data[i:]) {
			fmt.Println(i + 4)
			break
		}
	}
}
