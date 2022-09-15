package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type star_1Command struct {
	Direction string
	Distance  int
}

type star_1Path []star_1Command

type star_1Segment struct {
	Horizontal bool
	Position   int
	Bounds     [2]int
}

type star_1Point struct {
	X int
	Y int
}

// f*cking useless, we should calculate the manhattan distance in the get_intersections method ; see star2
func star_1smallest_manhattan_distance(intersections []star_1Point) int {
	smallest := intersections[0].X + intersections[0].Y
	for _, point := range intersections {
		if point.X+point.Y < smallest {
			smallest = point.X + point.Y
		}
	}
	return smallest
}

func star_1get_intersections(segments_from_path1, segments_from_path2 []star_1Segment) (intersections []star_1Point) {
	for _, s1 := range segments_from_path1 {
		for _, s2 := range segments_from_path2 {
			if s1.Horizontal == !s2.Horizontal &&
				s2.Bounds[0] < s1.Position && s1.Position < s2.Bounds[1] &&
				s1.Bounds[0] < s2.Position && s2.Position < s1.Bounds[1] {
				// we should check which segment is horizontal to know which positions are the x and the y but it won’t change the manhattan distance so whatever
				intersections = append(intersections, star_1Point{s1.Position, s2.Position})
			}
		}
	}
	return
}

func star_1path_to_segments(path star_1Path) (segments []star_1Segment) {
	var x int
	var y int
	for _, command := range path {
		switch command.Direction {
		case "U":
			segments = append(segments, star_1Segment{false, x, [2]int{y, y + command.Distance}})
			y += command.Distance
		case "D":
			segments = append(segments, star_1Segment{false, x, [2]int{y - command.Distance, y}})
			y -= command.Distance
		case "R":
			segments = append(segments, star_1Segment{true, y, [2]int{x, x + command.Distance}})
			x += command.Distance
		case "L":
			segments = append(segments, star_1Segment{true, y, [2]int{x - command.Distance, x}})
			x -= command.Distance
		}
	}
	return
}

func star_1string_to_path(input string) (output star_1Path) {
	for _, command := range strings.Split(input, ",") {
		direction := string(command[0])
		distance, _ := strconv.Atoi(command[1:])
		output = append(output, star_1Command{direction, distance})
	}
	return
}

func star_1get_wire_paths() (paths [2]star_1Path) {
	content, _ := ioutil.ReadFile("input")
	lines := strings.Split(string(content), "\n")
	paths[0] = star_1string_to_path(lines[0])
	paths[1] = star_1string_to_path(lines[1])
	return
}

func star_1main() {
	paths := star_1get_wire_paths()
	fmt.Println(star_1smallest_manhattan_distance(star_1get_intersections(star_1path_to_segments(paths[0]), star_1path_to_segments(paths[1]))))
}
