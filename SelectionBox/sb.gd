extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@onready var tiles_ctn: Node2D = $"../Tiles_ctn"
@onready var MOVE_TILE = preload("uid://bhsujomjfipsm")
@onready var ramsa: CharacterBody2D = $"../Ramsa"




var cell_pos = Vector2i(-1,16)
var movement = 3
var is_movement = false

func _ready():
	position = floor_1.map_to_local(cell_pos)
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
		handle_movement()
	if event.is_action_pressed("deselection"): 
		remove_tiles()

# ALL MOVEMENT LOGIC
func handle_movement():
	if is_movement:
		var cell_data = floor_1.get_cell_data(cell_pos)
		var future_position = floor_1.map_to_local(cell_pos)
		ramsa.position = Vector2(
			future_position.x,
			future_position.y + (-8*cell_data.elevation))
		remove_tiles()
	else:
		show_move(cell_pos,movement)

func show_move(cell:Vector2i,amount:int):
	remove_tiles()
	is_movement = true
	var all_tiles = retrieve_movement_tiles(cell,amount)
	var floor_data = floor_1.get_floor_data(true)
	var valid_cells = [cell_pos]
	for each in floor_data:
		if all_tiles.has(each.cell):
			valid_cells.append(each.cell)
	
	for each in valid_cells:
		create_tile(each)

func retrieve_movement_tiles(cell:Vector2i,amount:int):
	if amount == 0:
		return [cell_pos]
		
	
	var max_left = Vector2(cell_pos.x,cell_pos.y - amount)
	var max_right = Vector2(cell_pos.x,cell_pos.y + amount)
	var max_top = Vector2(cell_pos.x + amount,cell_pos.y)
	var max_down = Vector2(cell_pos.x - amount,cell_pos.y)
	
	var maxed = [max_left,max_right,max_top,max_down]
	for each in (amount - 1):
		var num = each + 1
		maxed.append(line_vertical(max_left,num))
		maxed.append(line_vertical(max_top,num))
		maxed.append(line_horizontal(max_left,num))
		maxed.append(line_horizontal(max_down,num))
	
	
	#for each in maxed:
		#create_tile(each)
	maxed.append_array(retrieve_movement_tiles(cell,amount-1))
	return maxed

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

func remove_tiles():
	is_movement = false
	for child in tiles_ctn.get_children():
		child.queue_free()

func line_vertical(max_tile:Vector2,num:int):
	return Vector2(
			max_tile.x - num,
			max_tile.y + num,
		)

func line_horizontal(max_tile:Vector2,num:int):
	return Vector2(
			max_tile.x + num,
			max_tile.y + num,
		)
