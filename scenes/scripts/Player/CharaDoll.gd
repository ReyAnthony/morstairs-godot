extends Popup

##TODO can't drop stuff from the charadoll
func _ready():
	$InfoPanel/PlayerName.text = PDS.get_player_name()

func _process(delta):
	pass
	