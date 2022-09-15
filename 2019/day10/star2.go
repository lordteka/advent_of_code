// +build star2

package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"sort"
)

type Asteroid struct {
	X int
	Y int
}

type Vector Asteroid

var Asteroids []Asteroid

func blocked(c, a, b Asteroid) bool {
	v_ac := Vector{c.X - a.X, c.Y - a.Y}
	v_ab := Vector{b.X - a.X, b.Y - a.Y}
	v_ca := Vector{a.X - c.X, a.Y - c.Y}
	v_cb := Vector{b.X - c.X, b.Y - c.Y}
	return (v_ac.X*v_ab.Y-v_ab.X*v_ac.Y) == 0 && (v_ca.X*v_cb.X+v_ca.Y*v_cb.Y) <= 0
}
func count_seen(a1 Asteroid) (count int) {
	var seen bool
	for _, a2 := range Asteroids {
		if a1.X == a2.X && a1.Y == a2.Y {
			continue
		}
		seen = true
		for _, a := range Asteroids {
			if (a.X == a1.X && a.Y == a1.Y) || (a.X == a2.X && a.Y == a2.Y) {
				continue
			}
			seen = seen && !blocked(a, a1, a2)
		}
		if seen {
			count++
		}
	}
	return
}

func seen(a1 Asteroid) (to_destroy []int) {
	var seen bool
	for i, a2 := range Asteroids {
		if a1.X == a2.X && a1.Y == a2.Y {
			continue
		}
		seen = true
		for _, a := range Asteroids {
			if (a.X == a1.X && a.Y == a1.Y) || (a.X == a2.X && a.Y == a2.Y) {
				continue
			}
			seen = seen && !blocked(a, a1, a2)
		}
		if seen {
			to_destroy = append(to_destroy, i)
		}
	}
	return
}

func vector(a1, a2 Asteroid) Vector {
	return Vector{a1.X - a2.X, a1.Y - a2.Y}
}

func dot_product(v1, v2 Vector) int {
	return v1.X*v2.X + v1.Y*v2.Y
}

func cross_product(v1, v2 Vector) int {
	return v1.X*v2.Y - v1.Y*v2.X
}

func angle(v1, v2 Vector) float64 {
	a := math.Atan2(float64(cross_product(v1, v2)), float64(dot_product(v1, v2)))
	if a < 0 {
		return a + 2*math.Pi
	}
	return a
}

func get_angles(station Asteroid, a_indexes []int) (angles []float64) {
	y_axis := vector(station, Asteroid{station.X, station.Y - 1})
	for _, i := range a_indexes {
		angles = append(angles, angle(y_axis, vector(station, Asteroids[i])))
	}
	return
}

func destroy(to_destroy []int) {
	for i, a_index := range to_destroy {
		Asteroids = append(Asteroids[:a_index-i], Asteroids[a_index+1-i:]...)
	}
}

// don’t ask
type AngleOfIndex struct {
	Angle float64
	Index int
}

type AngleOfIndexes []AngleOfIndex

func (s AngleOfIndexes) Len() int {
	return len(s)
}

func (s AngleOfIndexes) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s AngleOfIndexes) Less(i, j int) bool {
	return s[i].Angle < s[j].Angle
}

func find_200th_destroyed_asteroid_from(station Asteroid) Asteroid {
	var to_destroy []int
	var destroyed_count int
	for len(to_destroy)+destroyed_count < 200 {
		destroyed_count += len(to_destroy)
		destroy(to_destroy)
		to_destroy = seen(station)
	}
	angles := get_angles(station, to_destroy)
	var final_slice AngleOfIndexes
	for i := 0; i < len(to_destroy); i++ {
		final_slice = append(final_slice, AngleOfIndex{angles[i], to_destroy[i]})
	}
	sort.Sort(final_slice)
	fmt.Println(final_slice)
	return Asteroids[final_slice[200-destroyed_count-1].Index]
}

func monitoring_station() (station Asteroid) {
	var count int
	for _, a := range Asteroids {
		if tmp := count_seen(a); tmp > count {
			count = tmp
			station = a
		}
	}
	return
}

func get_asteroids(filename string) {
	file, _ := os.Open(filename)
	scanner := bufio.NewScanner(file)
	var y int
	for scanner.Scan() {
		for x, c := range scanner.Text() {
			if c == '#' {
				Asteroids = append(Asteroids, Asteroid{x, y})
			}
		}
		y++
	}
	return
}

func main() {
	get_asteroids("input")
	station := monitoring_station()
	fmt.Println(find_200th_destroyed_asteroid_from(station))
}
