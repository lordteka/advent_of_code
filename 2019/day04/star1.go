package main

import (
	"fmt"
	"strconv"
)

func star1check_number(num int) bool {
	var adjacent bool
	num_string := strconv.Itoa(num)
	for i := 1; i < 6; i++ {
		if !adjacent && num_string[i-1] == num_string[i] {
			adjacent = true
		}
		if num_string[i-1] > num_string[i] {
			return false
		}
	}
	return adjacent
}

func star1check_range(lower, upper int) (count int) {
	for i := lower; i <= upper; i++ {
		if star1check_number(i) {
			count++
		}
	}
	return
}

func star1main() {
	fmt.Println(star1check_range(108457, 562041))
}
