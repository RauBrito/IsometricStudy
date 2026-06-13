# Variable global
extends Node

var sb_movement:bool = true
var menu_movement:bool = false


func enable_sb():
	sb_movement = true
	menu_movement = false
	
func enable_menu():
	sb_movement = false
	menu_movement = true
