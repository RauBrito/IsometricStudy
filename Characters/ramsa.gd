extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@onready var move_timer: Timer = $Move_Timer
@export var movement = 1

@export var my_cell = Vector2i(-4,13)

func _ready():
	position = floor_1.map_to_local(my_cell)

func animate_movement(target_cell:Vector2i,map_layer:TileMapLayer):
	var target_data = map_layer.get_cell_data(target_cell)
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_data.position, 0.5)
	
	var move_direction = target_cell - my_cell
	
	if move_direction == Vector2i(-1,0):
		move_down()
	elif move_direction == Vector2i(1,0):
		move_up()
	elif move_direction == Vector2i(0,-1):
		move_left()
	elif move_direction == Vector2i(0,1):
		move_right()
	
	my_cell = target_cell
	pass

func move_down():
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Face")
	
func move_up():
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("Back")

func move_left():
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Back")
	
func move_right():
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("Face")
