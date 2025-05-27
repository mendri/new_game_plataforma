class_name PitFallDeathArea
extends Area2D

@onready var fall_sfx: RandomAudioStreamPlayer = $FallSfx

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player = body as CharacterBody2D
		player.emit_signal("pit_fall_death")
		fall_sfx.play_random()
