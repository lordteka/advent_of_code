// +build star1

package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type Planet struct {
	Name            string
	DirectOrbitName string
	DirectlyOrbits  *Planet
}

func count_planet_orbits(planet *Planet) (count int) {
	for planet.DirectlyOrbits != nil {
		planet = planet.DirectlyOrbits
		count++
	}
	return
}

func count_total_orbits(planets []Planet) (count int) {
	for _, planet := range planets {
		count += count_planet_orbits(&planet)
	}
	return
}

func find_planet(planets []Planet, name string) *Planet {
	for i := range planets {
		if planets[i].Name == name {
			return &planets[i]
		}
	}
	fmt.Println("notfound")
	return nil
}

func link_planets_together(planets []Planet) {
	for i := range planets {
		planets[i].DirectlyOrbits = find_planet(planets, planets[i].DirectOrbitName)
	}
}

func get_planet_list() (planets []Planet) {
	file, _ := os.Open("input")
	scanner := bufio.NewScanner(file)
	planets = append(planets, Planet{"COM", "", nil})
	for scanner.Scan() {
		planet_names := strings.Split(scanner.Text(), ")")
		planets = append(planets, Planet{planet_names[1], planet_names[0], nil})
	}
	return
}

func main() {
	planets := get_planet_list()
	link_planets_together(planets)
	fmt.Println(count_total_orbits(planets))
}
