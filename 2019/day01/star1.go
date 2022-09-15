package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func star1() {
	file, _ := os.Open("input")
	scanner := bufio.NewScanner(file)
	var sum int
	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		sum += (num / 3) - 2
	}
	fmt.Println(sum)
}
