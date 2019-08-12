extends Popup

var dm: DialogMessage

func _ready():
	for c in $Bag.get_children():
		if c.get_child_count() == 1:
			c.get_child(0).scale = Vector2(4,4)
	dm = DialogMessage.new()
	dm.message = "You can't place anything here anymore !"
	var de =  DialogEventPauseGame.new()
	self.add_child(de)
	dm._dialog_event = de
	self.add_child(dm)
	
func can_drop_data(position, data) -> bool:
	return true
	
func drop_data(position, data):
	var position_on_the_ground = get_a_position_on_the_ground_without_object()
	if position_on_the_ground == Vector2(-10000, -100000):
		DS.spawn_dialog("", null, dm)
		return
			
	data.get_parent().remove_child(data)
	PDS.get_player().get_parent().add_child(data)
	PDS.get_player().get_parent().move_child(data, 0)
	data.global_position = position_on_the_ground
	data.scale = Vector2(1,1)
	data.show()
		
func get_a_position_on_the_ground_without_object() -> Vector2:
	var objects_on_ground := []
	var parent = PDS.get_player().get_parent()
	var tilemap := PDS.get_player().get_parent().get_parent() as TileMap
	var cell_size = tilemap.cell_size.x
	for c in parent.get_children():
		if c is PickableObject:
			if PDS.get_player().global_position.distance_to(c.global_position) <= cell_size * 3:
				objects_on_ground.append(tilemap.map_to_world(tilemap.world_to_map(c.global_position)))
			else:
				break #they are supposed to be in first position of the childrens		
	
	var position = tilemap.map_to_world(tilemap.world_to_map(PDS.get_player().global_position))
	if objects_on_ground.empty():
		#we lower the precision to get the center of the cell at the point
		return position
	else:
		var initial_position = position
		for x in range(-cell_size, cell_size+ 1, cell_size): #range is < x not <= so +1
			print (x)
			for y in  range(-cell_size, cell_size +1, cell_size):
				print("y" + String(y))
				var where = tilemap.map_to_world(tilemap.world_to_map(initial_position + Vector2(x, y)))
				print(where)
				var cell = tilemap.get_cellv(tilemap.world_to_map(where))
				##TODO AVOID WATER CELLS
				##we want an invalid cell BECAUSE THERE IS NO WALL THEN
				if !objects_on_ground.has(where) and cell == tilemap.INVALID_CELL:
					return where
	assert(PDS.get_player().global_position != Vector2(-10000, -100000)) 				
	return Vector2(-10000, -100000) #HACKISH
	
func add_to_inventory(object: PickableObject) -> int:
	if $Bag.is_full():
		return 1
	if $Bag.is_it_too_heavy_with_new(object):
		return 2
	object.get_parent().remove_child(object)
	$Bag.get_empty_slot().add_child(object)
	object.position = Vector2.ZERO
	object.scale = Vector2(4,4)
	return 0