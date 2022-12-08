package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type Forest [][]int

func look_to_the_right(forest Forest, x int, y int) (visible int) {
	width := len(forest[0])
	tree_height := forest[y][x]
	for i := x + 1; i < width; i++ {
		visible++
		if forest[y][i] >= tree_height {
			return
		}
	}
	return
}

func look_to_the_bottom(forest Forest, x int, y int) (visible int) {
	height := len(forest)
	tree_height := forest[y][x]
	for i := y + 1; i < height; i++ {
		visible++
		if forest[i][x] >= tree_height {
			return
		}
	}
	return
}

func look_to_the_left(forest Forest, x int, y int) (visible int) {
	tree_height := forest[y][x]
	for i := x - 1; i >= 0; i-- {
		visible++
		if forest[y][i] >= tree_height {
			return
		}
	}
	return
}

func look_to_the_top(forest Forest, x int, y int) (visible int) {
	tree_height := forest[y][x]
	for i := y - 1; i >= 0; i-- {
		visible++
		if forest[i][x] >= tree_height {
			return
		}
	}
	return
}

func tree_score(forest Forest, x int, y int) int {
	return look_to_the_right(forest, x, y) * look_to_the_left(forest, x, y) * look_to_the_top(forest, x, y) * look_to_the_bottom(forest, x, y)
}

func find_best_tree(forest Forest) (score int) {
	for y, line := range forest {
		for x, _ := range line {
			if tmp := tree_score(forest, x, y); tmp > score {
				score = tmp
			}
		}
	}
	return
}

func get_forest(scanner *bufio.Scanner) (forest Forest) {
	var y int
	for scanner.Scan() {
		forest = append(forest, []int{})
		for _, c := range scanner.Text() {
			height, _ := strconv.Atoi(string(c))
			forest[y] = append(forest[y], height)
		}
		y += 1
	}
	return
}

func main() {
	forest := get_forest(bufio.NewScanner(os.Stdin))
	fmt.Println(find_best_tree(forest))
}
