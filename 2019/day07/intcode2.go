// +build star2

package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type Instruction struct {
	Param1Mode int
	Param2Mode int
	Param3Mode int
	Opcode     int
}

func value_with_mode(intcode []int, value, mode int) int {
	switch mode {
	case 0:
		return intcode[value]
	case 1:
		return value
	default:
		fmt.Println("Error: Bad Mode")
		return -1
	}
}

func add(intcode []int, offset int, instruction Instruction) int {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	param2 := value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	intcode[intcode[offset+3]] = param1 + param2
	return offset + 4
}

func mul(intcode []int, offset int, instruction Instruction) int {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	param2 := value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	intcode[intcode[offset+3]] = param1 * param2
	return offset + 4
}

func jump_if_true(intcode []int, offset int, instruction Instruction) int {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	if param1 != 0 {
		return value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	}
	return offset + 3
}

func jump_if_false(intcode []int, offset int, instruction Instruction) int {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	if param1 == 0 {
		return value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	}
	return offset + 3
}

func less_than(intcode []int, offset int, instruction Instruction) int {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	param2 := value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	if param1 < param2 {
		intcode[intcode[offset+3]] = 1
	} else {
		intcode[intcode[offset+3]] = 0
	}
	return offset + 4
}

func equals(intcode []int, offset int, instruction Instruction) int {
	param1 := value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
	param2 := value_with_mode(intcode, intcode[offset+2], instruction.Param2Mode)
	if param1 == param2 {
		intcode[intcode[offset+3]] = 1
	} else {
		intcode[intcode[offset+3]] = 0
	}
	return offset + 4
}

var Procs [9]func([]int, int, Instruction) int = [9]func([]int, int, Instruction) int{
	nil,           // opcode 0
	add,           // opcode 1
	mul,           // opcode 2
	nil,           //input,   // opcode 3
	nil,           //output,  // opcode 4
	jump_if_true,  // opcode 5
	jump_if_false, // opcode 6
	less_than,     // opcode 6
	equals,        // opcode 7
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

func ExecuteIntcode(intcode []int, read, write chan int, amp int) {
	var offset int
	for instruction := parse_instruction(intcode[offset]); instruction.Opcode != 99; instruction = parse_instruction(intcode[offset]) {
		switch instruction.Opcode {
		case 0: // WTF ??
			return
		case 3:
			intcode[intcode[offset+1]] = <-read
			offset += 2
		case 4:
			write <- value_with_mode(intcode, intcode[offset+1], instruction.Param1Mode)
			offset += 2
		default:
			offset = Procs[instruction.Opcode](intcode, offset, instruction)
		}
	}
}

func GenerateIntcode(filename string) (intcode []int) {
	content, _ := ioutil.ReadFile(filename)
	code_array := strings.Split(string(content), ",")

	for _, s := range code_array {
		value, _ := strconv.Atoi(s)
		intcode = append(intcode, value)
	}

	return
}
