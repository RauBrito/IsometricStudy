extends CharacterBody2D
@onready var floor_1: Floor = $"../floor_1"

var cell_pos = Vector2i(6,19)

func _ready():
	#print('aver')
	#print(floor.get_used_cells())
	#print(floor.map_to_local(Vector2i(1,1)))
	position = floor_1.map_to_local(cell_pos)
	pass

func move(type:String):
	var floor_data = floor_1.get_floor_data(true)
	print(floor_data)
	print(floor_1.get_avaliable_surrounding_cells(cell_pos))
	if type == 'up': 
		print('up')
	if type == 'down': 
		print('down')
	if type == 'left': 
		print('left')
	if type == 'right': 
		print('right')
	pass

func change_pos(to_cell:Vector2i):
	
	pass

func _input(event):
	if event.is_action_pressed("up"): 
		move('up')
	if event.is_action_pressed("down"): 
		move('down')
	if event.is_action_pressed("left"): 
		move('left')
	if event.is_action_pressed("right"): 
		move('right')
	#if event.is_action_pressed("selection"): 
		#var grid = floor_1.local_to_map(position)
		#var grid_pos = floor_1.map_to_local(grid)
		#print(floor_1.get_surrounding_cells(grid))
