extends KinematicBody2D
class_name GenericProjectile

var _move :bool = false
var _direction: Vector2 = Vector2.ZERO

func _ready():
	$Area2D.connect("body_entered", self, "_on_projectile_touches_npc")

func _process(delta):
	if _move:
		move_and_slide(_direction * 150)

func fire(direction: Vector2):
	_move = true
	_direction = direction
	
func _on_projectile_touches_npc(body: PhysicsBody2D):
	if !body is NPC:
		return 
	body = body as NPC
	if body.can_be_hit:
		##Will break if you change weapon before it touches
		body.attack(PDS.get_chara_doll(), PDS.get_player())
		queue_free()
		