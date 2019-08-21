extends Doll
class_name CharaDoll

func _ready():
	$InfoPanel/PlayerName.text = PDS.get_player_name()
	assert($Stats is PlayerStats)
	
func _process(delta):
	pass
	
func get_weight():
	var w = 0
	for slot in $Doll.get_children():
		if !slot.is_empty():
			var object = slot.get_object_in_slot()
			w += object.get_weight()
	return w

func get_damage_string() -> String:
	return String(_get_default_damages())## + " + TODO malus etc"
	
func get_defense_string() -> String:
	return String(get_defense()) ##+ " + TODO malus etc"
	
func get_gold() -> int:
	if $Doll/CashSlot.is_empty():
		return 0
	return $Doll/CashSlot.get_object_in_slot().get_stack_count()
	
func use_ranged_weapon(shot_direction: Vector2, initial_position: Vector2, parent: Node2D):
	assert(_get_equipped_weapon().get_type() == ObjectType.WEAPON)
	assert(_get_equipped_weapon().sub_type == SubType.RANGED)
	assert(_get_quiver().get_type() == ObjectType.AMMO)
	assert(_get_quiver().get_stack_count() > 0) 
	_get_quiver().set_stack_count(_get_quiver().get_stack_count() - 1)
	##make a generic projectile and shoot it
	CSS.spawn_projectile(initial_position, shot_direction)

func update_gold(amount: int):
	assert(amount >= 0)
	assert(!$Doll/CashSlot.is_empty()) ##cashslot is a special case
	var gold = $Doll/CashSlot.get_object_in_slot()
	gold.set_stack_count(amount)