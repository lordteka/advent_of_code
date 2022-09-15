// +build star2

package main

import (
	"fmt"
)

func beat_the_game() (score int) {
	var paddle_x int
	for {
		x, open := <-IntcodeOutput
		if !open {
			return
		}
		y := <-IntcodeOutput
		id := <-IntcodeOutput
		switch id {
		case 3:
			paddle_x = x
		case 4: // make the paddle follow the ball
			if paddle_x > x {
				IntcodeInput <- -1
			} else if paddle_x < x {
				IntcodeInput <- 1
			} else {
				IntcodeInput <- 0
			}
		}
		if x == -1 && y == 0 {
			score = id
		}
	}
}

func main() {
	GenerateIntcode("input")
	Intcode[0] = 2
	go ExecuteIntcode()
	fmt.Println(beat_the_game())
}
