extends Interactable

func _ready():
	super()
	area_entered.connect(entered.unbind(1))

func entered():
	animated_sprite_2d.play("spring")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("default")
