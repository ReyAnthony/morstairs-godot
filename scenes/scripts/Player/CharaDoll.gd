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

	
##TODO can't throw stuff if inventory not openned	