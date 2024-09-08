extends Node2D

enum DIRECTION {N, E, S, W}
@export var direction = DIRECTION.N

@onready var switch = $Switch
@onready var switch_sprite = $Switch/SwitchSprite
@onready var switch_sfx = $SwitchSFX
@onready var door = $Door
@onready var door_sprite = $Door/DoorSprite
@onready var door_sfx = $DoorSFX

func _ready():
	switch.area_entered.connect(open_door.unbind(1))

func open_door():
	var tween = get_tree().create_tween()
	switch_sfx.play()
	tween.tween_property(switch, "position", Vector2(switch.position.x, switch.position.y + 8), 1).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().create_timer(0.5)
	door_sfx.play()
	
	# door opens based on direction specified
	if direction == DIRECTION.N:
		tween.tween_property(door, "position", Vector2(door.position.x, door.position.y - 8), 1).set_trans(Tween.TRANS_CUBIC)
	elif direction == DIRECTION.S:
		tween.tween_property(door, "position", Vector2(door.position.x, door.position.y + 8), 1).set_trans(Tween.TRANS_CUBIC)
	elif direction == DIRECTION.W:
		tween.tween_property(door, "position", Vector2(door.position.x - 8, door.position.y), 1).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(door, "position", Vector2(door.position.x + 8, door.position.y), 1).set_trans(Tween.TRANS_CUBIC)
	
	call_deferred("disable")

func disable():
	door.process_mode = Node.PROCESS_MODE_DISABLED
	switch.process_mode = Node.PROCESS_MODE_DISABLED
