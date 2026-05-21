extends Node2D
class_name Floors
@onready var floor_1: TileMapLayer = $floor_1
@onready var floor_2: TileMapLayer = $floor_2

@onready var all_floors:Array[TileMapLayer] = [floor_1,floor_2]

static var all_floor_data = []
static var starting_pos = Vector2i(0,0)
func get_all_floors_data():
	for _floor in all_floors:
		var _this_floor = []
		var _this_floor_data:Array[Vector2i] = _floor.get_used_cells()
		for cell in _this_floor_data:
			var cell_data = {
				"cell":cell,
				'walkable':_floor.get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'),
				'elevation':_floor.get_cell_tile_data(Vector2(cell)).get_custom_data('Elevation'),
			}
			print(cell_data)
			_this_floor.append(cell_data)
		all_floor_data.append(_this_floor)
	
	#print('all_floor_data')
	#print(all_floor_data)

func get_starting_point():
	print("this is starting point")
	print(floor_1)
	pass

func get_cell_data(cell:Vector2i):
	var cell_data = {
		"cell":cell,
		'walkable':floor_1.get_cell_tile_data(Vector2(cell)).get_custom_data('Walkable'),
		'elevation':floor_1.get_cell_tile_data(Vector2(cell)).get_custom_data('Elevation'),
	}
	return cell_data

func _ready() -> void:
	print('floor_ready')
	#starting_pos = floor_1.map_to_local(all_floors[0].get_used_cells()[0])
	starting_pos = floor_1.map_to_local(Vector2i(8,31))
	print(starting_pos)
	get_all_floors_data()
	pass
	

#func _input(event):
	#if event.is_action_pressed("up"): 
		#print(all_floor_data)
