extends Node

@onready var pressed = $Pressed
@onready var music = $Music

func _ready():
	music.finished.connect(music.play)
	Events.level_completed.connect(lower_music_volume)

func play_pressed_sound():
	pressed.play()

func lower_music_volume():
	music.volume_db = -15

func raise_music_volume():
	music.volume_db = 0
