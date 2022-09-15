package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func fuelAmountNeeded(mass int) int {
	var total int
	mass = (mass / 3) - 2
	for mass > 0 {
		total += mass
		mass = (mass / 3) - 2
	}
	return total
}

func main() {
	file, _ := os.Open("input")
	scanner := bufio.NewScanner(file)
	var sum int
	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		sum += fuelAmountNeeded(num)
	}
	fmt.Println(sum)
}
