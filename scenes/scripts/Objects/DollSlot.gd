extends Slot
class_name DollSlot

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType
var _info_panel: InventoryInfoPanel
export (ObjectType) var slot_type: int

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	_info_panel = $"../../../InfoPanel"
	_info_panel.reset()

func can_drop_data(position, data):
	var ret = .can_drop_data(position, data)
	return ret and data.get_type() == slot_type
	
func _on_mouse_entered():
	if get_child_count() == 0:
		return
	_info_panel.update_panel(get_children()[0].get_object_name(), get_children()[0].get_weight())

func _on_mouse_exited():
	_info_panel.reset()	