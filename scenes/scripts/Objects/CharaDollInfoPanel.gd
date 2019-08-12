extends TextureRect

func _process(delta):
	var stats = PDS.get_player().get_stats()
	$HP.text = String(stats.get_life()) + "/" + String(stats.get_max_life()) + " HP"