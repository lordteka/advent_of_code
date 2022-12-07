package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type File interface {
	Id() string
	Size() int
}

type HardFile struct {
	Name   string
	Volume int
}

func (f HardFile) Size() int {
	return f.Volume
}

func (f HardFile) Id() string {
	return f.Name
}

type Dir struct {
	Name   string
	Files  []File
	Volume int
	Parent *Dir
}

func (d Dir) Size() int {
	if d.Volume == 0 {
		var size int
		for _, f := range d.Files {
			size += f.Size()
		}
		d.Volume = size
	}

	return d.Volume
}

func (d Dir) Id() string {
	return d.Name
}

func (d Dir) find_dir(name string) *Dir {
	for _, f := range d.Files {
		if d, ok := f.(*Dir); ok && d.Id() == name {
			return d
		}
	}
	return nil
}

func (d Dir) print_files() {
	for _, f := range d.Files {
		fmt.Println(f.Id())
	}
	fmt.Println()
}

func new_dir(name string, parent *Dir) (d *Dir) {
	d = new(Dir)
	d.Name = name
	d.Parent = parent
	return
}

func new_hard_file(volume string, name string) (f *HardFile) {
	f = new(HardFile)
	f.Name = name
	f.Volume, _ = strconv.Atoi(volume)
	return
}

func run_command(command []string, current_dir *Dir) *Dir {
	switch command[0] {
	case "ls":
		return current_dir
	case "cd":
		if command[1] == ".." {
			return current_dir.Parent
		} else {
			return current_dir.find_dir(command[1])
		}
	}
	return nil
}

func build_tree(scanner *bufio.Scanner) (root *Dir) {
	root = new_dir("/", nil)
	current := root
	scanner.Scan() // skip first line
	for scanner.Scan() {
		command := strings.Split(scanner.Text(), " ")
		switch command[0] {
		case "$":
			current = run_command(command[1:], current)
		case "dir":
			current.Files = append(current.Files, new_dir(command[1], current))
		default:
			current.Files = append(current.Files, new_hard_file(command[0], command[1]))
		}
	}
	return
}

func explore(dir *Dir) (sum int) {
	for _, f := range dir.Files {
		switch v := f.(type) {
		case *HardFile:
			//NOOP
		case *Dir:
			sum += explore(v)
		}
	}
	if s := dir.Size(); s < 100000 {
		sum += s
	}
	return
}

func main() {
	root := build_tree(bufio.NewScanner(os.Stdin))
	fmt.Println(explore(root))
}
