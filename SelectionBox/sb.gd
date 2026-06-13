extends CharacterBody2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@onready var ramsa: CharacterBody2D = $"../Ramsa"
@onready var visual: Node2D = $Visual
@onready var animated_sprite_2d: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var Actions_menu: Control = $"../Actions"
@onready var selected_body = null

var cell_pos = Vector2i(17,5)

func _ready():
	position = floor_1.map_to_local(cell_pos)
	pass

func _input(event):
	if MenuStatus.sb_movement:
		if event.is_action_pressed("selection"): 
			selection(event)
		if event.is_action_pressed("deselection"): 
			ramsa.is_movement = false
			Actions_menu.visible = false
			MenuStatus.enable_sb()
			floor_1.remove_tiles()
		else:
			_handle_move(event)

func _handle_move(event):
	var move = func (x:int,y:int):
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
			plain_future_pos.y
			#plain_future_pos.y + (-8*future_cell_data.elevation)
		)
		#offset elevation
		animated_sprite_2d.offset.y = future_cell_data.elevation * -8
	
	if event.is_action_pressed("up"): 
		move.call(16,-8)
	if event.is_action_pressed("down"): 
		move.call(-16,8)
	if event.is_action_pressed("left"): 
		move.call(-16,-8)
	if event.is_action_pressed("right"): 
		move.call(16,8)

func selection(event):
	if Actions_menu.visible:
		#only if move is selected
		#selected_body.menu_move(cell_pos)
		return
	else:
		var if_content = floor_1.test(cell_pos).content
		if if_content:
			Actions_menu.visible = true
			selected_body = if_content
			MenuStatus.enable_menu()
		elif selected_body.is_movement:
			selected_body.handle_movement(cell_pos)

#TODO: Fix the duplication of "get_floor_data"
#FIXME: Tiles and selection box index by elevation
