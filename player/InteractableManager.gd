extends Area2D

@onready var move_component = %MoveComponent
@onready var animated_sprite_2d = %AnimatedSprite2D

@onready var direction_vectors = {
	Interactable.DIRECTION.N: Vector2.UP,
	Interactable.DIRECTION.E: Vector2.RIGHT,
	Interactable.DIRECTION.S: Vector2.DOWN,
	Interactable.DIRECTION.W: Vector2.LEFT,
	Interactable.DIRECTION.NE: Vector2(1,-1).normalized(),
	Interactable.DIRECTION.SE: Vector2(1,1).normalized(),
	Interactable.DIRECTION.SW: Vector2(-1,1).normalized(),
	Interactable.DIRECTION.NW: Vector2(-1,-1).normalized(),
}

@onready var character = get_parent()

var push_continuously_velocity = Vector2.ZERO
var push_continuously = false

var level_complete = false

func _ready():
	area_entered.connect(on_area_enter)
	area_exited.connect(disable_push_continuously.unbind(1))

func _physics_process(_delta):
	if push_continuously:
		character.apply_central_impulse(push_continuously_velocity)

func on_area_enter(interactable: Area2D):
	if interactable is Interactable:
		var velocity = direction_vectors.get(interactable.direction)
		match interactable.interactable_type:
			Interactable.INTERACTABLE_TYPE.SPEED:
				if interactable.direction == Interactable.DIRECTION.NW or interactable.direction == Interactable.DIRECTION.W or interactable.direction == Interactable.DIRECTION.SW:
					velocity.x = -interactable.strength
				else:
					velocity.x = interactable.strength
				
				if interactable.direction == Interactable.DIRECTION.SW or interactable.direction == Interactable.DIRECTION.S or interactable.direction == Interactable.DIRECTION.SE:
					velocity.y = interactable.strength
				elif interactable.direction == Interactable.DIRECTION.NW or interactable.direction == Interactable.DIRECTION.NE:
					velocity.y = -interactable.strength
			
			Interactable.INTERACTABLE_TYPE.JUMP:
				velocity.x *= interactable.strength
				velocity.y *= interactable.strength
			Interactable.INTERACTABLE_TYPE.END_OF_LEVEL_FLAG:
				move_component.frozen = true
				level_complete = true
				Events.level_completed.emit()
			Interactable.INTERACTABLE_TYPE.SPRING:
				if animated_sprite_2d.animation == "square":
					velocity.y *= character.linear_velocity.y * 11
				else:
					velocity.y *= character.linear_velocity.y * 3
			Interactable.INTERACTABLE_TYPE.FAN:
				push_continuously = true
				if interactable.direction == interactable.DIRECTION.N or interactable.direction == interactable.DIRECTION.S:
					push_continuously_velocity = Vector2(0, velocity.y * interactable.strength)
				else:
					push_continuously_velocity = Vector2(velocity.x * interactable.strength, 0)
			Interactable.INTERACTABLE_TYPE.SPIKE:
				if !level_complete:
					call_deferred("reset_player_pos")
				else:
					velocity.x *= interactable.strength
					velocity.y *= interactable.strength
		
		character.apply_central_impulse(velocity)

func disable_push_continuously():
	push_continuously = false

func reset_player_pos():
	character.freeze = true
	character.global_position = character.starting_position
	character.freeze = false
