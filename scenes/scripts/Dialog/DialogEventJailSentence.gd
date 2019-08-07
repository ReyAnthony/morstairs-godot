extends DialogEvent
class_name DialogEventJailSentence

export (NodePath) var dialog_panel: NodePath
export (NodePath) var NPC: NodePath

func _ready():
	assert(!dialog_panel.is_empty())
	assert(!NPC.is_empty())

func execute():
	$Sentence.message = "Thy number of days you'll spent in jail is of " + String(PlayerDataSingleton.get_jail_time()) + " days." 
	PlayerDataSingleton.go_to_jail_reset_bounty()
	get_node(dialog_panel).my_popup(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $Sentence)
		