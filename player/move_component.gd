class_name MoveComponent extends Node2D

var gravity: float = 0.5
var jump_strength: float
var move_speed: float
var friction: float = 0

@onready var character : RigidBody2D = get_parent()
var input_direction : Vector2 = Vector2.ZERO

var frozen = false

var in_air = false
signal landed
signal jumped

func _ready():
	update_physics_props(gravity, friction)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		frozen = !frozen
		character.freeze = !character.freeze

func _physics_process(_delta):
	if !frozen:
		if Input.is_action_just_pressed("jump"):
			jump()
		
		if character.linear_velocity.y > 135.0 or character.linear_velocity.y < -135.0:
			in_air = true
		
		if (character.linear_velocity.y < 0.025 and character.linear_velocity.y > -0.025) and in_air:
			in_air = false
			emit_signal("landed")
		
		var velocity = input_direction * move_speed
		character.apply_central_force(velocity)

func jump():
	if character.linear_velocity.y < 0.025 and character.linear_velocity.y > -0.025:
		character.apply_central_impulse(Vector2(0.0, -jump_strength))
		emit_signal("jumped")

func update_physics_props(g: float, f: float):
	frozen = false
	character.gravity_scale = g
	var phys_res = character.get_physics_material_override()
	phys_res.friction = f
	character.set_physics_material_override(phys_res)

