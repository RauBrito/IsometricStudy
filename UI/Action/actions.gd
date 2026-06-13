extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var selection_box: CharacterBody2D = $"../Selection Box"

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

func _input(event):
	if MenuStatus.menu_movement:
		if event.is_action_pressed("deselection"):
				close()
				MenuStatus.enable_sb() 
		if event.is_action_pressed("selection"):
			match option_selected:
				1: movement()
				2: attack()
				3: skills()
				4: end_turn()
		else:
			handle_menu_movement(event)


func movement():
	var character = selection_box.selected_body
	MenuStatus.enable_sb()
	character.show_movement()
	visible = false
	
	

func attack():
	pass

func skills():
	pass

func end_turn():
	pass
