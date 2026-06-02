extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const pos_initial = Vector2(0,11)
const increment = Vector2(0,16)
var option_selected = 1

func selection_up():
	if option_selected > 1:
		option_selected -= 1
		position -= increment

func selection_down():
	if option_selected < 4:
		option_selected += 1
		position += increment

func open():
	visible = true

func close():
	visible = false
