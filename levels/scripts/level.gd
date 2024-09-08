class_name Level extends Node2D

@export var next_level: PackedScene
@export var level_number: String

enum SHAPE {SQUARE, TRIANGLE, CIRCLE}

@export var player_shape = SHAPE.SQUARE

const SAVE_PATH = "user://level_stats.cfg"
const TEST_SAVE_PATH = "res://level_stats.cfg"
var save_path = SAVE_PATH
var save_file = null

var level_time = 0.0
var start_level_msec = 0.0
var paused_time = 0.0
var paused_time_diff = 0.0
var best_time = 0.0

@onready var player = $Player

@onready var start_time_background = %StartTimeBackground
@onready var start_time_label = %StartTimeLabel
@onready var end_of_level_menu = $CanvasLayer/EndOfLevelMenu
@onready var animation_player = $AnimationPlayer
@onready var time_label = %TimeLabel

@onready var end_time_label = %EndTimeLabel
@onready var best_time_label = %BestTimeLabel
@onready var replay_button = %ReplayButton
@onready var menu_button = %MenuButton
@onready var next_button = %NextButton
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var pause_replay_button = %PauseReplayButton
@onready var pause_menu_button = %PauseMenuButton

@onready var level_complete = false
@onready var paused = false

func _ready():
	# change player character to assigned shape for the level
	player.change_shape_stats(player_shape)
	
	Events.level_completed.connect(level_completed)
	
	# level complete screen
	replay_button.pressed.connect(replay_level)
	menu_button.pressed.connect(back_to_level_select)
	next_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	replay_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	menu_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	
	# pause screen
	pause_replay_button.pressed.connect(replay_level)
	pause_menu_button.pressed.connect(back_to_level_select)
	pause_replay_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	pause_menu_button.pressed.connect(MusicSfxPlayer.play_pressed_sound)
	
	# start timer screen
	get_tree().paused = true
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_level_msec = Time.get_ticks_msec()

func _process(_delta):
	if !level_complete:
		if Input.is_action_just_pressed("pause"):
			paused = !paused
			if paused:
				capture_time()
			paused_time_diff += Time.get_ticks_msec() - paused_time
			pause_menu.visible = !pause_menu.visible
			pause_replay_button.grab_focus()
			MusicSfxPlayer.lower_music_volume()
		
		if !paused:
			level_time = Time.get_ticks_msec() - start_level_msec - paused_time_diff
			
			# cut off last decimal from time
			var formatted_time = int((level_time / 1000.0) * 100)
			formatted_time = formatted_time / 100.0
			
			time_label.text = str(formatted_time)
			MusicSfxPlayer.raise_music_volume()

func capture_time():
	paused_time = Time.get_ticks_msec()

func level_completed():
	level_time = level_time / 1000.0
	
	# cut off last decimal from time
	var formatted_time = int(level_time * 100)
	formatted_time = formatted_time / 100.0
	level_time = formatted_time
	
	load_level_stats()
	if best_time == 0.0 or best_time > level_time:
		best_time = level_time
		save_level_stats()
	
	level_complete = true
	end_time_label.text = "Time: " + str(level_time)
	best_time_label.text = "PB: " + str(best_time)
	
	end_of_level_menu.show()
	
	if next_level is PackedScene:
		next_button.pressed.connect(change_level)
		next_button.grab_focus()
	else:
		next_button.visible = false
		menu_button.grab_focus()

func change_level():
	MusicSfxPlayer.raise_music_volume()
	await LevelTransition.hide_left()
	get_tree().change_scene_to_packed(next_level)
	await LevelTransition.show_right()

func replay_level():
	MusicSfxPlayer.raise_music_volume()
	await LevelTransition.hide_left()
	get_tree().reload_current_scene()
	await LevelTransition.show_right()

func back_to_level_select():
	MusicSfxPlayer.raise_music_volume()
	await LevelTransition.hide_down()
	get_tree().change_scene_to_file("res://UI/scenes/level_select_menu.tscn")
	LevelTransition.show_down()

func save_level_stats():
	save_file.set_value(level_number, "best_time", level_time)
	save_file.set_value(level_number, "completed", true)
	save_file.save(save_path)

func load_level_stats():
	var config = ConfigFile.new()
	config.load(save_path)
	save_file = config
	var saved_best_time = config.get_value(level_number, "best_time")
	if saved_best_time == null: return 
	best_time = saved_best_time
