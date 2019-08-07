extends DialogEvent
class_name DialogEventHowMuch

export (NodePath) var dialog_panel: NodePath
export (NodePath) var NPC: NodePath

func _ready():
	assert(!dialog_panel.is_empty())
	assert(!NPC.is_empty())

func execute():
	$HowMuch.message = "Thy fine is of " + String(PlayerDataSingleton.get_bounty()) + " gold coins." 
	get_node(dialog_panel).my_popup(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $HowMuch)