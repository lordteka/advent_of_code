// +build star2

package main

import (
	"fmt"
)

const (
	Left = iota
	Right
	Up
	Down
)

const (
	Black = iota
	White
)

type Pos struct {
	X int
	Y int
}

type Case struct {
	Coord Pos
	Color int
}

type Robot struct {
	Position Pos
	Facing   int
}

var Bob Robot = Robot{Pos{0, 0}, Up}

func turn_right() {
	switch Bob.Facing {
	case Up:
		Bob.Facing = Right
		Bob.Position.X++
	case Right:
		Bob.Facing = Down
		Bob.Position.Y--
	case Down:
		Bob.Facing = Left
		Bob.Position.X--
	case Left:
		Bob.Facing = Up
		Bob.Position.Y++
	}
}

func turn_left() {
	switch Bob.Facing {
	case Up:
		Bob.Facing = Left
		Bob.Position.X--
	case Left:
		Bob.Facing = Down
		Bob.Position.Y--
	case Down:
		Bob.Facing = Right
		Bob.Position.X++
	case Right:
		Bob.Facing = Up
		Bob.Position.Y++
	}
}

func turn(turn_direction int) {
	if turn_direction == Left {
		turn_left()
	} else {
		turn_right()
	}
}

func paint(color int, case_ Case) Case {
	case_.Color = color
	return case_
}

var CaseHistoric []Case

func next_case() Case {
	for _, case_ := range CaseHistoric {
		if case_.Coord.X == Bob.Position.X && case_.Coord.Y == Bob.Position.Y {
			return case_
		}
	}
	return Case{Pos{Bob.Position.X, Bob.Position.Y}, Black}
}

func add_case_to_historic(case_ Case) {
	for i := range CaseHistoric {
		if CaseHistoric[i].Coord.X == case_.Coord.X && CaseHistoric[i].Coord.Y == case_.Coord.Y {
			CaseHistoric[i].Color = case_.Color
			return
		}
	}
	CaseHistoric = append(CaseHistoric, case_)
}

func paint_and_turn(current_case Case) {
	var open bool
	var color int
	var direction int
	for {
		IntcodeInput <- current_case.Color
		color, open = <-IntcodeOutput
		if !open {
			return
		}
		current_case = paint(color, current_case)
		add_case_to_historic(current_case)
		direction, open = <-IntcodeOutput
		if !open {
			return
		}
		turn(direction)
		current_case = next_case()
	}
}

func get_bounds() (max_x, min_y int) {
	for _, case_ := range CaseHistoric {
		if case_.Coord.X > max_x {
			max_x = case_.Coord.X
		}
		if case_.Coord.Y < min_y {
			min_y = case_.Coord.Y
		}
	}
	return
}

func get_color(x, y int) int {
	for _, case_ := range CaseHistoric {
		if case_.Coord.X == x && case_.Coord.Y == y {
			return case_.Color
		}
	}
	return Black
}

func get_code() (code string) {
	max_x, min_y := get_bounds()
	for y := 0; y >= min_y; y-- {
		for x := 0; x <= max_x; x++ {
			switch get_color(x, y) {
			case White:
				code += "♥"
			case Black:
				code += " "
			}
		}
		code += "\n"
	}
	return
}

func main() {
	GenerateIntcode("input")
	go ExecuteIntcode()
	paint_and_turn(Case{Pos{0, 0}, White})
	fmt.Println(get_code())
}
