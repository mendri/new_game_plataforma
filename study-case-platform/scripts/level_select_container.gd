extends PanelContainer

@onready var level_name = %LevelName
@onready var select_level_btn = %SelectLevelBtn

var level_index: int

func _ready() -> void:
    select_level_btn.connect("pressed", _on_select_level_pressed)

func set_level_index(index: int) -> void:
    level_name.text = "Level " + str(index + 1)
    level_index = index

func _on_select_level_pressed() -> void:
    LevelManager.change_to_level(level_index)