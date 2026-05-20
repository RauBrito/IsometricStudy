extends TileMapLayer
class_name Floor

func get_floor_data(only_walkable:bool=false):
	var floor_data=[]
	for cell in get_used_cells():
		var cell_data = {
			"cell":cell,
			'walkable':get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'),
			'elevation':get_cell_tile_data(Vector2(cell)).get_custom_data('Elevation'),
		}
		if only_walkable && get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'):
			floor_data.append(cell_data)
		elif !only_walkable: floor_data.append(cell_data)
	return floor_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('aver2')
	print(get_floor_data(true))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#var last_pos = Vector2i(0,0)
#func _process(delta: float) -> void:
	## Get the mouse position relative to the TileMapLayer
	#var mouse_pos = get_local_mouse_position()
	#
	## Convert that pixel position to the grid coordinate
	#var tile_pos: Vector2i = local_to_map(mouse_pos)
	#if last_pos != tile_pos:
		#last_pos = tile_pos
		#print("Hovering over grid: ", tile_pos)
		#
	
	# Do something with it, like highlighting the tile
	pass
