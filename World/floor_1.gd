extends TileMapLayer
@onready var tiles_ctn: Node2D = $"../Tiles_ctn"
@onready var MOVE_TILE = preload("uid://bhsujomjfipsm")

class Cell_Data:
	var cell:Vector2i
	var position:Vector2
	var walkable:bool
	var elevation:int
	func _init(_cell,_position,_walkable,_elevation) -> void:
		cell     = _cell
		position = _position
		walkable = _walkable
		elevation= _elevation
		

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()
	#print(get_movement_route(Vector2i(-5,12),Vector2i(-4,14)))
	pass


func get_cell_data(cell:Vector2) ->Cell_Data:
	var cell_pos = map_to_local(cell)
	var elevation = get_custom_data(cell,'Elevation')
	var walkable = get_custom_data(cell,'Walkable')
	var pos = Vector2(cell_pos.x,cell_pos.y + (-8 * elevation))
	return Cell_Data.new(cell,pos,walkable,elevation)

func get_floor_data(only_walkable:bool=false) -> Array[Cell_Data]:
	var floor_data:Array[Cell_Data]=[]
	for cell in get_used_cells():
		var cell_data:Cell_Data = get_cell_data(cell)
		if only_walkable && cell_data.walkable:
			floor_data.append(cell_data)
		elif !only_walkable: floor_data.append(cell_data)
	return floor_data

func get_available_surrounding_cells(cell:Vector2i,visited:Array[Vector2i]=[],outofbound=false):
	var surr_cells = get_surrounding_cells(cell)
	var floor_data = get_floor_data()
	var avaliable_surrounding_cells = []
	for _cell in floor_data:
		if surr_cells.has(_cell.cell):
			if outofbound:
				if astar.is_in_boundsv(_cell.cell):
					avaliable_surrounding_cells.append(_cell)
			else:
				avaliable_surrounding_cells.append(_cell)
		
	
	
	return avaliable_surrounding_cells


func get_movement_route(my_grid_pos: Vector2i, target_grid_pos: Vector2i):
	if not astar.is_in_bounds(target_grid_pos.x, target_grid_pos.y):
		return []
	if astar.is_point_solid(target_grid_pos):
		return []
		
	# Get clean grid index array paths
	var grid_path: Array[Vector2i] = astar.get_id_path(my_grid_pos, target_grid_pos)
	return grid_path

func get_custom_data(cell:Vector2i,var_name:String):
	return get_cell_tile_data(cell).get_custom_data(var_name)

func create_tile(cell:Vector2i):
	var new_instance = MOVE_TILE.instantiate()
	tiles_ctn.add_child(new_instance)
	
	var cell_data = get_cell_data(cell)
	var basic_position = map_to_local(cell)
	var future_position = Vector2(
		basic_position.x,
		basic_position.y + (-8*cell_data.elevation)
	)
	
	new_instance.global_position = future_position
	pass

func remove_tiles():
	for child in tiles_ctn.get_children():
		child.queue_free()
