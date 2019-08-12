extends TextureRect
class_name Bag

var _max_weight = 25

func _ready():
	mouse_filter = MOUSE_FILTER_STOP ##SO THAT WE can't drop stuff

func is_full() -> bool:
	for slot in get_children():
		if slot.is_empty():
			return false
	return true
	
func is_it_too_heavy_with_new(new: PickableObject) -> bool:
	return get_weight() + new.get_weight() > _max_weight	
	
func get_empty_slot() -> InventorySlot:
	for slot in get_children():
		if slot.is_empty():
			return slot
	assert(false) ##you should check with is full before
	return null
	
func get_weight() -> int:
	var weight = 0
	for slot in get_children():
		var object = slot.get_object_in_slot()
		if object != null:
			weight += object.get_weight()
	return weight + $"../CharaDoll".get_weight()
	
func get_max_weight() -> int:
	return _max_weight	