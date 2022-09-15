// +build star2

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

func count_orbits_to_planet(path []*Planet, planet *Planet) (count int) {
	for i := range path {
		if path[i].Name == planet.Name {
			return
		}
		count++
	}
	return -1
}

func find_common_planet(path1 []*Planet, path2 []*Planet) *Planet {
	for i := range path1 {
		for j := range path2 {
			if path1[i].Name == path2[j].Name {
				return path1[i]
			}
		}
	}
	return nil
}

func planet_orbits_path(planet *Planet) (path []*Planet) {
	planet = planet.DirectlyOrbits
	for planet.DirectlyOrbits != nil {
		path = append(path, planet)
		planet = planet.DirectlyOrbits
	}
	return
}

func find_planet(planets []Planet, name string) *Planet {
	for i := range planets {
		if planets[i].Name == name {
			return &planets[i]
		}
	}
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
	you := find_planet(planets, "YOU")
	san := find_planet(planets, "SAN")
	you_path := planet_orbits_path(you)
	san_path := planet_orbits_path(san)
	common := find_common_planet(you_path, san_path)
	fmt.Println(count_orbits_to_planet(you_path, common) + count_orbits_to_planet(san_path, common))
}
