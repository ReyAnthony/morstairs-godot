extends Node
class_name PlayerTarget

enum TargetType {
	MOVEMENT_TARGET = 0,
	ACTION_TARGET = 1
}

var node: Node2D
var targetType: int
var _position: Vector2
var _valid := true

func _init(position: Vector2, node: Node2D = null):
	self._position = position
	self.node = node
	if node == null:
		targetType = TargetType.MOVEMENT_TARGET
	else:
		targetType = TargetType.ACTION_TARGET

func invalidate():
	_valid = false

func is_valid() -> bool: 
	if targetType == TargetType.MOVEMENT_TARGET:
		return _valid
	else:	
		return is_instance_valid(node) and _valid
	
func get_position() -> Vector2:
	if targetType == TargetType.MOVEMENT_TARGET:
		#a position on the map will not move
		return _position
	else:
		#so that it gets updated on the fly
		return node.global_position