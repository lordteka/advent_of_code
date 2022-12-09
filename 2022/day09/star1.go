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

var head Knot
var tail Knot

var visited = map[Knot]bool{Knot{0, 0}: true}

func is_inside(list []Knot, knot Knot) bool {
	for _, o := range list {
		if o.X == knot.X && o.Y == knot.Y {
			return true
		}
	}
	return false
}

func is_touching() bool {
	surrounding := []Knot{
		Knot{head.X - 1, head.Y - 1}, Knot{head.X, head.Y - 1}, Knot{head.X + 1, head.Y - 1},
		Knot{head.X - 1, head.Y}, head, Knot{head.X + 1, head.Y},
		Knot{head.X - 1, head.Y + 1}, Knot{head.X, head.Y + 1}, Knot{head.X + 1, head.Y + 1},
	}

	return is_inside(surrounding, tail)
}

func move_straight() {
	if tail.X == head.X {
		if tail.Y > head.Y {
			tail.Y--
		} else { // tail.Y < head.Y
			tail.Y++
		}
	} else { // tail.Y == head.Y
		if tail.X > head.X {
			tail.X--
		} else { // tail.X < head.X
			tail.X++
		}
	}
}

func move_diagonally() {
	if head.X > tail.X && head.Y > tail.Y {
		tail.X++
		tail.Y++
	} else if head.X < tail.X && head.Y < tail.Y {
		tail.X--
		tail.Y--
	} else if head.X < tail.X && head.Y > tail.Y {
		tail.X--
		tail.Y++
	} else { // head.X > tail.X && head.Y < tail.Y
		tail.X++
		tail.Y--
	}
}

func move_tail() {
	if is_touching() {
		return
	}

	if tail.X == head.X || tail.Y == head.Y {
		move_straight()
	} else {
		move_diagonally()
	}
	visited[tail] = true
}

func move_head(direction string, amount int) {
	for i := 0; i < amount; i++ {
		switch direction {
		case "R":
			head.X++
		case "L":
			head.X--
		case "D":
			head.Y++
		case "U":
			head.Y--
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
