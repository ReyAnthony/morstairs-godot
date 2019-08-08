extends Popup

func _ready():
	##$InventoryPopup/Bag.connect("mouse_entered", self, "_on_mouse_entered")
	##$InventoryPopup/Bag.connect("mouse_exited", self, "_on_mouse_exited")
	pause_mode = PAUSE_MODE_PROCESS

func show_inventory():
	get_tree().paused = true
	show()
	.popup()
	
func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	if !$Bag.get_rect().has_point(position):
		data.get_parent().remove_child(data)
		print("dropped sword")
		data.free()