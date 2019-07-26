extends KinematicBody2D

const WALK_SPEED = 30
var velocity = Vector2()
var f = ""
var is_attacking = false
var last_dir = "NW"

func _ready():
	set_process(true)
	$AnimatedSprite.play("NW")
	
func _process(delta):
	var anim_direction = ""
	var anim = ""
	var target = PlayerDataSingleton.get_target()
		
	if Input.is_action_just_pressed("ui_pause"):
		PlayerDataSingleton.clear_target()
		get_tree().paused = true
		$CanvasLayer/PlayerInventory.show_inventory()
	elif Input.is_action_just_pressed("switch_combat_mode"):
		PlayerDataSingleton.clear_target()
		if PlayerDataSingleton.fight_mode: 
			$AnimationPlayer.play("FightOff")
			$AnimatedSprite.play(last_dir)
		else:
			$AnimationPlayer.play("FightOn")
			$AnimatedSprite.play(last_dir + "_FIGHT")
		PlayerDataSingleton.fight_mode = !PlayerDataSingleton.fight_mode
	
	if  target != null:
		#make movement only diagonal, so we don't have to make 8 sprites
		velocity = (target.position - self.global_position).normalized()
		
		if velocity.y > 0:
			anim_direction += "S"
		elif velocity.y < 0:
			anim_direction += "N"
		if velocity.x < 0:
			anim_direction += "W"
		elif velocity.x > 0:
			anim_direction += "E"
		
		if (target.position - self.global_position).length() < 2:
			PlayerDataSingleton.clear_target()
			velocity.x = 0
			velocity.y = 0
		pass
	
	if PlayerDataSingleton.fight_mode:
		anim = "_FIGHT"	
		if is_attacking and PlayerDataSingleton.get_target() != null:
			anim += "_MELEE_ATTACK"	

	if anim_direction != "":
		$AnimatedSprite.play(anim_direction + anim)
		last_dir = anim_direction
	if velocity.length() < 0.1:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
		
	move_and_slide(velocity.normalized() * WALK_SPEED)

func _on_AnimatedSprite_animation_finished():
	if is_attacking and PlayerDataSingleton.target != null and PlayerDataSingleton.target.node != null :
		PlayerDataSingleton.target.node.get_stats().attack(1)

func _unhandled_input(event):
	if Input.is_action_pressed("mouse_left_click"):
		is_attacking = false
		PlayerDataSingleton.clear_target()
		PlayerDataSingleton.set_target(get_global_mouse_position(), null)
		#HACK not to click directly on the player
		var dist = (get_global_mouse_position() - self.global_position)
		if dist.x > -5 and dist.x < 5 :
			PlayerDataSingleton.clear_target()
	else:
		velocity.x = 0
		velocity.y = 0

func _on_Interactable_something_entered_inside_interactable(body):
	if PlayerDataSingleton.target == null:
		return
	if PlayerDataSingleton.fight_mode && PlayerDataSingleton.target.node == body:
		is_attacking = true
