extends Interactable

var repeat = true

func _ready():
	super()
	area_exited.connect(stop_playing.unbind(1))

func stop_playing():
	var tween = get_tree().create_tween()
	tween.tween_property(sound_effect, "volume_db", -60, 1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	sound_effect.playing = false
	sound_effect.volume_db = 0
