extends Slot
class_name DollSlot

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType

export (ObjectType) var slot_type: int

func can_drop_data(position, data):
	var ret = .can_drop_data(position, data)
	return ret and data.get_type() == slot_type