package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Point struct {
	X int
	Y int
}

func (p *Point) String() string {
	return fmt.Sprintf("<X:%v, Y:%v>", p.X, p.Y)
}

type Wall struct {
	Start *Point
	End   *Point
}

func (w *Wall) String() string {
	return fmt.Sprintf("|%v->%v|", w.Start, w.End)
}

func (w *Wall) is_blocking(p *Point) bool {
	if w.Start.X == w.End.X {
		if p.X != w.Start.X {
			return false
		}
		if w.Start.Y > p.Y || p.Y > w.End.Y {
			return false
		}
	} else { // w.Start.Y == w.End.Y
		if p.Y != w.Start.Y {
			return false
		}
		if w.Start.X > p.X || p.X > w.End.X {
			return false
		}
	}
	return true
}

var grain = Point{500, 0}
var sand []Point
var walls []*Wall

func is_sand_blocking(p *Point) bool {
	for _, s := range sand {
		if s.X == p.X && s.Y == p.Y {
			return true
		}
	}
	return false
}

func is_wall_blocking(p *Point) bool {
	for _, w := range walls {
		if w.is_blocking(p) {
			return true
		}
	}
	return false
}

func move_grain() (rest bool) {
	tmp := grain
	tmp.Y++
	if is_sand_blocking(&tmp) || is_wall_blocking(&tmp) {
		tmp.X--
		if is_sand_blocking(&tmp) || is_wall_blocking(&tmp) {
			tmp.X += 2
			if is_sand_blocking(&tmp) || is_wall_blocking(&tmp) {
				return true
			}
		}
	}
	grain = tmp
	return
}

func drop_sand() {
	for {
		for !move_grain() && grain.Y < 200 { // max Y for wall in input is 180
		}
		if grain.Y >= 200 {
			return
		}
		sand = append(sand, grain)
		grain = Point{500, 0}
	}
}

func get_walls(scanner *bufio.Scanner) {
	var tmp *Point

	for scanner.Scan() {
		for _, point := range strings.Split(scanner.Text(), " -> ") {
			data := strings.Split(point, ",")
			x, _ := strconv.Atoi(data[0])
			y, _ := strconv.Atoi(data[1])
			p := new(Point)
			p.X = x
			p.Y = y
			if tmp != nil {
				w := new(Wall)
				if tmp.X < p.X || tmp.Y < p.Y {
					w.Start = tmp
					w.End = p
				} else { // p.X < tmp.X || p.Y < tmp.Y
					w.Start = p
					w.End = tmp
				}
				walls = append(walls, w)
			}
			tmp = p
		}
		tmp = nil
	}
	return
}

func main() {
	get_walls(bufio.NewScanner(os.Stdin))
	drop_sand()
	fmt.Println(len(sand))
}
