#используется в главном меню
extends Node2D

@onready var body = $Body
@onready var spring = $Spring
@onready var hand = $Hand

@export var max_arm_length = 250
@export var smooth_move : float = 6

func _ready():
	spring.add_point(Vector2.ZERO)
	spring.add_point(Vector2.ZERO)
	spring.set_point_position(0, body.position)

func _process(delta):
	var target = get_global_mouse_position()
	var body_to_mouse = target - body.global_position
	var arm_vector = clamp(body_to_mouse.length(), 0.0, max_arm_length) * body_to_mouse.normalized()
	var blend = 1 - pow(0.5, delta * smooth_move)
	hand.global_position = lerp(hand.global_position, body.global_position + arm_vector, blend)
	hand.look_at(target)
	spring.set_point_position(1, hand.position)
