extends Control
class_name Slot

var preview = null

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	
func _process(delta):
	if preview == null or !is_instance_valid(preview):
		if !is_empty():
			var obj = get_object_in_slot()
			obj.show()

func get_drag_data(position):
	if is_empty():
		return null
	var obj = get_object_in_slot()
	preview = TextureRect.new()
	preview.texture = obj.get_node("Sprite").texture
	preview.rect_scale = Vector2(5,5)
	set_drag_preview(preview)
	obj.hide()
	return obj

func can_drop_data(position, data):
	assert(.get_child_count() <= 1)
	return is_empty() or (get_object_in_slot().is_stackable() and data.is_same(get_object_in_slot()))

func drop_data(position, data):
	if !is_empty() and get_object_in_slot().is_stackable():
		get_object_in_slot().merge_stack(data)
		return
	data.show()
	data.get_parent().remove_child(data)
	add_child(data)

func get_object_in_slot() -> PickableObject:
	if !is_empty():
		return .get_children()[0]
	assert(false) ## USE is_empty before calling
	return null	

func is_empty() -> bool:
	return .get_child_count() == 0

func get_child_count() -> int:
	assert(false) ## USE is_empty
	return 0
	
func get_children() -> Array:
	assert(false) ##WE SHOULD NOT USE THIS METHOD but get_object_in_slot() 
	return Array()

func _on_mouse_entered():
	if is_empty():
		return
	get_object_in_slot().modulate = Color.gray

func _on_mouse_exited():
	if is_empty():
		return
	get_object_in_slot().modulate = Color.white