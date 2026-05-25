extends TileMapLayer

func get_cell_data(cell:Vector2):
	var pos = map_to_local(cell)
	var elevation = get_cell_tile_data(Vector2(cell)).get_custom_data('Elevation')
	return {
			"cell":cell,
			'walkable':get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'),
			'elevation':elevation,
			'position':Vector2(
				pos.x,
				pos.y + (-8 * elevation)
			)
		}

func get_floor_data(only_walkable:bool=false):
	var floor_data=[]
	for cell in get_used_cells():
		var cell_data = get_cell_data(cell)
		if only_walkable && get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'):
			floor_data.append(cell_data)
		elif !only_walkable: floor_data.append(cell_data)
	return floor_data

func get_available_surrounding_cells(cell:Vector2i):
	var surr_cells = get_surrounding_cells(cell)
	var floor_data = get_floor_data()
	var avaliable_surrounding_cells = []
	for _cell in floor_data:
		if surr_cells.has(_cell.cell):				
			avaliable_surrounding_cells.append(_cell)
	return avaliable_surrounding_cells

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()
	#print(get_movement_route(Vector2i(-5,12),Vector2i(-4,14)))
	pass

var astar = AStarGrid2D.new()
func setup_grid():
	# 1. Define the grid size boundary (Rect2i)
	astar.region = get_used_rect()
	
	# 2. Define sizing (Optional, default is Vector2(1,1))
	# Keep this as (1, 1) if you want paths returned as grid coordinates (e.g., Vector2i(4, 5)).
	# Match your tile size (e.g., Vector2(64, 32)) if you want paths returned in pixel coordinates.
	astar.cell_size = Vector2(32, 16) 
	
	# 3. Choose how diagonals behave
	# DIAGONAL_MODE_NEVER: 4-directional movement (Up, Down, Left, Right)
	# DIAGONAL_MODE_ALWAYS: 8-directional movement (Allows cutting corners)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	# 4. Choose the distance scoring math (Heuristics)
	# HEURISTIC_MANHATTAN: Perfect for 4-directional/Tactical games (calculates L-shapes).
	# HEURISTIC_EUCLIDEAN: Perfect for 8-directional/Free movement (calculates straight lines).
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	#4.5 Set obstacles
	var all_cells = get_floor_data()
	for cell in all_cells:
		if !cell.walkable:
			print(cell.cell)
			astar.set_point_solid(cell.cell, true)
	# 5. Bake the configuration! (CRITICAL STEP)
	astar.update()

func get_movement_route(my_grid_pos: Vector2i, target_grid_pos: Vector2i):
	# Check if the target is out of bounds or completely solid first
	setup_grid()
	if not astar.is_in_bounds(target_grid_pos.x, target_grid_pos.y):
		return []
	if astar.is_point_solid(target_grid_pos):
		return []
		
	# Get clean grid index array paths
	var grid_path: Array[Vector2i] = astar.get_id_path(my_grid_pos, target_grid_pos)
	return grid_path
