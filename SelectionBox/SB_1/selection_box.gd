extends CharacterBody2D
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
var INITIAL_POS = Vector2i(6,24)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = tile_map_layer.map_to_local(INITIAL_POS)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move(x:int,y:int):
	position.x += x
	position.y += y

func _input(event):
	if event.is_action_pressed("up"): 
		move(16,-8)
	if event.is_action_pressed("down"): 
		move(-16,8)
	if event.is_action_pressed("left"): 
		move(-16,-8)
	if event.is_action_pressed("right"): 
		move(16,8)
	if event.is_action_pressed("selection"): 
		var grid = tile_map_layer.local_to_map(position)
		var grid_pos = tile_map_layer.map_to_local(grid)
		print(position)
		print(grid_pos)
		print(grid)
