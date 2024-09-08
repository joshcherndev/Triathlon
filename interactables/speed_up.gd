extends Interactable

func _ready():
	super()
	if direction == DIRECTION.SE or direction == DIRECTION.SW:
		animated_sprite_2d.flip_v = true
	
	if direction == DIRECTION.SE or direction == DIRECTION.SW or direction == DIRECTION.NW or direction == DIRECTION.NE:
		animated_sprite_2d.play("tilted_default")
	else:
		animated_sprite_2d.play("horizontal_default")
	
	area_entered.connect(speed_boost_anim.unbind(1))
	

func speed_boost_anim():
	if direction == DIRECTION.SE or direction == DIRECTION.SW or direction == DIRECTION.NW or direction == DIRECTION.NE:
		animated_sprite_2d.play("tilted_activated")
		collision_shape_2d.set_deferred("disabled", !collision_shape_2d.disabled)
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("tilted_default")
	else:
		animated_sprite_2d.play("horizontal_activated")
		collision_shape_2d.set_deferred("disabled", !collision_shape_2d.disabled)
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("horizontal_default")
	
	
	animated_sprite_2d.visible = false
	await get_tree().create_timer(1.0).timeout
	collision_shape_2d.set_deferred("disabled", !collision_shape_2d.disabled)
	animated_sprite_2d.visible = true

