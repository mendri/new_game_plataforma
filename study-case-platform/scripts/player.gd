extends CharacterBody2D

@export var gravity = 500
@export var jump_force = 190
@export var speed = 350
@export var max_speed = 170
@export var friction = 10

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		velocity.x += speed * delta
		$AnimatedSprite2D.scale.x = 1
	elif Input.is_action_pressed("move_left"):
		velocity.x -= speed * delta
		$AnimatedSprite2D.scale.x = -1
	else:
		if abs(velocity.x) > 0:
			velocity.x = int(lerp(velocity.x, 0.0, friction * delta))

	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y += gravity * delta

	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
			var jump_vfx = preload("res://scenes/vfx/jump_vfx.tscn").instantiate()
			jump_vfx.position = position + Vector2(0, 0)
			get_parent().add_child(jump_vfx)

	move_and_slide()
