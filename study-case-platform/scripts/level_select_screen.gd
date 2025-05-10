extends MarginContainer

@export var level_select_container_scene: PackedScene
@onready var back_btn = %BackBtn

signal back_select_level_pressed

func _ready() -> void:
    var grid_container = %LevelSelectGridContainer

    var level_definitions = LevelManager.level_definitions

    for i in range(level_definitions.size()):
        var level_select_section = level_select_container_scene.instantiate()
        grid_container.add_child(level_select_section)
        level_select_section.set_level_index(i)

    back_btn.connect("pressed", _on_back_select_level_pressed)

func _on_back_select_level_pressed() -> void:
    emit_signal("back_select_level_pressed")