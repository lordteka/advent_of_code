// +build star1

package main

import (
	"fmt"
)

func amp(intcode []int, phase, input int) int {
	Stream <- phase
	Stream <- input
	ExecuteIntcode(intcode)
	return <-Stream
}

func run_amps(intcode []int, a, b, c, d, e int) int {
	output := amp(append([]int(nil), intcode...), a, 0)
	output = amp(append([]int(nil), intcode...), b, output)
	output = amp(append([]int(nil), intcode...), c, output)
	output = amp(append([]int(nil), intcode...), d, output)
	return amp(append([]int(nil), intcode...), e, output)
}

func try_all_phase(intcode []int) (max_output int) {
	for a := 0; a < 5; a++ {
		for b := 0; b < 5; b++ {
			for c := 0; c < 5; c++ {
				for d := 0; d < 5; d++ {
					for e := 0; e < 5; e++ {
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
