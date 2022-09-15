// +build star1

package main

import (
	"fmt"
	"io/ioutil"
)

type Layer [6][25]int

type Image []Layer

func find_occurrence_from_layer(layer Layer, digit int) (occurrence int) {
	for y := range layer {
		for x := range layer[y] {
			if layer[y][x] == digit {
				occurrence++
			}
		}
	}
	return
}

func find_fewest_zero_layer(image Image) (layer Layer) {
	var zero_number int
	lowest_zero_number := find_occurrence_from_layer(image[0], 0)
	for _, l := range image {
		zero_number = find_occurrence_from_layer(l, 0)
		if zero_number < lowest_zero_number {
			lowest_zero_number = zero_number
			layer = l
		}
	}
	return
}

func build_image(pixels string) (image Image) {
	var x int
	var y int
	layer := Layer{}
	for _, p := range pixels {
		layer[y][x] = int(p) - int('0')
		x++
		if x >= 25 {
			x = 0
			y++
		}
		if y >= 6 {
			x = 0
			y = 0
			image = append(image, layer)
			layer = Layer{}
		}
	}
	return
}

func main() {
	image_pixels, _ := ioutil.ReadFile("input")
	image := build_image(string(image_pixels))
	layer := find_fewest_zero_layer(image)
	fmt.Println(find_occurrence_from_layer(layer, 1) * find_occurrence_from_layer(layer, 2))
}
