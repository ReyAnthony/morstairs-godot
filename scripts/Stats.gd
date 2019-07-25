extends Node2D

export (int) var life
export (PackedScene) var damage

func attack(damages):
	#todo last one is lost when queue_free
	var dmg = damage.instance()
	dmg.get_node("Label").text = str(damages)
	add_child(dmg)
	life -= 1
	if life < 1:
		$"../".queue_free()
