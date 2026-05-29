extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@export var movement = 3

@export var my_cell = Vector2i(18,3)

func _ready():
	position = floor_1.map_to_local(my_cell)
	floor_1.modify_cell_content(my_cell,self)
	#show_movement()

func show_movement():
	var valid_cells = get_valid_movement()
	for each in valid_cells:
		floor_1.create_tile(each)

func move_to_tile(target_cells:Array[Vector2i],map_layer:TileMapLayer):
	floor_1.modify_cell_content(my_cell,null)
	if target_cells.size() < 1:
		#floor_1.set_point_solid(my_cell,true)
		return floor_1.modify_cell_content(my_cell,self)
	
	var move_direction = target_cells[0] - my_cell 
	my_cell = target_cells[0]
	match move_direction:
		Vector2i(-1,0): move_down()
		Vector2i(1,0): move_up()
		Vector2i(0,-1): move_left()
		Vector2i(0,1): move_right()
	
	var tween = create_tween()
	var target_data = map_layer.get_cell_data(target_cells[0])
	tween.tween_property(self, "position", target_data.position, 0.5)
	target_cells.pop_front()
	tween.tween_callback(move_to_tile.bind(target_cells,map_layer))

func move_right():
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Face")

func move_left():
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("Back")

func move_down():
	animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("Back")

func move_up():
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("Face")

func remove_duplicates(arr) ->Array[Vector2i]:
	var unique:Array[Vector2i] = []
	for item in arr:
		if not unique.has(item):
			unique.append(item)
	return unique

func get_valid_movement()->Array[Vector2i]:
	#Valid cells to keep track of our progress
	var valid_cells:Array[Vector2i] = []
	#A queue to know the last cells we visited
	var queue:Array[Vector2i] = [my_cell]
	for i in movement:
		#Add our progress to the valid cells and allow to start the journey with "my_cell"
		valid_cells.append_array(queue)
		#For each cell in the queue, we add the next targets "to_queue" and restart
		var to_queue:Array[Vector2i] = []
		for each in queue:
			to_queue.append_array(floor_1.get_available_surrounding_cells(each,valid_cells,true))
		queue = remove_duplicates(to_queue) 
	
	valid_cells.append_array(queue)
	return valid_cells
