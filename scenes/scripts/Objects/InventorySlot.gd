extends Slot
class_name InventorySlot

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	$"../../InfoPanel/ObjectName".text = "Hover on an object"
	$"../../InfoPanel/ObjectWeight".text = "to get more infos"
	._ready()

func _on_mouse_entered():
	if get_child_count() == 0:
		return
	$"../../InfoPanel/ObjectName".text = get_children()[0].get_object_name()
	$"../../InfoPanel/ObjectWeight".text = "It weighs " + String(get_children()[0].get_weight()) + " Stones"

func _on_mouse_exited():
	$"../../InfoPanel/ObjectName".text = "Hover on an object"
	$"../../InfoPanel/ObjectWeight".text = "to get more infos"