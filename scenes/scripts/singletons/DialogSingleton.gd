extends Node
class_name DialogSingleton

var dialog_panel: PackedScene = preload("res://scenes/Scenes/Dialog/DialogPanel.tscn")
var panel: DialogPanel

func _ready():
	panel = dialog_panel.instance()
	var canvas = CanvasLayer.new()
	canvas.layer = 0
	canvas.add_child(panel)
	add_child(canvas)

func spawn_dialog(chara_name: String, chara_portrait: Texture, dialog_node: DialogMessage):
	panel.my_popup(chara_name, chara_portrait, dialog_node)