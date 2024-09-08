extends Control

@onready var back_button = %BackButton

func _ready():
	back_button.pressed.connect(back)
	back_button.grab_focus()

func back():
	get_tree().change_scene_to_file("res://UI/scenes/start_menu.tscn")
