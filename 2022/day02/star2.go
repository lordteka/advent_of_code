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
		// lose with scissors
		"X": 0 + 3,
		// draw with rock
		"Y": 3 + 1,
		// win with paper
		"Z": 6 + 2,
	},
	// Paper
	"B": {
		// lose with rock
		"X": 0 + 1,
		// draw with paper
		"Y": 3 + 2,
		// win with scissors
		"Z": 6 + 3,
	},
	// Scissors
	"C": {
		// lose with paper
		"X": 0 + 2,
		// draw with scissors
		"Y": 3 + 3,
		// win with rock
		"Z": 6 + 1,
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
