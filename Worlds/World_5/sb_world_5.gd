extends CharacterBody2D

var floor = Floor.new()

var INITIAL_POS = Vector2i(6,19)

func _ready():
	print('aver')
	print(floor.map_to_local(Vector2i(1,1)))
	#position = floor.map_to_local(INITIAL_POS)
	pass


#var last_pos = Vector2i(0,0)
#func _process(delta: float) -> void:
	## Get the mouse position relative to the TileMapLayer
	#var mouse_pos = get_local_mouse_position()
	#
	## Convert that pixel position to the grid coordinate
	#var tile_pos: Vector2i = floor_1.local_to_map(mouse_pos)
	#if last_pos != tile_pos:
		#position = floor_1.map_to_local(tile_pos)
		#last_pos = tile_pos
		#print("Hovering over grid: ", tile_pos)
