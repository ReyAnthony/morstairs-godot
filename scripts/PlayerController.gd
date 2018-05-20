extends KinematicBody2D

const WALK_SPEED = 20

var velocity = Vector2()

func _physics_process(delta):
	
	velocity.y = 0
	velocity.x = 0
	
	if Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_up"):
		velocity.x = -WALK_SPEED
		velocity.y = -WALK_SPEED
		$AnimatedSprite.play("NW")
	elif Input.is_action_pressed("ui_right") &&  Input.is_action_pressed("ui_down"):
		velocity.x =  WALK_SPEED
		velocity.y = WALK_SPEED
		$AnimatedSprite.play("SE")
	elif Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_down"):
		velocity.x = -WALK_SPEED
		velocity.y = WALK_SPEED
		$AnimatedSprite.play("SW")
	elif Input.is_action_pressed("ui_right") &&  Input.is_action_pressed("ui_up"):
		velocity.x =  WALK_SPEED
		velocity.y = -WALK_SPEED
		$AnimatedSprite.play("NE")

    # We don't need to multiply velocity by delta because MoveAndSlide already takes delta time into account.

    # The second parameter of move_and_slide is the normal pointing up.
    # In the case of a 2d platformer, in Godot upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))
