extends CharacterBody2D

@export var gravity = 500
@export var fall_multiplier := 1.5
@export var jump_force = 250
@export var jump_spit_force = 200
@export var speed = 350
@export var max_speed = 170
@export var friction = 10

@onready var spit_timer = %SpitTimer
@onready var jump_spit_timer = %JumpSpitTimer
@onready var jump_sfx: RandomAudioStreamPlayer = $JumpSfx
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var can_spit = false
var can_jump_spit = false
var is_jumping = false
var jump_pressed = false
var jump_time = 0.0
var jump_max_time = 0.35
var jump_min_force = 80

signal pit_fall_death

func _ready():
	animation_player.play("idle")
	connect("pit_fall_death", _on_pit_fall_death)
	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		velocity.x += speed * delta
		animated_sprite.scale.x = 1
	elif Input.is_action_pressed("move_left"):
		velocity.x -= speed * delta
		animated_sprite.scale.x = -1
	else:
		if abs(velocity.x) > 0:
			velocity.x = int(lerp(velocity.x, 0.0, friction * delta))

	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if velocity.y > 0:
		velocity.y += gravity * fall_multiplier * delta
	else:
		velocity.y += gravity * delta

	if is_on_floor():
		is_jumping = false
		jump_time = 0.0
			
		if Input.is_action_just_pressed("jump"):
			jump_pressed = true
			is_jumping = true
			velocity.y = - jump_force
			var jump_vfx = preload("res://scenes/vfx/jump_vfx.tscn").instantiate()
			jump_vfx.position = position
			get_parent().add_child(jump_vfx)
			jump_sfx.play_random()
		if Input.is_action_just_pressed("spit") and can_spit:
			spit_attack(false)
	else:
		if is_jumping:
			jump_time += delta
			if not Input.is_action_pressed("jump") or jump_time > jump_max_time:
				if velocity.y < -jump_min_force:
					velocity.y = - jump_min_force
				is_jumping = false
		if Input.is_action_just_pressed("spit") and can_jump_spit:
			spit_attack(true)
			velocity.y = - jump_spit_force

	move_and_slide()

func _on_spit_timer_timeout():
	can_spit = true
	$SpitTimer.stop()

func _on_jump_spit_timer_timeout():
	can_jump_spit = true
	$JumpSpitTimer.stop()

func spit_attack(jumping):
	var spit = preload("res://scenes/spit.tscn").instantiate()
	
	if jumping:
		can_jump_spit = false
		jump_spit_timer.start()
		spit.rotation_degrees = 90
		spit.position = position + Vector2(0, -14)
	else:
		can_spit = false
		spit_timer.start()
		spit.position = position + Vector2((7 * animated_sprite.scale.x), -14)
		spit.scale.x = animated_sprite.scale.x

	get_parent().add_child(spit)

func _on_pit_fall_death():
	can_jump_spit = false
	jump_spit_timer.stop()
	
	if %CustomCamera != null:
		%CustomCamera.node_to_follow = null
	
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
