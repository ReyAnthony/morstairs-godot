#https://medium.com/kitschdigital/2d-path-finding-with-astar-in-godot-3-0-7810a355905a
extends TileMap
class_name NavigationTilemap

onready var astar :AStar = AStar.new()
onready var half_cell_size :Vector2 = cell_size / 2
onready var traversable_tiles := []
onready var used_rect :Rect2 = get_used_rect()
var wall_tilemap :TileMap
var _actors := []

func _ready():
	half_cell_size.x = 0
	
	wall_tilemap = $"../Walls"
	var to_include := []
	for t_id in tile_set.get_tiles_ids():
		if tile_set.tile_get_shape_count(t_id) == 0:
			to_include.append(t_id)
	
	for inc in to_include:
		traversable_tiles = traversable_tiles + get_used_cells_by_id(inc)
	for ex in wall_tilemap.get_used_cells():
		var cell = world_to_map(wall_tilemap.map_to_world(ex))
		if traversable_tiles.has(cell):
			traversable_tiles.remove(traversable_tiles.find(cell))
		
	_add_traversable_tiles(traversable_tiles)
	_connect_traversable_tiles(traversable_tiles)

func _add_traversable_tiles(traversable_tiles: Array):
	for tile in traversable_tiles:
		var id = _get_id_for_point(tile)
		astar.add_point(id, Vector3(tile.x, tile.y, 0))
		
func _connect_traversable_tiles(traversable_tiles: Array):

	for tile in traversable_tiles:
		var id = _get_id_for_point(tile)

		for x in range(3):
			for y in range(3):
				var target = tile + Vector2(x - 1, y - 1)
				var target_id = _get_id_for_point(target)
				if tile == target or not astar.has_point(target_id):
					continue
				astar.connect_points(id, target_id, true)

# Determines a unique ID for a given point on the map
func _get_id_for_point(point) -> int:
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	return x + y * used_rect.size.x

func get_the_path(start, end) -> Array:

	var start_tile = world_to_map(start)
	var end_tile = world_to_map(end)

	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)

	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return Array()

	var path_map = astar.get_point_path(start_id, end_id)

	var path_world = []
	for point in path_map:
		var point_world = map_to_world(Vector2(point.x, point.y)) + half_cell_size
		path_world.append(point_world)
	return path_world
	
func get_closest_point(point :Vector2) -> Vector2: 
	return point	