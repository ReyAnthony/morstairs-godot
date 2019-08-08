extends DialogEvent
class_name DialogEventGoToJail

export (NodePath) var dialog_panel: NodePath

func execute():
	PDS.clear_target()
	PDS.get_player().global_position = get_tree().get_nodes_in_group("jail")[0].global_position
	