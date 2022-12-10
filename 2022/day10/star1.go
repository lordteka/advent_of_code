package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var register = 1
var signal_strength int

func handle_cycle() func(int) {
	cycle := 0
	return func(n int) {
		for i := 0; i < n; i++ {
			cycle++
			if cycle == 20 || cycle == 60 || cycle == 100 || cycle == 140 || cycle == 180 || cycle == 220 {
				signal_strength += cycle * register
			}
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
	fmt.Println(signal_strength)
}
