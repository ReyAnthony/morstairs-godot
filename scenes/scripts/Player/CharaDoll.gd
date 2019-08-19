extends Doll
class_name CharaDoll

func _ready():
	$InfoPanel/PlayerName.text = PDS.get_player_name()
	
func _process(delta):
	pass
	
func get_weight():
	var w = 0
	for slot in $Doll.get_children():
		if !slot.is_empty():
			var object = slot.get_object_in_slot()
			w += object.get_weight()
	return w

func get_damage_string() -> String:
	return String(_get_default_damages())## + " + TODO malus etc"
	
func get_defense_string() -> String:
	return String(get_defense()) ##+ " + TODO malus etc"