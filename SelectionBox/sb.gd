extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@onready var ramsa: CharacterBody2D = $"../Ramsa"

var is_movement = false
var cell_pos = Vector2i(-5,15)

func _ready():
	position = floor_1.map_to_local(cell_pos)
	pass

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
		selection()
	if event.is_action_pressed("deselection"): 
		is_movement = false
		floor_1.remove_tiles()

func move(x:int,y:int):
	# Get plain position from registered cell (x,y)
	var plain_pos = floor_1.map_to_local(cell_pos)
	# Get future plain position from registered cell position (x,y)
	var plain_future_pos = Vector2(plain_pos.x + x,plain_pos.y + y)
	# Get future cell from future position (tile_cell)
	var future_cell:Vector2i = floor_1.local_to_map(plain_future_pos)
	#return if that cell doesnt exist
	var can_continue = false
	for surr_cell in floor_1.get_available_surrounding_cells(cell_pos):
		if surr_cell == future_cell:
			can_continue = true
		
	if !can_continue:
		return
		
	
	cell_pos = future_cell
	var future_cell_data = floor_1.get_cell_data(future_cell)
	position = Vector2(
		plain_future_pos.x,
		plain_future_pos.y + (-8*future_cell_data.elevation)
	)


func handle_movement():
	if is_movement:
		is_movement = false
		floor_1.remove_tiles()
		var valid_cells = ramsa.get_valid_movement()
		if valid_cells.has(cell_pos):
			var all_cells = floor_1.get_movement_route(ramsa.my_cell,cell_pos)
			all_cells.pop_front()
			if all_cells.size() >= 1:
				ramsa.move_to_tile(all_cells,floor_1)
		
			
	else:
		if floor_1.test(cell_pos).content is CharacterBody2D:
			is_movement = true
			ramsa.show_movement()

func selection():
	handle_movement()
		
		
#TODO: Fix the duplication of "get_floor_data"
#FIXME: Tiles and selection box index by elevation
