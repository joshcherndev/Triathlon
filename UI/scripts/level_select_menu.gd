extends Control

@onready var back_button = %BackButton

const SAVE_PATH = "user://level_stats.cfg"
const TEST_SAVE_PATH = "res://level_stats.cfg"
var save_path = SAVE_PATH

var save_file : ConfigFile = null

@onready var level_buttons = [
	%Level1Button,
	%Level2Button,
	%Level3Button,
	%Level4Button,
	%Level5Button,
	%Level6Button,
	%Level7Button,
	%Level8Button,
	%Level9Button,
	%Level10Button,
	%Level11Button,
	%Level12Button,
	%Level13Button,
	%Level14Button,
	%Level15Button,
]

@onready var level_labels = [
	%Level1Label,
	%Level2Label,
	%Level3Label,
	%Level4Label,
	%Level5Label,
	%Level6Label,
	%Level7Label,
	%Level8Label,
	%Level9Label,
	%Level10Label,
	%Level11Label,
	%Level12Label,
	%Level13Label,
	%Level14Label,
	%Level15Label,
]

var unlocked_level_buttons = []
var unlocked_level_labels = []

func _ready():
	load_level_stats()
	
	if save_file != null:
		for level in save_file.get_sections():
			if !save_file.get_value(level, "completed"):
				level_labels[int(level) - 1].visible = false
			else:
				# for the current level
				unlocked_level_buttons.append(level_buttons[int(level) - 1])
				unlocked_level_labels.append(level_labels[int(level) - 1])
				# for the next level (since we know the previous level was completed),
				# exclude last level to avoid out of bounds error
				if int(level) < level_buttons.size():
					unlocked_level_buttons.append(level_buttons[int(level)])
					unlocked_level_labels.append(level_labels[int(level)])
				level_labels[int(level) - 1].text = str(save_file.get_value(level, "best_time"))
	
	for _i in level_buttons.size():
		var button = level_buttons[_i - 1]
		if button in unlocked_level_buttons:
			var label = level_labels[_i - 1]
			button.focus_entered.connect(unhide_stats.bind(label))
			button.focus_exited.connect(hide_stats.bind(label))
			button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
		else:
			button.disabled = true
	
	level_buttons[0].disabled = false
	level_buttons[0].grab_focus()
	back_button.pressed.connect(back)
	back_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	
	# unlock first levels of triangle and circle
	# if 1st block level complete
	if save_file != null and save_file.get_value("1", "completed"):
		level_buttons[5].disabled = false
		level_buttons[10].disabled = false

func back():
	get_tree().change_scene_to_file("res://UI/scenes/start_menu.tscn")

func unhide_stats(label: Label):
	label.visible = true

func hide_stats(label: Label):
	label.visible = false

func load_level_stats():
	var config = ConfigFile.new()
	var error = config.load(save_path)
	if error != OK: return
	else: save_file = config
