extends DialogEvent
class_name DialogEventHowMuch

export (NodePath) var NPC: NodePath

func _ready():
	assert(!NPC.is_empty())

func execute():
	$HowMuch.message = "Thy fine is of " + String(PDS.get_bounty()) + " gold coins." 
	DS.spawn_dialog(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $HowMuch)