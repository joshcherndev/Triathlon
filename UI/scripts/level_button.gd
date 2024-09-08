extends Button

@export var level : PackedScene

func _ready():
	pressed.connect(switch_to_level)

func switch_to_level():
	if not level is PackedScene:
		return
	await LevelTransition.hide_left()
	get_tree().change_scene_to_packed(level)
	LevelTransition.show_right()
