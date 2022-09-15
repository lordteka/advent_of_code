// +build star1

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

func update_velocity() {
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
			if Moons[i1].Pos.Y > Moons[i2].Pos.Y {
				Moons[i1].Vel.Y--
			} else if Moons[i1].Pos.Y < Moons[i2].Pos.Y {
				Moons[i1].Vel.Y++
			}
			if Moons[i1].Pos.Z > Moons[i2].Pos.Z {
				Moons[i1].Vel.Z--
			} else if Moons[i1].Pos.Z < Moons[i2].Pos.Z {
				Moons[i1].Vel.Z++
			}
		}
	}
}

func update_position() {
	for i := range Moons {
		Moons[i].Pos.X += Moons[i].Vel.X
		Moons[i].Pos.Y += Moons[i].Vel.Y
		Moons[i].Pos.Z += Moons[i].Vel.Z
	}
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func potential_energy(m Moon) int {
	return abs(m.Pos.X) + abs(m.Pos.Y) + abs(m.Pos.Z)
}

func kinetic_energy(m Moon) int {
	return abs(m.Vel.X) + abs(m.Vel.Y) + abs(m.Vel.Z)
}

func total_energy(m Moon) int {
	return potential_energy(m) * kinetic_energy(m)
}

func system_energy() (energy int) {
	for _, m := range Moons {
		energy += total_energy(m)
	}
	return
}

func main() {
	for i := 0; i < 1000; i++ {
		update_velocity()
		update_position()
	}
	fmt.Println(system_energy())
}
