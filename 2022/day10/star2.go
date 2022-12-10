package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var register = 1
var screen [6][40]bool

func print_screen() {
	printable_line := make([]byte, 40)
	for _, line := range screen {
		for i, pixel := range line {
			if pixel {
				printable_line[i] = '#'
			} else {
				printable_line[i] = '.'
			}
		}
		fmt.Println(string(printable_line))
	}
}

func handle_cycle() func(int) {
	cycle := 0
	return func(n int) {
		for i := 0; i < n; i++ {
			if x := cycle % 40; x == register-1 || x == register || x == register+1 {
				y := cycle / 40
				screen[y][x] = true
			}
			cycle++
		}
	}
}

func run_instructions(scanner *bufio.Scanner) {
	next_cycle := handle_cycle()

	for scanner.Scan() {
		data := strings.Split(scanner.Text(), " ")
		switch data[0] {
		case "noop":
			next_cycle(1)
		case "addx":
			next_cycle(2)
			value, _ := strconv.Atoi(data[1])
			register += value
		}
	}
	return
}

func main() {
	run_instructions(bufio.NewScanner(os.Stdin))
	print_screen()
}
