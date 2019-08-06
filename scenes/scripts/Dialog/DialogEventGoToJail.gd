extends DialogEvent
class_name DialogEventGoToJail

func execute():
	PlayerDataSingleton.go_to_jail_reset_bounty()
	get_tree().get_nodes_in_group("player")[0].global_position = get_tree().get_nodes_in_group("jail")[0].global_position
