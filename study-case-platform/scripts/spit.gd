extends Node2D

var speed := 200
var direction := Vector2.ZERO

func _ready():
	pass
	if rotation_degrees == 90:
		direction = Vector2.DOWN
	else:
		if scale.x >= 0:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT

func _process(delta):
	position += direction * speed * delta

func _on_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		area.queue_free()
		
	queue_free()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): return
	if body.is_in_group("enemy"): body.queue_free()

	queue_free()
