extends Interactable

@onready var confetti = $Confetti

func _ready():
	super()
	area_entered.connect(level_complete.unbind(1))

func level_complete():
	call_deferred("disable_collision")
	confetti.emitting = true

func disable_collision():
	collision_shape_2d.disabled = true
