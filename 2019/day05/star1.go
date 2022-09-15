// +build star1

package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Instruction struct {
	Param1Mode int
	Param2Mode int
	Param3Mode int
	Opcode     int
}

func parse_instruction(code int) (instruction Instruction) {
	instruction.Param3Mode = code / 10000
	code %= 10000
	instruction.Param2Mode = code / 1000
	code %= 1000
	instruction.Param1Mode = code / 100
	code %= 100
	instruction.Opcode = code
	return
}

func value_with_mode(intcode []int, value, mode int) int {
	switch mode {
	case 0:
		return intcode[value]
	case 1:
		return value
	default:
		fmt.Println("Error: Bad Opcode")
		return -1
	}
}

func add(intcode []int, offset int, instruction Instruction) {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	param2 := value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	intcode[intcode[offset+3]] = param1 + param2
}

func mul(intcode []int, offset int, instruction Instruction) {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	param2 := value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	intcode[intcode[offset+3]] = param1 * param2
}

func execute_intcode(intcode []int) {
	scanner := bufio.NewScanner(os.Stdin)
	var i int
	for instruction := parse_instruction(intcode[i]); instruction.Opcode != 99; instruction = parse_instruction(intcode[i]) {
		switch instruction.Opcode {
		case 1:
			add(intcode, i, instruction)
			i += 4
		case 2:
			mul(intcode, i, instruction)
			i += 4
		case 3:
			fmt.Print("enter input : ")
			scanner.Scan()
			intcode[intcode[i+1]], _ = strconv.Atoi(scanner.Text())
			i += 2
		case 4:
			fmt.Println(value_with_mode(intcode, intcode[i+1], instruction.Param1Mode))
			i += 2
		}
	}
}

func generate_intcode(sa []string) []int {
	var intcode []int

	for _, s := range sa {
		value, _ := strconv.Atoi(s)
		intcode = append(intcode, value)
	}

	return intcode
}

func main() {
	file, _ := os.Open("input")
	scanner := bufio.NewScanner(file)
	scanner.Scan()
	input_array := strings.Split(scanner.Text(), ",")
	intcode := generate_intcode(input_array)
	execute_intcode(intcode)
}
