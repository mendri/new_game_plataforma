extends CanvasLayer

@onready var level_select_screen = %LevelSelectScreen
@onready var main_menu_container = %MainMenuContainer

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)

	level_select_screen.connect("back_select_level_pressed", on_back_select_level_pressed)

func on_play_pressed():
	level_select_screen.visible = true
	main_menu_container.visible = false

func on_options_pressed():
	pass

func on_quit_pressed():
	get_tree().quit()

func on_back_select_level_pressed():
	main_menu_container.visible = true
	level_select_screen.visible = false