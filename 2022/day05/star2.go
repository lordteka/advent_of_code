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

func reverse_slice[T any](s []T) []T {
	for left, right := 0, len(s)-1; left < right; left, right = left+1, right-1 {
		s[left], s[right] = s[right], s[left]
	}
	return s
}

func push(s []byte, b byte) []byte {
	return append(s, b)
}

func pop(s []byte, n int) ([]byte, []byte) {
	return s[len(s)-n : len(s)], s[:len(s)-n]
}

var stacks = [][]byte{
	[]byte{}, []byte{}, []byte{},
	[]byte{}, []byte{}, []byte{},
	[]byte{}, []byte{}, []byte{},
}

func print_stacks() {
	var solution []byte
	for i, stack := range stacks {
		fmt.Println(i, string(stack))
		solution = push(solution, stack[len(stack)-1])
	}
	fmt.Printf("Solution is : %s\n", string(solution))
}

func parse_stacks(data string) {
	lines := strings.Split(data, "\n")
	for _, line := range reverse_slice(lines[:len(lines)-1]) {
		for i := 1; i < len(line); i += 4 {
			if line[i] != ' ' {
				stacks[i/4] = push(stacks[i/4], line[i])
			}
		}
	}
}

func move(from int, to int, amount int) {
	var b []byte

	b, stacks[from] = pop(stacks[from], amount)
	stacks[to] = append(stacks[to], b...)
}

func run_instructions(data string) {
	instructions := strings.Split(data, "\n")
	for _, line := range instructions[:len(instructions)-1] {
		data := strings.Split(line, " ")
		amount, _ := strconv.Atoi(string(data[1]))
		from, _ := strconv.Atoi(string(data[3]))
		to, _ := strconv.Atoi(string(data[5]))

		move(from-1, to-1, amount)
	}
}

func main() {
	data := strings.Split(get_file_from_stdin(), "\n\n")
	parse_stacks(data[0])
	run_instructions(data[1])
	print_stacks()
}
