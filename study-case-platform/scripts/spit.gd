extends Node2D

@onready var spit_sprite: AnimatedSprite2D = $SpitSprite

var speed := 200
var direction := Vector2.ZERO

func _ready():
	spit_sprite.play("default")
	if rotation_degrees == 90:
		direction = Vector2.DOWN
	else:
		if scale.x >= 0:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT

func _process(delta):
	position += direction * speed * delta

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): return
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(1)

	queue_free()
