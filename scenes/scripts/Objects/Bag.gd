extends TextureRect
class_name Bag

func _ready():
	mouse_filter = MOUSE_FILTER_STOP ##SO THAT WE can't drop stuff

func is_full() -> bool:
	for slot in get_children():
		if slot.is_empty():
			return false
	return true
	
func get_weight() -> int:
	var weight = 0
	for slot in get_children():
		if !slot.is_empty():
			var object = slot.get_object_in_slot()
			weight += object.get_weight()
	return weight		
	
func add_object_in_empty_slot(object):
	_get_empty_slot().add_child(object)
	object.position = Vector2.ZERO
	object.scale = Vector2(4,4)
	
func _get_empty_slot() -> InventorySlot:
	for slot in get_children():
		if slot.is_empty():
			return slot
	assert(false) ##you should check with is full before
	return null
	

