extends DialogEvent
class_name DialogEventPayFine

export (NodePath) var dialog_panel: NodePath
export (NodePath) var NPC: NodePath

func _ready():
	assert(!dialog_panel.is_empty())
	assert(!NPC.is_empty())

func execute():
	if PlayerDataSingleton.can_pay_bounty():
		PlayerDataSingleton.pay_bounty()
		get_node(dialog_panel).my_popup(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $CanPay)
	else:
		get_node(dialog_panel).my_popup(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $CantPay)