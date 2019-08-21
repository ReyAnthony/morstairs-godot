extends Stats
class_name PlayerStats

func _ready():
	_is_player = true
	_character_root = get_node("../")

func _on_death():
	PDS.game_over()
	get_tree().change_scene("res://scenes/Scenes/Gameover.tscn")
