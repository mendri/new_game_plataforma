extends Node2D

@onready var checkpoint_area: Area2D = $CheckpointArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

enum State {
	RESTING,
	USED,
	GETTING_BIG,
}

var current_state = State.RESTING

func _process(_delta: float) -> void:
	match current_state:
		State.RESTING:
			animated_sprite.play("resting")
		State.USED:
			animated_sprite.play("used")
		State.GETTING_BIG:
			animated_sprite.play("getting_big")
			print(animated_sprite.frame)
			if animated_sprite.frame == 9:
				current_state = State.USED

func _on_checkpoint_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_checkpoint_position(position)
		current_state = State.GETTING_BIG
