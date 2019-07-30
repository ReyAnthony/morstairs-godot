extends Node
class_name PlayerTarget

var position: Vector2
var node: Node2D

func _init(position: Vector2, node: Node2D):
	self.position = position
	self.node = node