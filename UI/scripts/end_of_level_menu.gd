extends Control

@onready var replay_button = %ReplayButton
@onready var menu_button = %MenuButton
@onready var next_button = %NextButton

func _ready():
	menu_button.grab_focus()
