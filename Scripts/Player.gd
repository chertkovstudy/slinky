extends Node2D

@onready var body = $Body
@onready var hand = $Hand
@onready var spring = $Line2D

func _ready():
	hand.body = body

func _process(delta):
	var hand_pos = hand.global_position
	var body_pos = body.global_position
	spring.set_point_position(0, to_local(body_pos))
	spring.set_point_position(1, to_local(hand_pos))
