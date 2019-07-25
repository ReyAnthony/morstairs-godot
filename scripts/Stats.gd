extends Node2D

export (int) var life
export (PackedScene) var damage
export (PackedScene) var corpse

func attack(damages):
	#TODO DELETE THE LAST DMG
	#BROKEN ON SHOPKEEPER (one level of node more)
	var dmg = damage.instance()
	dmg.get_node("Label").text = str(damages)
	life -= damages
	
	if life < 1:
		var r = $"../../"
		var rp = r.get_parent()
		var c = corpse.instance()
		r.add_child(dmg)
		rp.add_child(c)
		rp.move_child(c, rp.get_position_in_parent() + 1)
		c.global_position = global_position
		dmg.global_position = global_position
		$"../".queue_free()
	else:
		
		add_child(dmg)	
