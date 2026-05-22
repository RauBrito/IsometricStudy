extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@onready var tiles_ctn: Node2D = $"../Tiles_ctn"
@onready var MOVE_TILE = preload("uid://bhsujomjfipsm")




var cell_pos = Vector2i(-3,16)

func _ready():
	#print('aver')
	#print(floor.get_used_cells())
	#print(floor.map_to_local(Vector2i(1,1)))
	position = floor_1.map_to_local(cell_pos)
	#print(position)
	#print(floor_1.get_available_surrounding_cells(cell_pos))
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
	for surr_cell in floor_1.get_available_surrounding_cells(cell_pos):
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

func show_move(cell:Vector2i,amount:int):
	for child in tiles_ctn.get_children():
		child.queue_free()
	
	var surr_cells = floor_1.get_available_surrounding_cells(cell)
	if amount == 2:
		var more_cells = []
		for each in surr_cells:
			for each_cell in floor_1.get_available_surrounding_cells(each.cell):
				more_cells.append(each_cell)
		print(more_cells)
	create_tile(cell)
	for each_cell in surr_cells:
		create_tile(each_cell.cell)
	pass

func create_tile(cell:Vector2i):
	var new_instance = MOVE_TILE.instantiate()
	tiles_ctn.add_child(new_instance)
	
	var cell_data = floor_1.get_cell_data(cell)
	var basic_position = floor_1.map_to_local(cell)
	var future_position = Vector2(
		basic_position.x,
		basic_position.y + (-8*cell_data.elevation)
	)
	
	new_instance.global_position = future_position
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
		show_move(cell_pos,2)
