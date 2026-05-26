extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@onready var ramsa: CharacterBody2D = $"../Ramsa"



var is_movement = true
var cell_pos = Vector2i(-2,13)


func _ready():
	position = floor_1.map_to_local(cell_pos)
	ramsa.show_movement()
	
	
	#var movements = floor_1.get_movement_route(Vector2i(-5,12),Vector2i(-4,14))
	#move_timer.start()
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
		floor_1.remove_tiles()

# ALL MOVEMENT LOGIC
func handle_movement():
	if is_movement:
		var all_cells = floor_1.get_movement_route(ramsa.my_cell,cell_pos)
		all_cells.pop_front()
		if all_cells.size() >= 1:
			ramsa.animate_movement(floor_1,all_cells)
		floor_1.remove_tiles()
			
	else:
		ramsa.show_move(cell_pos,ramsa.movement)
