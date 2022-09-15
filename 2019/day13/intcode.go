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

var RelativeBase int = 0

var Intcode []int

func extend_intcode(offset int) {
	Intcode = append(Intcode, make([]int, offset-len(Intcode)+3)...)
}

func at(offset, mode int) (value_with_mode int) {
	switch mode {
	case 0:
		if offset >= len(Intcode) {
			extend_intcode(offset)
		}
		value_with_mode = Intcode[offset]
	case 1:
		value_with_mode = offset
	case 2:
		if offset >= len(Intcode) || RelativeBase+Intcode[offset] >= len(Intcode) {
			extend_intcode(RelativeBase + offset)
		}
		value_with_mode = Intcode[offset] + RelativeBase
	default:
		fmt.Println("Error: Bad Mode")
		return -1
	}
	if value_with_mode >= len(Intcode) {
		extend_intcode(value_with_mode)
	}
	return
}

func add(offset int, instruction Instruction) int {
	param1 := Intcode[at(offset+1, instruction.Param1Mode)]
	param2 := Intcode[at(offset+2, instruction.Param2Mode)]
	Intcode[at(offset+3, instruction.Param3Mode)] = param1 + param2
	return offset + 4
}

func mul(offset int, instruction Instruction) int {
	param1 := Intcode[at(offset+1, instruction.Param1Mode)]
	param2 := Intcode[at(offset+2, instruction.Param2Mode)]
	Intcode[at(offset+3, instruction.Param3Mode)] = param1 * param2
	return offset + 4
}

var IntcodeInput chan int = make(chan int, 1)

func input(offset int, instruction Instruction) int {
	Intcode[at(offset+1, instruction.Param1Mode)] = <-IntcodeInput
	return offset + 2
}

var IntcodeOutput chan int = make(chan int, 3)

func output(offset int, instruction Instruction) int {
	IntcodeOutput <- Intcode[at(offset+1, instruction.Param1Mode)]
	return offset + 2
}

func jump_if_true(offset int, instruction Instruction) int {
	param1 := Intcode[at(offset+1, instruction.Param1Mode)]
	if param1 != 0 {
		return Intcode[at(offset+2, instruction.Param2Mode)]
	}
	return offset + 3
}

func jump_if_false(offset int, instruction Instruction) int {
	param1 := Intcode[at(offset+1, instruction.Param1Mode)]
	if param1 == 0 {
		return Intcode[at(offset+2, instruction.Param2Mode)]
	}
	return offset + 3
}

func less_than(offset int, instruction Instruction) int {
	param1 := Intcode[at(offset+1, instruction.Param1Mode)]
	param2 := Intcode[at(offset+2, instruction.Param2Mode)]
	if param1 < param2 {
		Intcode[at(offset+3, instruction.Param3Mode)] = 1
	} else {
		Intcode[at(offset+3, instruction.Param3Mode)] = 0
	}
	return offset + 4
}

func equals(offset int, instruction Instruction) int {
	param1 := Intcode[at(offset+1, instruction.Param1Mode)]
	param2 := Intcode[at(offset+2, instruction.Param2Mode)]
	if param1 == param2 {
		Intcode[at(offset+3, instruction.Param3Mode)] = 1
	} else {
		Intcode[at(offset+3, instruction.Param3Mode)] = 0
	}
	return offset + 4
}

func add_to_base(offset int, instruction Instruction) int {
	RelativeBase += Intcode[at(offset+1, instruction.Param1Mode)]
	return offset + 2
}

var Procs [10]func(int, Instruction) int = [10]func(int, Instruction) int{
	nil,           // opcode 0
	add,           // opcode 1
	mul,           // opcode 2
	input,         // opcode 3
	output,        // opcode 4
	jump_if_true,  // opcode 5
	jump_if_false, // opcode 6
	less_than,     // opcode 7
	equals,        // opcode 8
	add_to_base,   // opcode 9
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

func ExecuteIntcode() {
	var offset int
	for instruction := parse_instruction(Intcode[offset]); instruction.Opcode != 99; instruction = parse_instruction(Intcode[offset]) {
		offset = Procs[instruction.Opcode](offset, instruction)
	}
	close(IntcodeOutput)
}

func GenerateIntcode(filename string) {
	content, _ := ioutil.ReadFile(filename)
	code_array := strings.Split(string(content[:len(content)-1]), ",")

	for _, s := range code_array {
		value, _ := strconv.Atoi(s)
		Intcode = append(Intcode, value)
	}

	return
}
