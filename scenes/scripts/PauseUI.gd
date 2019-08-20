extends Popup
class_name PauseUI

func _ready():
	$TextureRect/Fullscreen/CheckBox.connect("pressed", self, "_on_fullscreen_pressed")
	
func _on_fullscreen_pressed():
	GS.switch_fullscreen_mode()
