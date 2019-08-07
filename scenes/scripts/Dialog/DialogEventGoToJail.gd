extends DialogEvent
class_name DialogEventGoToJail

export (NodePath) var dialog_panel: NodePath

func execute():
	PlayerDataSingleton.clear_target()
	PlayerDataSingleton.get_player().global_position = get_tree().get_nodes_in_group("jail")[0].global_position
	