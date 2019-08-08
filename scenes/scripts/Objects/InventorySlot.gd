extends Control
class_name InventorySlot

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	$"../../InfoPanel/ObjectName".text = "Hover on an object"
	$"../../InfoPanel/ObjectWeight".text = "to get more infos"

func get_drag_data(position):
	if get_child_count() == 0:
		return null
	var obj = get_children()[0]
	var preview = TextureRect.new()
	preview.texture = obj.get_node("Sprite").texture
	preview.rect_scale = Vector2(4,4)
	set_drag_preview(preview)
	return obj

func can_drop_data(position, data):
	assert(get_child_count() <= 1)
	return get_child_count() == 0

func drop_data(position, data):
	data.show()
	data.get_parent().remove_child(data)
	add_child(data)

func _on_mouse_entered():
	if get_child_count() == 0:
		return
	$"../../InfoPanel/ObjectName".text = get_children()[0].get_object_name()
	$"../../InfoPanel/ObjectWeight".text = "It weighs " + String(get_children()[0].get_weight()) + " Stones"

func _on_mouse_exited():
	$"../../InfoPanel/ObjectName".text = "Hover on an object"
	$"../../InfoPanel/ObjectWeight".text = "to get more infos"