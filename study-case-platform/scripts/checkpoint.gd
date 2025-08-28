extends Node2D

@onready var checkpoint_area: Area2D = $CheckpointArea

func _on_checkpoint_area_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		print("Entrou")
		print(position)
		body.set_checkpoint_position(position)
