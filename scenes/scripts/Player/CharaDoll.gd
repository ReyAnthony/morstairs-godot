extends Popup

func _ready():
	$InfoPanel/PlayerName.text = PDS.get_player_name()

func _process(delta):
	pass
	
func get_weight():
	var w = 0
	for slot in $Doll.get_children():
		if slot.get_child_count() == 1:
			var object = slot.get_children()[0] as PickableObject
			w += object.get_weight()
	return w