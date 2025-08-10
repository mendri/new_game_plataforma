extends Node

@export var level_definitions: Array[LevelDefinitionResource]

var current_level_index: int = 0

func change_to_level(level_index: int) -> void:
    if (level_index >= level_definitions.size() || level_index < 0):
        return

    var level_definition = level_definitions[level_index]

    get_tree().change_scene_to_file(level_definition.level_scene_path)