extends Node2D
class_name AttackBehavior

enum Behaviors {
	FLEE,
	FIGHT
}

export(Behaviors) var behavior

func _ready():
	$"../".connect("is_attacked", self, "_on_NPC_is_attacked")

func _on_NPC_is_attacked(attacker: PhysicsBody2D):
	if behavior == Behaviors.FLEE:
		##give the information to the locomotion component, by giving a random REACHABLE target
		pass
	else if behavior == Behaviors.FIGHT:
		##give the information to the locomotion component
		##disable all dialog options
		##actually fight back
		pass
	pass

