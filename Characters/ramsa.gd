extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var floor_1: TileMapLayer = $"../floor_1"
@export var movement = 7
@export var my_cell = Vector2i(17,5)
@onready var marker_2d: Marker2D = $Marker2D
var _offset = Vector2(0,7) # 0,11 by def

func _ready():
	position = floor_1.map_to_local(my_cell) + _offset 
	floor_1.modify_cell_content(my_cell,self)

func _process(_delta: float) -> void:
	marker_2d.position = position

func move_to_tile(target_cells:Array[Vector2i],map_layer:TileMapLayer):
	
	floor_1.modify_cell_content(my_cell,null)
	if target_cells.size() < 1:
		return floor_1.modify_cell_content(my_cell,self)
	
	var move_direction = target_cells[0] - my_cell 
	my_cell = target_cells[0]
	match move_direction:
		Vector2i(-1,0): move_axis("DOWN")
		Vector2i(1,0): move_axis("UP")
		Vector2i(0,-1): move_axis("LEFT")
		Vector2i(0,1): move_axis("RIGHT")
	
	var tween = create_tween()
	var target_data = floor_1.get_cell_data(target_cells[0])
	
	var anim_offset = Vector2(0,target_data.elevation*-8)
	var pos = target_data.position + _offset 

	tween.tween_property(self, "position",pos, 0.5)
	tween.parallel().tween_property(animated_sprite_2d, "offset",anim_offset , 0.5)
	
	target_cells.pop_front()
	tween.tween_callback(move_to_tile.bind(target_cells,floor_1))

func move_axis(direction:String):
	if direction == "UP":
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("Face")
	if direction == "DOWN":
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("Back")
	if direction == "LEFT":
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("Back")
	if direction == "RIGHT":
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("Face")


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
		
		var unique:Array[Vector2i] = []
		for item in to_queue:
			if not unique.has(item):
				unique.append(item)
		queue = unique
	
	valid_cells.append_array(queue)
	valid_cells.reverse()
	return valid_cells

var is_movement = false
func handle_movement(cell_pos:Vector2):
	is_movement = false
	floor_1.remove_tiles()
	if get_valid_movement().has(cell_pos):
		var all_cells = floor_1.get_movement_route(my_cell,cell_pos)
		all_cells.pop_front()
		if all_cells.size() >= 1:
			move_to_tile(all_cells,floor_1)


func show_movement():
	MenuStatus.enable_sb()
	is_movement = true
	var valid_cells = get_valid_movement()
	for each in valid_cells:
		floor_1.create_tile(each)
