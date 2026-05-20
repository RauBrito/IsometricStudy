extends CharacterBody2D
#@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var floor_1: TileMapLayer = $"../floor1"

var INITIAL_POS = Vector2(6,24)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = floor_1.map_to_local(INITIAL_POS)
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
		var grid = floor_1.local_to_map(position)
		var grid_pos = floor_1.map_to_local(grid)
		print(floor_1.get_surrounding_cells(grid))
		#print(position) #(208.0,200.0)
		#print(grid_pos) #(208.0,200.0)
		#print(grid) #(6,24)
