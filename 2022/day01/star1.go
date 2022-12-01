package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

func get_file_from_stdin() string {
	f, _ := io.ReadAll(bufio.NewReader(os.Stdin))

	return string(f)
}

func parse_file(file string) [][]int {
	raw_elf_packages := strings.Split(file, "\n\n")
	elf_packages := make([][]int, len(raw_elf_packages))
	for i, value := range raw_elf_packages {
		raw_calories := strings.Split(value, "\n")
		calories := make([]int, len(raw_calories))
		for i, value := range raw_calories {
			calories[i], _ = strconv.Atoi(value)
		}
		elf_packages[i] = calories
	}
	return elf_packages
}

func compute_max_sum_calories(elf_packages [][]int) (max int) {
	for _, elf := range elf_packages {
		var sum int
		for _, calories := range elf {
			sum += calories
		}
		if sum > max {
			max = sum
		}
	}
	return
}

func main() {
	fmt.Println(compute_max_sum_calories(parse_file(get_file_from_stdin())))
}
