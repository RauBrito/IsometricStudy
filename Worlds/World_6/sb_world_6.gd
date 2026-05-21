extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"


var cell_pos = Vector2i(6,19)

func _ready():
	#print('aver')
	#print(floor.get_used_cells())
	#print(floor.map_to_local(Vector2i(1,1)))
	position = floor_1.map_to_local(cell_pos)
	print(position)
	pass

func move(x:int,y:int):
	#position.x += x
	#position.y += y
	# Get plain position from registered cell (x,y)
	var plain_pos = floor_1.map_to_local(cell_pos)
	
	# Get future plain position from registered cell position (x,y)
	var plain_future_pos = Vector2(plain_pos.x + x,plain_pos.y + y)
	
	# Get future cell from future position (tile_cell)
	var future_cell = floor_1.local_to_map(plain_future_pos)
	
	#return if that cell doesnt exist
	var can_continue = false
	for surr_cell in floor_1.get_avaliable_surrounding_cells(cell_pos):
		if surr_cell.cell == Vector2(future_cell):
			can_continue = true
		
	if !can_continue:
		return
		
	
	cell_pos = future_cell
	var future_cell_data = floor_1.get_cell_data(future_cell)
	position = Vector2(
		plain_future_pos.x,
		plain_future_pos.y + (-8*future_cell_data.elevation)
	)
	
	
	#var local_position = Vector2(position.x + x,position.y + y)
	#var cell = floor_1.local_to_map(local_position)
	#if cell:
		#var cell_data = floor_1.get_cell_data(cell)
		#position = Vector2(
			#local_position.x,
			#local_position.y + (-8*cell_data.elevation)
		#)

func _input(event):
	if event.is_action_pressed("up"): 
		move(16,-8)
	if event.is_action_pressed("down"): 
		move(-16,8)
	if event.is_action_pressed("left"): 
		move(-16,-8)
	if event.is_action_pressed("right"): 
		move(16,8)
	#if event.is_action_pressed("selection"): 
		#var grid = floor_1.local_to_map(position)
		#var grid_pos = floor_1.map_to_local(grid)
		#print(floor_1.get_surrounding_cells(grid))
		##print(position) #(208.0,200.0)
		##print(grid_pos) #(208.0,200.0)
		##print(grid) #(6,24)
