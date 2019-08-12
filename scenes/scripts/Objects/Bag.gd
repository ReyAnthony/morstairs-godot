extends TextureRect
class_name Bag

var _max_weight = 25

func _ready():
	mouse_filter = MOUSE_FILTER_STOP ##SO THAT WE can't drop stuff

func is_full() -> bool:
	for slot in get_children():
		if slot.get_child_count() == 0:
			return false
	return true
	
func is_it_too_heavy_with_new(new: PickableObject) -> bool:
	return get_weight() + new.get_weight() > _max_weight	
	
func get_empty_slot() -> InventorySlot:
	for slot in get_children():
		if slot.get_child_count() == 0:
			return slot
	assert(false)
	return null
	
func get_weight() -> int:
	var weight = 0
	for slot in get_children():
		if slot.get_child_count() == 1:
			var object = slot.get_children()[0] as PickableObject
			weight += object.get_weight()	
	return weight + $"../CharaDoll".get_weight()
	
func get_max_weight() -> int:
	return _max_weight	