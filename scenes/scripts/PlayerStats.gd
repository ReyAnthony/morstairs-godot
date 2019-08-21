extends Stats
class_name PlayerStats

func _ready():
	_is_player = true
	_character_root = PDS.get_player()

func _on_death():
	PDS.game_over()
	get_tree().change_scene("res://scenes/Scenes/Gameover.tscn")
