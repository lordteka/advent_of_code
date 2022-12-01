package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"sort"
	"strconv"
	"strings"
)

func sum(s []int) (sum int) {
	for _, v := range s {
		sum += v
	}
	return
}

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

func compute_calories_sum(elf_packages [][]int) []int {
	sums := make([]int, len(elf_packages))
	for i, elf := range elf_packages {
		sums[i] = sum(elf)
	}
	return sums
}

func sum_of_the_three_highest(calories []int) int {
	sort.Ints(calories)

	return sum(calories[len(calories)-3:])
}

func main() {
	fmt.Println(sum_of_the_three_highest(compute_calories_sum(parse_file(get_file_from_stdin()))))
}
