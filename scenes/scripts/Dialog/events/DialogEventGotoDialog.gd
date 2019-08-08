extends DialogEvent
class_name DialogEventGotoDialog

export (NodePath) var NPC: NodePath
export (NodePath) var start_node: NodePath

func execute():
	DS.spawn_dialog(get_node(NPC).chara_name, get_node(NPC).chara_portrait, get_node(start_node))