extends Node2D
class_name Stats

export (bool) var player := false
export (int) var life: int
export (PackedScene) var damage: PackedScene
export (PackedScene) var corpse: PackedScene
export (String) var _to_free: String = "../"

var _root: String = "/root/Level/DayNight/Level/Walls/"
var _current_life: int
signal life_changed

func _ready():
	_current_life = life
	
func get_life() -> int:
	return _current_life
	
func get_max_life() -> int:
	return life
	
func attack(damages: int):
	var dmg = damage.instance()
	dmg.get_node("Label").text = str(damages)
	if player:
		(dmg.get_node("Label") as Label).add_color_override("font_color", Color.violet)
	_current_life -= damages
	
	if _current_life < 1:
		if !player:
			if PDS.get_target().node == $"../":
				PDS.clear_target()
		else:
			get_tree().change_scene("res://scenes/Scenes/Gameover.tscn")
			return		
				
		var r := get_node(_root)
		var rp := r.get_parent()
		var c := corpse.instance()
		r.add_child(dmg)
		rp.add_child(c)
		rp.move_child(c, rp.get_position_in_parent() +1)
		c.global_position = global_position
		dmg.global_position = global_position
		get_node(_to_free).call_deferred("free")
	else:
		add_child(dmg)
		
	emit_signal("life_changed")	

func full_heal():
	_current_life = life
	emit_signal("life_changed")	