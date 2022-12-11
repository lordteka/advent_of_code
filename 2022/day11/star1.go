package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"sort"
	"strconv"
	"strings"
)

type Test struct {
	DivisibleBy int
	True        int
	False       int
}

func (t *Test) run(item int) int {
	if item%t.DivisibleBy == 0 {
		return t.True
	} else {
		return t.False
	}
}

type Operation struct {
	Operand byte
	Term    int
	OnSelf  bool
}

func (o *Operation) run(item int) int {
	term := o.Term
	if o.OnSelf {
		term = item
	}
	switch o.Operand {
	case '+':
		return item + term
	case '*':
		return item * term
	default:
		return item
	}
}

type Monkey struct {
	Id        int
	Activity  int
	Items     []int
	Operation *Operation
	Test      *Test
}

func get_file_from_stdin() string {
	f, _ := io.ReadAll(bufio.NewReader(os.Stdin))

	return string(f)
}

func get_int_at_end_of_string(s string) (i int) {
	tmp := strings.Split(s, " ")
	i, _ = strconv.Atoi(tmp[len(tmp)-1])
	return
}

func parse_operation(operation_info string) *Operation {
	operation := new(Operation)
	data := strings.Split(operation_info, " ")
	operation.Operand = data[len(data)-2][0]
	if data[len(data)-1] == "old" {
		operation.OnSelf = true
	} else {
		operation.Term, _ = strconv.Atoi(data[len(data)-1])
	}
	return operation
}

func parse_test(test_info []string) *Test {
	test := new(Test)
	test.DivisibleBy = get_int_at_end_of_string(test_info[0])
	test.True = get_int_at_end_of_string(test_info[1])
	test.False = get_int_at_end_of_string(test_info[2])
	return test
}

func parse_monkey(monkey_info string) *Monkey {
	monkey := new(Monkey)
	data := strings.Split(monkey_info, "\n")
	monkey.Id = get_int_at_end_of_string(data[0][:len(data[0])-1])
	tmp := strings.Split(data[1], ": ")
	for _, value := range strings.Split(tmp[1], ", ") {
		item, _ := strconv.Atoi(value)
		monkey.Items = append(monkey.Items, item)
	}
	monkey.Operation = parse_operation(data[2])
	monkey.Test = parse_test(data[3:])
	return monkey
}

func get_monkeys(file string) (monkeys []Monkey) {
	for _, monkey_info := range strings.Split(file, "\n\n") {
		monkeys = append(monkeys, *parse_monkey(monkey_info))
	}
	return
}

func run_rounds(monkeys []Monkey, n int) {
	var item int

	for i := 0; i < n; i++ {
		for j := 0; j < len(monkeys); j++ {
			for len(monkeys[j].Items) > 0 {
				monkeys[j].Activity++
				item, monkeys[j].Items = monkeys[j].Items[0], monkeys[j].Items[1:]
				item = monkeys[j].Operation.run(item)
				item /= 3
				throw_to := monkeys[j].Test.run(item)
				monkeys[throw_to].Items = append(monkeys[throw_to].Items, item)
			}
		}
	}
}

func calculate_monkey_business(monkeys []Monkey) int {
	sort.Slice(monkeys, func(i, j int) bool {
		return monkeys[i].Activity > monkeys[j].Activity
	})
	return monkeys[0].Activity * monkeys[1].Activity
}

func main() {
	monkeys := get_monkeys(get_file_from_stdin())
	run_rounds(monkeys, 20)
	fmt.Println(calculate_monkey_business(monkeys))
}
