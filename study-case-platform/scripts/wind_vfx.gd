extends GPUParticles2D

@export var node_to_follow: Node2D
@export var speed: float = 100.0

func _ready() -> void:
    if node_to_follow == null:
        print("Node to follow is not set.")
        return

    global_position = node_to_follow.global_position

func _process(delta: float) -> void:
    if node_to_follow == null:
        return

    var direction = (node_to_follow.global_position - global_position).normalized()
    global_position += direction * speed * delta

    # Update the rotation to face the node
    rotation = direction.angle()