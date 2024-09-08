class_name Interactable extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2d
@onready var collision_shape_2d = $CollisionShape2D
@onready var sound_effect = $SoundEffect

enum INTERACTABLE_TYPE {SPEED, JUMP, END_OF_LEVEL_FLAG, SPRING, FAN, SPIKE}
enum DIRECTION {N, E, S, W, NE, SE, SW, NW}

@export var interactable_type = INTERACTABLE_TYPE.SPEED
@export var direction = DIRECTION.E
@export var strength = 500

func _ready():
	if direction == DIRECTION.W or direction == DIRECTION.NW or direction == DIRECTION.SW:
		animated_sprite_2d.flip_h = true
	
	area_entered.connect(play_sfx.unbind(1))

func play_sfx():
	var pitch = randf_range(0.95, 1.05)
	sound_effect.pitch_scale = pitch
	sound_effect.play()
