extends DialogEvent
class_name DialogEventGotoDialog

export (NodePath) var dialog_panel: NodePath
export (NodePath) var NPC: NodePath
export (NodePath) var start_node: NodePath

func execute():
	get_node(dialog_panel).my_popup(get_node(NPC).chara_name, get_node(NPC).chara_portrait, get_node(start_node))