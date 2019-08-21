extends Stats
class_name NPCStats

export (PackedScene) var corpse: PackedScene

func _on_death():
	if PDS.get_target().node == _character_root:
		PDS.clear_target()
	CSS.spawn_cadaver($"../".get_equipement(), corpse, _character_root.global_position)
	_character_root.call_deferred("free")