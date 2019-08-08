extends DialogEvent
class_name DialogEventPayFine

export (NodePath) var NPC: NodePath

func _ready():
	assert(!NPC.is_empty())

func execute():
	if PDS.can_pay_bounty():
		PDS.pay_bounty()
		DS.spawn_dialog(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $CanPay)
	else:
		DS.spawn_dialog(get_node(NPC).chara_name, get_node(NPC).chara_portrait, $CantPay)