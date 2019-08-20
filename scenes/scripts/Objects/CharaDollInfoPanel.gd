extends TextureRect

func _process(delta):
	if is_instance_valid(PDS.get_player()):
		var stats = PDS.get_player().get_stats()
		$HP.text = String(stats.get_life()) + "/" + String(stats.get_max_life()) + " HP"
		$ATK.text = "ATK : " + String($"../".get_damage_string())
		$DEF.text = "DEF : " + String($"../".get_defense_string())
		$GOLD.text = "Gold : " + String(PDS.get_player_gold())