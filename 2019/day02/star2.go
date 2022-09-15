package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func generate_intcode(sa []string) []int {
	var intcode []int

	for _, s := range sa {
		value, _ := strconv.Atoi(s)
		intcode = append(intcode, value)
	}

	return intcode
}

func execute_intcode(intcode []int) int {
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

func run_for(noun, verb int, intcode []int) int {
	intcode[1] = noun
	intcode[2] = verb
	return execute_intcode(intcode)
}

func brute_force_noun_and_verb(intcode []int) (int, int) {
	for noun := 0; noun < 100; noun += 1 {
		for verb := 0; verb < 100; verb += 1 {
			if run_for(noun, verb, append([]int(nil), intcode...)) == 19690720 {
				return noun, verb
			}
		}
	}
	return -1, -1
}

func main() {
	file, _ := os.Open("input")
	scanner := bufio.NewScanner(file)
	scanner.Scan()
	input_array := strings.Split(scanner.Text(), ",")
	intcode := generate_intcode(input_array)
	noun, verb := brute_force_noun_and_verb(intcode)
	fmt.Println(noun)
	fmt.Println(verb)
	fmt.Println(100*noun + verb)
}
