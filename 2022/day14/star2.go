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
var floor int

func is_sand_blocking(p *Point) (m bool, l bool, r bool) {
	for _, s := range sand {
		if m && l && r {
			return
		}
		if s.Y == p.Y {
			if !m && s.X == p.X {
				m = true
			}
			if !l && s.X == p.X-1 {
				l = true
			}
			if !r && s.X == p.X+1 {
				r = true
			}
		}
	}
	return
}

func is_wall_blocking(p *Point) (m bool, l bool, r bool) {
	tmp := *p
	tmp_l := Point{tmp.X - 1, tmp.Y}
	tmp_r := Point{tmp.X + 1, tmp.Y}
	for _, w := range walls {
		if m && l && r {
			return
		}
		if !m && w.is_blocking(&tmp) {
			m = true
		}
		if !l && w.is_blocking(&tmp_l) {
			l = true
		}
		if !r && w.is_blocking(&tmp_r) {
			r = true
		}
	}
	return
}

func move_grain() (rest bool) {
	tmp := grain
	tmp.Y++
	if tmp.Y >= floor {
		return true
	}
	w_m, w_l, w_r := is_wall_blocking(&tmp)
	s_m, s_l, s_r := is_sand_blocking(&tmp)
	if w_m || s_m {
		tmp.X--
		if w_l || s_l {
			tmp.X += 2
			if w_r || s_r {
				return true
			}
		}
	}
	grain = tmp
	return
}

func drop_sand() {
	for {
		for !move_grain() && !(grain.X == 500 && grain.Y == 0) {
		}
		if grain.X == 500 && grain.Y == 0 {
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

func max_y() (max int) {
	for _, w := range walls {
		if max < w.End.Y {
			max = w.End.Y
		}
	}
	return
}

func main() {
	get_walls(bufio.NewScanner(os.Stdin))
	floor = max_y() + 2
	drop_sand()
	fmt.Println(len(sand) + 1)
}
