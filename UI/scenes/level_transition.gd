extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func hide_down():
	animation_player.play("hide_down")
	await animation_player.animation_finished

func show_down():
	animation_player.play("show_down")
	await animation_player.animation_finished

func hide_left():
	animation_player.play("hide_left")
	await animation_player.animation_finished

func show_right():
	animation_player.play("show_right")
	await animation_player.animation_finished
