// +build star2

package main

import (
	"fmt"
	"io/ioutil"
)

type Layer [6][25]int

type Image []Layer

func (layer Layer) String() (image string) {
	for y := range layer {
		for x := range layer[y] {
			switch layer[y][x] {
			case 0:
				image += " "
			case 1:
				image += "♥"
			}
		}
		image += "\n"
	}
	return
}

func combine_layer(image Image) (layer Layer) {
	var i int
	for y := 0; y < 6; y++ {
		for x := 0; x < 25; x++ {
			i = 0
			for image[i][y][x] == 2 {
				i++
			}
			layer[y][x] = image[i][y][x]
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
	fmt.Println(combine_layer(image))
}
