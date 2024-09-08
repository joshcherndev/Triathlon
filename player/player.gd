extends RigidBody2D

@onready var move_component = $MoveComponent
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var square_collision_shape = $SquareCollisionShape
@onready var triangle_collision_shape = $TriangleCollisionShape
@onready var circle_collision_shape = $CircleCollisionShape

@onready var square_particles = $Particles/SquareParticles
@onready var feather_particles = $Particles/FeatherParticles
@onready var circle_particles = $Particles/CircleParticles

@onready var square_landed_sfx = $SFX/SquareLandedSFX
@onready var triangle_jump_sfx = $SFX/TriangleJumpSFX
@onready var circle_speed_sfx = $SFX/CircleSpeedSFX

@onready var shape_stats = {
	0 : {
		"MASS" : 6,
		"GRAVITY" : 0.4,
		"JUMP_STRENGTH" : 650,
		"MOVE_SPEED" : 700,
		"FRICTION" : 0.2,
		"ANIMATION" : "square",
		"COLLISION_SHAPE" : $SquareCollisionShape,
	},
	1 : {
		"MASS" : 2,
		"GRAVITY" : 0.1,
		"JUMP_STRENGTH" : 150,
		"MOVE_SPEED" : 150,
		"FRICTION" : 0.15,
		"ANIMATION" : "triangle",
		"COLLISION_SHAPE" : $TriangleCollisionShape,
	},
	2 : {
		"MASS" : 4,
		"GRAVITY" : 0.2,
		"JUMP_STRENGTH" : 300,
		"MOVE_SPEED" : 800,
		"FRICTION" : 1,
		"ANIMATION" : "circle",
		"COLLISION_SHAPE" : $CircleCollisionShape,
	},
}

@onready var starting_position = global_position
@onready var cur_collision_shape = square_collision_shape
@onready var input_direction : Vector2 = Vector2.ZERO

@onready var playing_circle = false

var tween : Tween
signal fade

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	input_direction = Vector2(Input.get_axis("left", "right"), 0)
	move_component.input_direction = input_direction

func _physics_process(_delta):
	if playing_circle:
		if linear_velocity.length() > 150.0:
			if !circle_speed_sfx.playing:
				circle_speed_sfx.volume_db = 0
				circle_speed_sfx.play()
			circle_particles.emitting = true
		else:
			circle_particles.emitting = false
			if circle_speed_sfx.volume_db == -15:
				circle_speed_sfx.playing = false
			if circle_speed_sfx.playing:
				circle_speed_sfx.volume_db -= 1

func change_shape_stats(shape: int):
	match shape:
		0:
			# square stats
			square_collision_shape.disabled = false
			triangle_collision_shape.disabled = true
			circle_collision_shape.disabled = true
			
			animated_sprite_2d.play("square")
			mass = shape_stats.get(0).get("MASS")
			move_component.gravity = shape_stats.get(0).get("GRAVITY")
			move_component.jump_strength = shape_stats.get(0).get("JUMP_STRENGTH")
			move_component.move_speed = shape_stats.get(0).get("MOVE_SPEED")
			move_component.friction = shape_stats.get(0).get("FRICTION")
			move_component.update_physics_props(move_component.gravity, move_component.friction)
			
			move_component.landed.connect(play_square_particles)
		1:
			# triangle stats
			square_collision_shape.disabled = true
			triangle_collision_shape.disabled = false
			circle_collision_shape.disabled = true
			
			animated_sprite_2d.play("triangle")
			mass = shape_stats.get(1).get("MASS")
			move_component.gravity = shape_stats.get(1).get("GRAVITY")
			move_component.jump_strength = shape_stats.get(1).get("JUMP_STRENGTH")
			move_component.move_speed = shape_stats.get(1).get("MOVE_SPEED")
			move_component.friction = shape_stats.get(1).get("FRICTION")
			move_component.update_physics_props(move_component.gravity, move_component.friction)
			
			move_component.jumped.connect(play_triangle_particles)
		2:
			# circle stats
			square_collision_shape.disabled = true
			triangle_collision_shape.disabled = true
			circle_collision_shape.disabled = false
			
			animated_sprite_2d.play("circle")
			mass = shape_stats.get(2).get("MASS")
			move_component.gravity = shape_stats.get(2).get("GRAVITY")
			move_component.jump_strength = shape_stats.get(2).get("JUMP_STRENGTH")
			move_component.move_speed = shape_stats.get(2).get("MOVE_SPEED")
			move_component.friction = shape_stats.get(2).get("FRICTION")
			move_component.update_physics_props(move_component.gravity, move_component.friction)
			
			playing_circle = true
			fade.connect(fade_out_sound)

func play_square_particles():
	var pitch = randf_range(0.95, 1.05)
	square_landed_sfx.pitch_scale = pitch
	square_landed_sfx.play()
	square_particles.emitting = true

func play_triangle_particles():
	var pitch = randf_range(0.99, 1.01)
	triangle_jump_sfx.pitch_scale = pitch
	triangle_jump_sfx.play()
	feather_particles.restart()

func fade_out_sound():
	print("running")
	await get_tree().create_timer(0.25).timeout
	tween = get_tree().create_tween()
	tween.tween_property(circle_speed_sfx, "volume_db", -60, 0.5).set_trans(Tween.TRANS_CUBIC)
	
