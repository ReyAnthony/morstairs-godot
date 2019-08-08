extends DialogEvent
class_name DialogEventJailSentence

export (NodePath) var NPC: NodePath

func _ready():
	assert(!NPC.is_empty())

func execute():
	$Sentence.message = "Thy number of days you'll spent in jail is of " + String(PDS.get_jail_time()) + " days." 
	PDS.go_to_jail_reset_bounty()
	DS.spawn_dialog(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $Sentence)
		