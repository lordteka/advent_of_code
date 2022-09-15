package main

import (
	"fmt"
	"strconv"
)

func check_number(num int) bool {
	var adjacent bool
	var streak_number byte
	var adjacent_count int
	num_string := strconv.Itoa(num)
	for i := 1; i < 6; i++ {
		if num_string[i-1] > num_string[i] {
			return false
		}
		if adjacent && num_string[i-2] == num_string[i] {
			adjacent = false
			adjacent_count--
			streak_number = num_string[i]
		}
		if num_string[i] != streak_number && num_string[i-1] == num_string[i] {
			adjacent = true
			adjacent_count++
		}
	}
	return adjacent_count > 0
}

func check_range(lower, upper int) (count int) {
	for i := lower; i <= upper; i++ {
		if check_number(i) {
			count++
		}
	}
	return
}

func star2main() {
	fmt.Println(check_range(108457, 562041))
	fmt.Println(check_number(112222))
}

func main() {
	//star1main()
	star2main()
}
