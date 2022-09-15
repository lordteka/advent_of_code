// +build star1

package main

import (
	"bufio"
	"fmt"
	"os"
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

func most_seen() (count int) {
	for _, a := range Asteroids {
		if tmp := count_seen(a); tmp > count {
			count = tmp
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
	fmt.Println(most_seen())
}
