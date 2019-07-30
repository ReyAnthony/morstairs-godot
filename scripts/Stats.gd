extends Node2D
class_name Stats

export (int) var life: int
export (PackedScene) var damage: PackedScene
export (PackedScene) var corpse: PackedScene
export (String) var root: String

var _current_life: int

func _ready():
	_current_life = life

func attack(damages: int):
	var dmg = damage.instance()
	dmg.get_node("Label").text = str(damages)
	_current_life -= damages
	
	if _current_life < 1:
		var r := get_node(root)
		var rp := r.get_parent()
		var c := corpse.instance()
		r.add_child(dmg)
		rp.add_child(c)
		rp.move_child(c, rp.get_position_in_parent() + 2)
		c.global_position = global_position
		dmg.global_position = global_position
		$"../".queue_free()
	else:
		add_child(dmg)	
