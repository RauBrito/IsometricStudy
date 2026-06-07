extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const pos_initial = Vector2(0,11)
const increment = Vector2(0,16)
var option_selected = 1



func handle_menu_movement(event):
	if event.is_action_pressed("up"): 
		if option_selected > 1:
			option_selected -= 1
			animated_sprite_2d.position -= increment
	if event.is_action_pressed("down"): 
		if option_selected < 4:
			option_selected += 1
			animated_sprite_2d.position += increment


func open():
	visible = true

func close():
	visible = false
