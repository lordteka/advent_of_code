// +build star2

package main

import (
	"fmt"
)

func run_amps(intcode []int, a, b, c, d, e int) int {
	atob := make(chan int, 1)
	btoc := make(chan int, 1)
	ctod := make(chan int, 1)
	dtoe := make(chan int, 1)
	etoa := make(chan int, 1)

	etoa <- a
	atob <- b
	btoc <- c
	ctod <- d
	dtoe <- e
	go ExecuteIntcode(append([]int(nil), intcode...), etoa, atob, a)
	etoa <- 0
	go ExecuteIntcode(append([]int(nil), intcode...), atob, btoc, b)
	go ExecuteIntcode(append([]int(nil), intcode...), btoc, ctod, c)
	go ExecuteIntcode(append([]int(nil), intcode...), ctod, dtoe, d)
	ExecuteIntcode(append([]int(nil), intcode...), dtoe, etoa, e)
	return <-etoa
}

func try_all_phase(intcode []int) (max_output int) {
	for a := 5; a < 10; a++ {
		for b := 5; b < 10; b++ {
			for c := 5; c < 10; c++ {
				for d := 5; d < 10; d++ {
					for e := 5; e < 10; e++ {
						if a != b && a != c && a != d && a != e &&
							b != c && b != d && b != e &&
							c != d && c != e && d != e {
							if output := run_amps(intcode, a, b, c, d, e); output > max_output {
								max_output = output
							}
						}
					}
				}
			}
		}
	}
	return
}

func main() {
	intcode := GenerateIntcode("input")
	fmt.Println(try_all_phase(intcode))
}
