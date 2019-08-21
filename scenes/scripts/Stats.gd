extends Node2D
class_name Stats

export (int) var life: int

onready var _character_root = get_node("../../")
var _current_life: int
var _is_player := false

func _ready():
	_current_life = life
	
func get_life() -> int:
	return _current_life
	
func get_max_life() -> int:
	return life
	
func attack(damages: int):
	_current_life -= damages
	CSS.spawn_damages(damages, _character_root.global_position, _is_player)
	if _current_life < 1:
		_on_death()
	
func _on_death():
	pass #implement in subsclass	

func full_heal():
	_current_life = life