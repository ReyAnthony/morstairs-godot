extends Node
class_name Doll

const SubType = preload("res://scenes/scripts/Objects/ObjectType.gd").SubType
const ObjectType = preload("res://scenes/scripts/Objects/ObjectType.gd").ObjectType

func _ready():
	assert($Doll/WeaponSlot)
	assert($Doll/ArmorSlot)
	assert($Doll/ShieldSlot)
	assert($Doll/BootsSlot)
	assert($Doll/HelmetSlot)
	assert($Doll/QuiverSlot)
	assert($Stats)
	
func has_shield() -> bool:
	return !$Doll/ShieldSlot.is_empty()
	
func has_ranged_weapon() -> bool:
	return !$Doll/WeaponSlot.is_empty() and $Doll/WeaponSlot.get_object_in_slot().get_subtype() == SubType.RANGED

func _get_equipped_weapon() -> PickableObject:
	assert(!$Doll/WeaponSlot.is_empty())
	return $Doll/WeaponSlot.get_object_in_slot()
		
func _get_equipped_armor() -> PickableObject:
	assert(!$Doll/ArmorSlot.is_empty())
	return $Doll/ArmorSlot.get_object_in_slot()

func _get_equipped_shield() -> PickableObject:
	assert(!$Doll/ShieldSlot.is_empty())
	return $Doll/ShieldSlot.get_object_in_slot()
	
func _get_equipped_boots() -> PickableObject:
	assert(!$Doll/BootsSlot.is_empty())
	return $Doll/BootsSlot.get_object_in_slot()	
	
func _get_equipped_helmet() -> PickableObject:
	assert(!$Doll/HelmetSlot.is_empty())
	return $Doll/HelmetSlot.get_object_in_slot()
	
func _get_quiver() -> PickableObject:
	assert(!$Doll/QuiverSlot.is_empty())
	return $Doll/QuiverSlot.get_object_in_slot()

func _get_default_damages() -> int:
	if $Doll/WeaponSlot.is_empty(): ##fists
		return 1
	if get_weapon_subtype() == SubType.RANGED:
		if !$Doll/QuiverSlot.is_empty():
			return _get_equipped_weapon().get_damages() + _get_quiver().get_damages()
		else:
			return 0 ##no damages if no ammo.
	else:
		return _get_equipped_weapon().get_damages()
		
func get_weapon_subtype() -> int:
	##maybe return something specific for fists
	if $Doll/WeaponSlot.is_empty():
		return SubType.MELEE
	else:
		return _get_equipped_weapon().sub_type

##TODO USE STATS TO MITIGATES STUFF
func get_damages(defender: Doll) -> int: 
	return int(max(_get_default_damages() - defender.get_defense(), 0))

func get_defense() -> int:
	var def = 0
	if !$Doll/ArmorSlot.is_empty():
		def += _get_equipped_armor().get_defense()
	if !$Doll/ShieldSlot.is_empty():
	    def += _get_equipped_shield().get_defense()
	if !$Doll/BootsSlot.is_empty():
	    def += _get_equipped_boots().get_defense()
	if !$Doll/HelmetSlot.is_empty():
	    def += _get_equipped_helmet().get_defense()
	return def
	
func get_stats() -> Stats:
	return $Stats as Stats