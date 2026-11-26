package main

import "fmt"

// Go structs, types, and formatted strings.
type EntityReference struct { Label string }
func main() {
    entity := EntityReference{Label: "Drupal"}
    fmt.Printf("Hello %s: %d\n", entity.Label, 42)
}
