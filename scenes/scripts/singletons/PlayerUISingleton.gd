extends Node

var uiScene: PackedScene = preload("res://scenes/Scenes/PlayerUI.tscn")

func _ready():
	var scene = uiScene.instance()
	self.add_child(scene)
	
func add_to_inventory(object: PickableObject):
	$PlayerUI.add_to_inventory(object)
	