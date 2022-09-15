package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func star1_generate_intcode(sa []string) []int {
	var intcode []int

	for _, s := range sa {
		value, _ := strconv.Atoi(s)
		intcode = append(intcode, value)
	}

	return intcode
}

func star1_execute_intcode(intcode []int) int {
	for i := 0; intcode[i] != 99; i += 4 {
		switch intcode[i] {
		case 1:
			intcode[intcode[i+3]] = intcode[intcode[i+1]] + intcode[intcode[i+2]]
		case 2:
			intcode[intcode[i+3]] = intcode[intcode[i+1]] * intcode[intcode[i+2]]
		}
	}
	return intcode[0]
}

func star1() {
	file, _ := os.Open("input")
	scanner := bufio.NewScanner(file)
	scanner.Scan()
	input_array := strings.Split(scanner.Text(), ",")
	intcode := generate_intcode(input_array)
	intcode[1] = 12
	intcode[2] = 2
	fmt.Println(execute_intcode(intcode))
}
