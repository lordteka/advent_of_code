package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var scoring = map[string]map[string]int{
	// Rock
	"A": {
		// Rock
		"X": 1 + 3,
		// Paper
		"Y": 2 + 6,
		// Scissors
		"Z": 3 + 0,
	},
	// Paper
	"B": {
		// Rock
		"X": 1 + 0,
		// Paper
		"Y": 2 + 3,
		// Scissors
		"Z": 3 + 6,
	},
	// Scissors
	"C": {
		// Rock
		"X": 1 + 6,
		// Paper
		"Y": 2 + 0,
		// Scissors
		"Z": 3 + 3,
	},
}

func main() {
	var score int
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		play := strings.Split(scanner.Text(), " ")
		opponent := play[0]
		own := play[1]
		score += scoring[opponent][own]
	}
	fmt.Println(score)
}
