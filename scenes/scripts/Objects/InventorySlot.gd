extends Slot
class_name InventorySlot

var _info_panel: InventoryInfoPanel

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	_info_panel = $"../../InfoPanel"
	_info_panel.reset()
	._ready()

func _on_mouse_entered():
	if get_child_count() == 0:
		return
	_info_panel.update_panel(get_children()[0].get_object_name(), get_children()[0].get_weight())

func _on_mouse_exited():
	_info_panel.reset()