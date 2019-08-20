extends Node
class_name Settings

func _ready():
	pass # Replace with function body.

func is_fullscreen():
	return OS.window_fullscreen
	
func switch_fullscreen_mode():
	OS.window_fullscreen = !OS.window_fullscreen
