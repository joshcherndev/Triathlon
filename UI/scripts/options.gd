extends Control

@onready var back_button = %BackButton
@onready var max_slider = %MaxSlider


func _ready():
	max_slider.grab_focus()
	back_button.pressed.connect(back)

func back():
	get_tree().change_scene_to_file("res://UI/scenes/start_menu.tscn")
