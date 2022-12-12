package main

import (
	"bufio"
	"fmt"
	"os"
)

type Pos struct {
	X                 int
	Y                 int
	Height            byte
	Visited           bool
	DistanceFromStart int
}

type Area [][]*Pos

var start *Pos
var end *Pos

func next_pos(area Area) (x, y int, found bool) {
	min := 1_000_000_001
	for _, line := range area {
		for _, pos := range line {
			if !pos.Visited && pos.DistanceFromStart < min {
				min = pos.DistanceFromStart
				x, y = pos.X, pos.Y
				found = true
			}
		}
	}
	return
}

func update_neighbour(pos *Pos, area Area) {
	if pos.X > 0 && pos.Height+1 >= area[pos.Y][pos.X-1].Height {
		area[pos.Y][pos.X-1].DistanceFromStart = pos.DistanceFromStart + 1
	}
	if pos.Y > 0 && pos.Height+1 >= area[pos.Y-1][pos.X].Height {
		area[pos.Y-1][pos.X].DistanceFromStart = pos.DistanceFromStart + 1
	}
	if pos.X < len(area[0])-1 && pos.Height+1 >= area[pos.Y][pos.X+1].Height {
		area[pos.Y][pos.X+1].DistanceFromStart = pos.DistanceFromStart + 1
	}
	if pos.Y < len(area)-1 && pos.Height+1 >= area[pos.Y+1][pos.X].Height {
		area[pos.Y+1][pos.X].DistanceFromStart = pos.DistanceFromStart + 1
	}
}

func find_path(area Area) {
	for {
		x, y, found := next_pos(area)
		if !found || (x == end.X && y == end.Y) {
			return
		}
		area[y][x].Visited = true
		update_neighbour(area[y][x], area)
	}
}

func get_area(scanner *bufio.Scanner) (area Area) {
	var y int
	for scanner.Scan() {
		area = append(area, []*Pos{})
		for x, c := range scanner.Text() {
			pos := new(Pos)
			pos.X = x
			pos.Y = y
			switch c {
			case 'S':
				pos.Height = 'a'
				start = pos
				area[y] = append(area[y], start)
			case 'E':
				pos.Height = 'z'
				pos.DistanceFromStart = 1_000_000_000
				end = pos
				area[y] = append(area[y], end)
			default:
				pos.Height = byte(c)
				pos.DistanceFromStart = 1_000_000_000
				area[y] = append(area[y], pos)
			}
		}
		y++
	}
	return
}

func main() {
	area := get_area(bufio.NewScanner(os.Stdin))
	find_path(area)
	fmt.Println(end)
}
