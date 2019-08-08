extends Control
class_name InventorySlot

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
