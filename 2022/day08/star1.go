package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type Tree struct {
	Height  int
	Visible bool
}

type Forest [][]Tree

func inspect_left_to_right(forest Forest) {
	height := len(forest)
	width := len(forest[0])

	for y := 0; y < height; y++ {
		visible_h := forest[y][0].Height
		forest[y][0].Visible = true
		for x := 1; x < width; x++ {
			if visible_h < forest[y][x].Height {
				visible_h = forest[y][x].Height
				forest[y][x].Visible = true
			}
		}
	}
}

func inspect_top_to_bottom(forest Forest) {
	height := len(forest)
	width := len(forest[0])

	for x := 0; x < width; x++ {
		visible_h := forest[0][x].Height
		forest[0][x].Visible = true
		for y := 1; y < height; y++ {
			if visible_h < forest[y][x].Height {
				visible_h = forest[y][x].Height
				forest[y][x].Visible = true
			}
		}
	}
}

func inspect_right_to_left(forest Forest) {
	height := len(forest)
	width := len(forest[0])

	for y := 0; y < height; y++ {
		visible_h := forest[y][width-1].Height
		forest[y][width-1].Visible = true
		for x := width - 2; x >= 0; x-- {
			if visible_h < forest[y][x].Height {
				visible_h = forest[y][x].Height
				forest[y][x].Visible = true
			}
		}
	}
}

func inspect_bottom_to_top(forest Forest) {
	height := len(forest)
	width := len(forest[0])

	for x := 0; x < width; x++ {
		visible_h := forest[height-1][x].Height
		forest[height-1][x].Visible = true
		for y := height - 2; y >= 0; y-- {
			if visible_h < forest[y][x].Height {
				visible_h = forest[y][x].Height
				forest[y][x].Visible = true
			}
		}
	}
}

func inspect_forest(forest Forest) {
	inspect_left_to_right(forest)
	inspect_top_to_bottom(forest)
	inspect_right_to_left(forest)
	inspect_bottom_to_top(forest)
}

func count_visible_trees(forest Forest) (sum int) {
	for _, line := range forest {
		for _, tree := range line {
			if tree.Visible {
				sum++
			}
		}
	}
	return
}

func get_forest(scanner *bufio.Scanner) (forest Forest) {
	var y int
	for scanner.Scan() {
		forest = append(forest, []Tree{})
		for _, c := range scanner.Text() {
			height, _ := strconv.Atoi(string(c))
			forest[y] = append(forest[y], Tree{Height: height})
		}
		y += 1
	}
	return
}

func main() {
	forest := get_forest(bufio.NewScanner(os.Stdin))
	inspect_forest(forest)
	fmt.Println(count_visible_trees(forest))
}
