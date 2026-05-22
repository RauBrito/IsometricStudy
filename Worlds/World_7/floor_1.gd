extends TileMapLayer

func get_cell_data(cell:Vector2):
	return {
			"cell":cell,
			'walkable':get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'),
			'elevation':get_cell_tile_data(Vector2(cell)).get_custom_data('Elevation'),
		}

func get_floor_data(only_walkable:bool=false):
	var floor_data=[]
	for cell in get_used_cells():
		var cell_data = get_cell_data(cell)
		if only_walkable && get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'):
			floor_data.append(cell_data)
		elif !only_walkable: floor_data.append(cell_data)
	return floor_data

func get_available_surrounding_cells(cell:Vector2i,amount:int = 1):
	if amount == 0:
		print('ok?')
		return []
	else:
		print('why')
		var surr_cells = get_surrounding_cells(cell)
		
		var floor_data = get_floor_data(true)
		var avaliable_surrounding_cells = []
		for _cell in floor_data:
			if surr_cells.has(_cell.cell):				
				avaliable_surrounding_cells.append(_cell)

		for each_cell in avaliable_surrounding_cells:
			for c in get_available_surrounding_cells(each_cell.cell,amount-1):
				print(c)
				avaliable_surrounding_cells.append(c)
		
		return avaliable_surrounding_cells

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(get_floor_data(true))
	#print(get_used_cells())
	pass # Replace with function body.
