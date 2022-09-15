// +build star2

package main

import (
	"fmt"
)

type Position struct {
	X int
	Y int
	Z int
}

type Velocity Position

type Moon struct {
	Pos Position
	Vel Velocity
}

// really don’t want to parse the input
var Moons [4]Moon = [4]Moon{
	{Position{-10, -13, 7}, Velocity{0, 0, 0}},
	{Position{1, 2, 1}, Velocity{0, 0, 0}},
	{Position{-15, -3, 13}, Velocity{0, 0, 0}},
	{Position{3, 7, -4}, Velocity{0, 0, 0}},
}

func update_velocity_x() {
	for i1 := range Moons {
		for i2 := range Moons {
			if i1 == i2 {
				continue
			}
			if Moons[i1].Pos.X > Moons[i2].Pos.X {
				Moons[i1].Vel.X--
			} else if Moons[i1].Pos.X < Moons[i2].Pos.X {
				Moons[i1].Vel.X++
			}
		}
	}
}

func update_velocity_y() {
	for i1 := range Moons {
		for i2 := range Moons {
			if i1 == i2 {
				continue
			}
			if Moons[i1].Pos.Y > Moons[i2].Pos.Y {
				Moons[i1].Vel.Y--
			} else if Moons[i1].Pos.Y < Moons[i2].Pos.Y {
				Moons[i1].Vel.Y++
			}
		}
	}
}

func update_velocity_z() {
	for i1 := range Moons {
		for i2 := range Moons {
			if i1 == i2 {
				continue
			}
			if Moons[i1].Pos.Z > Moons[i2].Pos.Z {
				Moons[i1].Vel.Z--
			} else if Moons[i1].Pos.Z < Moons[i2].Pos.Z {
				Moons[i1].Vel.Z++
			}
		}
	}
}

func update_position_x() {
	for i := range Moons {
		Moons[i].Pos.X += Moons[i].Vel.X
	}
}

func update_position_y() {
	for i := range Moons {
		Moons[i].Pos.Y += Moons[i].Vel.Y
	}
}

func update_position_z() {
	for i := range Moons {
		Moons[i].Pos.Z += Moons[i].Vel.Z
	}
}

func find_x_cycle() (count int) {
	update_velocity_x()
	update_position_x()
	count++
	// probably check for half a rotation instead of a full one
	for Moons[0].Vel.X != 0 || Moons[1].Vel.X != 0 || Moons[2].Vel.X != 0 || Moons[3].Vel.X != 0 {
		update_velocity_x()
		update_position_x()
		count++
	}
	return
}

func find_y_cycle() (count int) {
	update_velocity_y()
	update_position_y()
	count++
	for Moons[0].Vel.Y != 0 || Moons[1].Vel.Y != 0 || Moons[2].Vel.Y != 0 || Moons[3].Vel.Y != 0 {
		update_velocity_y()
		update_position_y()
		count++
	}
	return
}

func find_z_cycle() (count int) {
	update_velocity_z()
	update_position_z()
	count++
	for Moons[0].Vel.Z != 0 || Moons[1].Vel.Z != 0 || Moons[2].Vel.Z != 0 || Moons[3].Vel.Z != 0 {
		update_velocity_z()
		update_position_z()
		count++
	}
	return
}

func pgcd(a, b int) int {
	c := a % b
	if c == 0 {
		return b
	}
	return pgcd(b, c)
}

func ppcm(a, b int) int {
	if a > b {
		return (a * b) / pgcd(a, b)
	}
	return (a * b) / pgcd(b, a)
}

func main() {
	cycle_x := find_x_cycle()
	cycle_y := find_y_cycle()
	cycle_z := find_z_cycle()

	fmt.Println(ppcm(ppcm(cycle_x, cycle_y), cycle_z) * 2)
}
