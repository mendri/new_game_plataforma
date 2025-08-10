extends CharacterBody2D

@export var speed = 50
@export var chase_speed = 150
@export var acceleration = 300
@export var life = 3
@export var player: CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@onready var how_much_time_to_explode_timer: Timer = $HowMuchTimeToExplodeTimer

var direction = Vector2.ZERO
var left_bounds = Vector2.ZERO
var right_bounds = Vector2.ZERO

enum State {
	IDLE,
	CHASE,
	STARTING_TO_EXPLODE,
}

var current_state: State = State.IDLE

func _ready():
	left_bounds = position + Vector2(-125, 0)
	right_bounds = position + Vector2(125, 0)

func _physics_process(delta):
	handle_movement(delta)
	change_direction(delta)
	handle_gravity(delta)
	look_for_player()

func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider.is_in_group("player"):
			chase_player()
		elif current_state == State.CHASE:
			stop_chasing()
	elif current_state == State.CHASE:
		stop_chasing()

func chase_player():
	timer.stop()
	current_state = State.CHASE

func stop_chasing():
	if timer.time_left <= 0:
		timer.start()

func change_direction(_delta):
	if current_state == State.IDLE:
		if sprite.flip_h:
			# Moving right
			if self.position.x <= right_bounds.x:
				direction = Vector2.RIGHT
			else:
				sprite.flip_h = false
				ray_cast.target_position = Vector2(-125, 0)
		else:
			# Moving left
			if self.position.x >= left_bounds.x:
				direction = Vector2.LEFT
			else:
				sprite.flip_h = true
				ray_cast.target_position = Vector2(125, 0)
	elif current_state == State.CHASE:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)

		if direction.x == 1:
			sprite.flip_h = false
			ray_cast.target_position = Vector2(-125, 0)
		else:
			sprite.flip_h = true
			ray_cast.target_position = Vector2(125, 0)

func handle_movement(delta):
	if current_state == State.IDLE:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	elif current_state == State.CHASE:
		velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)

	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += delta * 1000

func _on_timer_timeout() -> void:
	current_state = State.IDLE

func take_damage(dmg_points: int) -> void:
	life -= dmg_points
	if life <= 0:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)


func _on_area_start_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_state = State.STARTING_TO_EXPLODE
		how_much_time_to_explode_timer.start()
		velocity = Vector2.ZERO  # Stop movement during explosion
