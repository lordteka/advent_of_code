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

func (p *Pos) update(distance int, height byte) {
	if p.Height >= height && p.DistanceFromStart > distance {
		p.DistanceFromStart = distance
	}
}

type Area [][]*Pos

var starts []*Pos
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

func update_neighbours(pos *Pos, area Area) {
	if pos.X > 0 {
		area[pos.Y][pos.X-1].update(pos.DistanceFromStart+1, pos.Height-1)
	}
	if pos.Y > 0 {
		area[pos.Y-1][pos.X].update(pos.DistanceFromStart+1, pos.Height-1)
	}
	if pos.X < len(area[0])-1 {
		area[pos.Y][pos.X+1].update(pos.DistanceFromStart+1, pos.Height-1)
	}
	if pos.Y < len(area)-1 {
		area[pos.Y+1][pos.X].update(pos.DistanceFromStart+1, pos.Height-1)
	}
}

func map_area(area Area) {
	end.DistanceFromStart = 0
	for {
		x, y, found := next_pos(area)
		if !found {
			return
		}
		area[y][x].Visited = true
		update_neighbours(area[y][x], area)
	}
}

func find_best_path(area Area) (min int) {
	min = 1_000_000_001
	map_area(area)
	for _, s := range starts {
		if s.DistanceFromStart < min {
			min = s.DistanceFromStart
		}
	}
	return
}

func get_area(scanner *bufio.Scanner) (area Area) {
	var y int
	for scanner.Scan() {
		area = append(area, []*Pos{})
		for x, c := range scanner.Text() {
			pos := new(Pos)
			pos.X = x
			pos.Y = y
			pos.DistanceFromStart = 1_000_000_000
			switch c {
			case 'S':
				pos.Height = 'a'
				starts = append(starts, pos)
				area[y] = append(area[y], pos)
			case 'a':
				pos.Height = 'a'
				starts = append(starts, pos)
				area[y] = append(area[y], pos)
			case 'E':
				pos.Height = 'z'
				end = pos
				area[y] = append(area[y], end)
			default:
				pos.Height = byte(c)
				area[y] = append(area[y], pos)
			}
		}
		y++
	}
	return
}

func main() {
	area := get_area(bufio.NewScanner(os.Stdin))
	fmt.Println(find_best_path(area))
}
