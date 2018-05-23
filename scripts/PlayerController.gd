extends KinematicBody2D

const WALK_SPEED = 30

var velocity = Vector2()

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = true
		$CanvasLayer/PlayerInventory.show_inventory()	

func _physics_process(delta):
	
	velocity.y = 0
	velocity.x = 0
	
	if Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_up"):
		velocity.x = -WALK_SPEED
		velocity.y = -WALK_SPEED
		$AnimatedSprite.play("NW")
	elif Input.is_action_pressed("ui_right") &&  Input.is_action_pressed("ui_up"):
		velocity.x =  WALK_SPEED
		velocity.y = -WALK_SPEED
		$AnimatedSprite.play("NE")
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -WALK_SPEED
		$AnimatedSprite.play("N")
	elif Input.is_action_pressed("ui_right") &&  Input.is_action_pressed("ui_down"):
		velocity.x =  WALK_SPEED
		velocity.y = WALK_SPEED
		$AnimatedSprite.play("SE")
	elif Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_down"):
		velocity.x = -WALK_SPEED
		velocity.y = WALK_SPEED
		$AnimatedSprite.play("SW")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = WALK_SPEED
		$AnimatedSprite.play("S")
	elif Input.is_action_pressed("ui_right"):
		velocity.x = WALK_SPEED
		$AnimatedSprite.play("E")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		$AnimatedSprite.play("W")
		
	move_and_slide(velocity.normalized() * WALK_SPEED, Vector2(0, -1))
