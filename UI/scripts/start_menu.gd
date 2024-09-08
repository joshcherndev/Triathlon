extends Control

@onready var levels_button = %LevelsButton
@onready var quit_button = %QuitButton
@onready var credits_button = %CreditsButton


func _ready():
	levels_button.grab_focus()
	
	# pressed signal connections
	levels_button.pressed.connect(go_to_levels)
	credits_button.pressed.connect(go_to_credits)
	quit_button.pressed.connect(quit)
	levels_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	credits_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	quit_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)


func go_to_levels():
	levels_button.accept_event()
	get_tree().change_scene_to_file("res://UI/scenes/level_select_menu.tscn")

func go_to_credits():
	get_tree().change_scene_to_file("res://UI/scenes/credits_menu.tscn")

func quit():
	get_tree().quit()
