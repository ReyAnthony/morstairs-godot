extends KinematicBody2D
class_name GenericProjectile

var _move :bool = false
var _direction: Vector2 = Vector2.ZERO

func _process(delta):
	if _move:
		move_and_slide(_direction * 150)

func fire(direction: Vector2):
	_move = true
	_direction = direction