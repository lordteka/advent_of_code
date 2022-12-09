package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Knot struct {
	X int
	Y int
}

var rope [10]Knot

var visited = map[Knot]bool{Knot{0, 0}: true}

func is_inside(list []Knot, knot Knot) bool {
	for _, o := range list {
		if o.X == knot.X && o.Y == knot.Y {
			return true
		}
	}
	return false
}

func is_touching(i int) bool {
	surrounding := []Knot{
		Knot{rope[i-1].X - 1, rope[i-1].Y - 1}, Knot{rope[i-1].X, rope[i-1].Y - 1}, Knot{rope[i-1].X + 1, rope[i-1].Y - 1},
		Knot{rope[i-1].X - 1, rope[i-1].Y}, rope[i-1], Knot{rope[i-1].X + 1, rope[i-1].Y},
		Knot{rope[i-1].X - 1, rope[i-1].Y + 1}, Knot{rope[i-1].X, rope[i-1].Y + 1}, Knot{rope[i-1].X + 1, rope[i-1].Y + 1},
	}

	return is_inside(surrounding, rope[i])
}

func move_straight(i int) {
	if rope[i].X == rope[i-1].X {
		if rope[i].Y > rope[i-1].Y {
			rope[i].Y--
		} else { // rope[i].Y < rope[i-1].Y
			rope[i].Y++
		}
	} else { // rope[i].Y == rope[i-1].Y
		if rope[i].X > rope[i-1].X {
			rope[i].X--
		} else { // rope[i].X < rope[i-1].X
			rope[i].X++
		}
	}
}

func move_diagonally(i int) {
	if rope[i-1].X > rope[i].X && rope[i-1].Y > rope[i].Y {
		rope[i].X++
		rope[i].Y++
	} else if rope[i-1].X < rope[i].X && rope[i-1].Y < rope[i].Y {
		rope[i].X--
		rope[i].Y--
	} else if rope[i-1].X < rope[i].X && rope[i-1].Y > rope[i].Y {
		rope[i].X--
		rope[i].Y++
	} else { // rope[i-1].X > rope[i].X && rope[i-1].Y < rope[i].Y
		rope[i].X++
		rope[i].Y--
	}
}

func move_tail() {
	for i := 1; i < 10; i++ {
		if is_touching(i) {
			return
		}

		if rope[i].X == rope[i-1].X || rope[i].Y == rope[i-1].Y {
			move_straight(i)
		} else {
			move_diagonally(i)
		}
	}
	visited[rope[9]] = true
}

func move_head(direction string, amount int) {
	for i := 0; i < amount; i++ {
		switch direction {
		case "R":
			rope[0].X++
		case "L":
			rope[0].X--
		case "D":
			rope[0].Y++
		case "U":
			rope[0].Y--
		default:
			fmt.Println("Bad direction")
		}
		move_tail()
	}
}

func count_visited() (sum int) {
	for range visited {
		sum++
	}
	return
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		data := strings.Split(scanner.Text(), " ")
		amount, _ := strconv.Atoi(data[1])
		move_head(data[0], amount)
	}
	fmt.Println(count_visited())
}
