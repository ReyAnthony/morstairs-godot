extends Slot
class_name DollSlot

const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType
var _inventory_info_panel: InventoryInfoPanel
export (ObjectType) var slot_type: int

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	_inventory_info_panel = $"../../../InfoPanel"
	_inventory_info_panel.reset()

func can_drop_data(position, data):
	var ret = .can_drop_data(position, data)
	return ret and data.get_type() == slot_type

func _on_mouse_entered():
	if is_empty():
		return
	var o = get_object_in_slot()	
	_inventory_info_panel.update_panel(o.get_object_name(), o.get_weight())

func _on_mouse_exited():
	_inventory_info_panel.reset()