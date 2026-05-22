extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"

const move = 2

func show_movement():
	pass

func _input(event):
	if event.is_action_pressed("selection"): 
		show_movement()
