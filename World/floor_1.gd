extends TileMapLayer
@onready var tiles_ctn: Node2D = $"../Tiles_ctn"
@onready var MOVE_TILE = preload("uid://bhsujomjfipsm")

class Cell_Data:
	var cell:Vector2i
	var position:Vector2
	var walkable:bool
	var elevation:int
	var content:Variant = null
	func _init(_cell,_position,_walkable,_elevation,_content=null) -> void:
		cell     = _cell
		position = _position
		walkable = _walkable
		elevation= _elevation
		content = _content
	
	func set_content(_content:Variant):
		content = _content
		

var astar = AStarGrid2D.new()
var all_floor_data:Array[Cell_Data] = []
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
	
	# 5. Bake the configuration! (CRITICAL STEP)
	astar.update()
	#5.5 Set obstacles
	var all_cells = get_floor_data_old()
	for cell in all_cells:
		if !cell.walkable:
			#print(cell.cell)
			astar.set_point_solid(cell.cell, true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()
	all_floor_data = get_floor_data_old()
	pass


func get_cell_data(cell:Vector2) ->Cell_Data:
	#var result
	#for each in all_floor_data:
		#if each.cell == cell:
			#result = each
	#return result
	var cell_pos = map_to_local(cell)
	var elevation = get_custom_data(cell,'Elevation')
	var walkable = get_custom_data(cell,'Walkable')
	var content = null
	var pos = Vector2(cell_pos.x,cell_pos.y + (-8 * elevation))
	return Cell_Data.new(cell,pos,walkable,elevation,content)

func get_floor_data(only_walkable:bool=false) -> Array[Cell_Data]:
	var floor_data:Array[Cell_Data]=[]
	if only_walkable:
		for each in all_floor_data:
			if each.walkable:
				floor_data.append(each)
	else:
		floor_data = all_floor_data
	return floor_data

func get_floor_data_old(only_walkable:bool=false) -> Array[Cell_Data]:
	var floor_data:Array[Cell_Data]=[]
	for cell in get_used_cells():
		var cell_data:Cell_Data = get_cell_data(cell)
		if only_walkable && cell_data.walkable:
			floor_data.append(cell_data)
		elif !only_walkable: floor_data.append(cell_data)
	return floor_data


func get_available_surrounding_cells(
	cell:Vector2i,
	to_ignore:Array[Vector2i]=[],
	walkable:bool=false) -> Array[Vector2i]:
	var surr_cells:Array[Vector2i] = get_surrounding_cells(cell)
	var floor_data:Array[Cell_Data] = get_floor_data(walkable)
	var avaliable_surrounding_cells:Array[Vector2i] = []
	
	var index_to_remove = []
	for i in surr_cells.size():
		if to_ignore.has(surr_cells[i]):
			index_to_remove.append(i)
	index_to_remove.sort_custom(func(a, b): return a > b)
	for i in index_to_remove:
		surr_cells.remove_at(i)

	for _cell in floor_data:
		if surr_cells.has(_cell.cell):
			avaliable_surrounding_cells.append(_cell.cell)
		
	
	
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

func set_point_solid(cell: Vector2i, solid: bool = true):
	astar.set_point_solid(cell,solid)

func modify_cell_content(cell:Vector2i,content:Variant):
	for each in all_floor_data:
		if each.cell == cell:
			each.set_content(content)

func test(cell):
	var result
	for each in all_floor_data:
		if each.cell == cell:
			result = each
	return result
