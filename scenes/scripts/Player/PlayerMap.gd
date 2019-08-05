extends Control

var _map_cam: Camera2D

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	$"../Panel/Map".connect("pressed", self, "_on_show_map")
	$Close.connect("pressed", self, "_on_close_map")
	_map_cam = get_tree().get_nodes_in_group("map_cam")[0]

func _on_show_map():
	$"../Panel".hide()
	show()
	get_tree().paused = true
	$"../../Camera2D".current = false
	_map_cam.current = true

func _on_close_map():
	hide()
	$"../Panel".show()
	$"../../Camera2D".current = true
	_map_cam.current = false
	get_tree().paused = false
