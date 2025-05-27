extends Camera2D

@export var node_to_follow: Node2D

func _physics_process(delta: float) -> void:
	if node_to_follow == null:
		return

	position = position.lerp(node_to_follow.position, delta * 12)
