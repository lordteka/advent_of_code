// +build star1

package main

import (
	"fmt"
)

type Tile struct {
	X  int
	Y  int
	Id int
}

var Map []Tile

func build_map() {
	for {
		x, open := <-IntcodeOutput
		if !open {
			return
		}
		y := <-IntcodeOutput
		id := <-IntcodeOutput
		Map = append(Map, Tile{x, y, id})
	}
}

func count_block_tile() (count int) {
	for _, t := range Map {
		if t.Id == 2 {
			count++
		}
	}
	return
}

func main() {
	GenerateIntcode("input")
	go ExecuteIntcode()
	build_map()
	fmt.Println(count_block_tile())
}
