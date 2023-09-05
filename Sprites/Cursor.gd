#курсор исчезает при приближении к руке
extends Sprite2D

var player

@export var cursor_min_distance : float = 40.0
@export var cursor_max_distance : float = 200.0
var base_alpha : float = 1.0

func _ready():
	#hide mouse
	Input.set_mouse_mode(1)

func _process(delta):
	var target_pos = get_global_mouse_position()
	global_position = target_pos
	if player != null:
		var hand_pos = player.hand.global_position
		var alpha = clamp(((target_pos - hand_pos).length() - cursor_min_distance) / cursor_max_distance, 0.0, 1.0)
		modulate.a = alpha * base_alpha
	else:
		modulate.a = base_alpha
