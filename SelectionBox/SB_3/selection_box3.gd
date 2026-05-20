extends CharacterBody2D
var actual_floor = 0

var INITIAL_POS = Vector2(8,31)
var new_f = Floors.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello?")
	#var _this_floor = new_f.all_floor_data[actual_floor]
	position = new_f.starting_pos
	#position = new_f.floor_1.local_to_map(_this_floor[0].cell)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


#
func move(x:int,y:int):
	position.x += x
	position.y += y
#
#func _input(event):
	#if event.is_action_pressed("up"): 
		#move(16,-8)
	#if event.is_action_pressed("down"): 
		#move(-16,8)
	#if event.is_action_pressed("left"): 
		#move(-16,-8)
	#if event.is_action_pressed("right"): 
		#move(16,8)
	#if event.is_action_pressed("selection"): 
		#var grid = floor_1.local_to_map(position)
		#var grid_pos = floor_1.map_to_local(grid)
		#print(floor_1.get_surrounding_cells(grid))
		##print(position) #(208.0,200.0)
		##print(grid_pos) #(208.0,200.0)
		##print(grid) #(6,24)
