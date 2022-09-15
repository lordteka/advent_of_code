package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type Command struct {
	Direction string
	Distance  int
}

type Path []Command

type Vector struct {
	IsHorizontal        bool
	DirectionIsReversed bool
	Position            int
	Bounds              [2]int
	PreviousStepNumber  int
}

func combined_step_number(horizontal, vertical Vector, x, y int) (steps int) {
	steps = horizontal.PreviousStepNumber + vertical.PreviousStepNumber
	if horizontal.DirectionIsReversed {
		steps += horizontal.Bounds[1] - y
	} else {
		steps += y - horizontal.Bounds[0]
	}
	if vertical.DirectionIsReversed {
		steps += vertical.Bounds[1] - x
	} else {
		steps += x - vertical.Bounds[0]
	}
	return
}

func smallest_combined_step_number(vectors_from_path1, vectors_from_path2 []Vector) (smallest int) {
	var steps int

	for _, v1 := range vectors_from_path1 {
		for _, v2 := range vectors_from_path2 {
			if v1.IsHorizontal == !v2.IsHorizontal &&
				v2.Bounds[0] < v1.Position && v1.Position < v2.Bounds[1] &&
				v1.Bounds[0] < v2.Position && v2.Position < v1.Bounds[1] {
				if v1.IsHorizontal {
					steps = combined_step_number(v1, v2, v1.Position, v2.Position)
				} else {
					steps = combined_step_number(v2, v1, v2.Position, v1.Position)
				}
				if steps < smallest || smallest == 0 {
					smallest = steps
				}
			}
		}
	}
	return
}

func path_to_vectors(path Path) (vectors []Vector) {
	var x int
	var y int
	var steps int
	for _, command := range path {
		switch command.Direction {
		case "U":
			vectors = append(vectors, Vector{false, false, x, [2]int{y, y + command.Distance}, steps})
			y += command.Distance
		case "D":
			vectors = append(vectors, Vector{false, true, x, [2]int{y - command.Distance, y}, steps})
			y -= command.Distance
		case "R":
			vectors = append(vectors, Vector{true, false, y, [2]int{x, x + command.Distance}, steps})
			x += command.Distance
		case "L":
			vectors = append(vectors, Vector{true, true, y, [2]int{x - command.Distance, x}, steps})
			x -= command.Distance
		}
		steps += command.Distance
	}
	return
}

func string_to_path(input string) (output Path) {
	for _, command := range strings.Split(input, ",") {
		direction := string(command[0])
		distance, _ := strconv.Atoi(command[1:])
		output = append(output, Command{direction, distance})
	}
	return
}

func get_wire_paths() (paths [2]Path) {
	content, _ := ioutil.ReadFile("input")
	lines := strings.Split(string(content), "\n")
	paths[0] = string_to_path(lines[0])
	paths[1] = string_to_path(lines[1])
	return
}

func star_2main() {
	paths := get_wire_paths()
	fmt.Println(smallest_combined_step_number(path_to_vectors(paths[0]), path_to_vectors(paths[1])))
}

func main() {
	//star_1main()
	star_2main()
}
