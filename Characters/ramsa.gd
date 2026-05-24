extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@export var movement = 3

@export var my_cell = Vector2i(-5,13)

func _ready():
	position = floor_1.map_to_local(my_cell)

func animate_movement(map_layer:TileMapLayer,target_cells:Array[Vector2i]=[]):
#func animate_movement(target_cell:Vector2i,map_layer:TileMapLayer):

	move_to_tile(target_cells,map_layer)
	
	pass

func move_to_tile(target_cells:Array[Vector2i],map_layer:TileMapLayer):
	if target_cells.size() < 1:
		return
	
	var move_direction = target_cells[0] - my_cell 
	my_cell = target_cells[0]
	match move_direction:
		Vector2i(-1,0): move_down()
		Vector2i(1,0): move_up()
		Vector2i(0,-1): move_left()
		Vector2i(0,1): move_right()
	
	var tween = create_tween()
	var target_data = map_layer.get_cell_data(target_cells[0])
	tween.tween_property(self, "position", target_data.position, 0.5)
	target_cells.pop_front()
	tween.tween_callback(move_to_tile.bind(target_cells,map_layer))
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
