extends Control
class_name Slot

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")

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
	return get_child_count() == 0 ##show weight popup ? (could be used when using containers)

func drop_data(position, data):
	data.show()
	data.get_parent().remove_child(data)
	add_child(data)

func _on_mouse_entered():
	if get_child_count() == 0:
		return
	pass

func _on_mouse_exited():
	pass