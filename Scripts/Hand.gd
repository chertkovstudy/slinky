#в основном то же, что было у тебя.
#я добавил damp, с ним тело пружинит сильно меньше, но отталкивается с меньшей силой и тормозит, если
#схватить что-нибудь в воздухе. не думаю, что этот параметр стоит использовать.
#и rotation lock - я посчитал, что при захвате некоторых тел, рука должна не крутиться вокруг точки,
#как это происходит обычно, а фиксироваться на объекте. в игре это можно увидеть на веревках и конвейерах.
extends RigidBody2D

var body
#var raycast
@onready var grab_filter = $GrabFilter
@onready var hold_joint = $PinJoint
@onready var sprite = $Sprite

var body_to_mouse : Vector2
var body_to_hand : Vector2
var hand_to_mouse : Vector2
var hand_speed : float = 20.0

@export var max_arm_length : float = 300.0
@export var force_multiplier : float = 5.0
@export var horizontal_force_multiplier : float = 1.5
@export var vertical_force_multiplier : float = 2.0
@export var body_acceleration : float = 30.0

var is_colliding = false
var is_holding_object = false
var held_object : PhysicsBody2D
var rotation_lock = false

var open_texture = preload("res://Sprites/hand_open.png")
var closed_texture = preload("res://Sprites/hand_closed.png")

func _ready():
	pass

func _process(delta):
	calculate_distances()
	if held_object == null:
		rotation_lock = false
	if is_holding_object and held_object == null:
		is_holding_object = false
		release()
	if !is_holding_object:
		rotation_lock = false
		pass
	pass

func calculate_distances():
	var body_pos = body.global_position
	var hand_pos = global_position
	var mouse_pos = get_global_mouse_position()
	body_to_mouse = mouse_pos - body_pos
	body_to_mouse = clamp(body_to_mouse.length(), 0, max_arm_length) * body_to_mouse.normalized()
	body_to_hand = hand_pos - body_pos
	hand_to_mouse = body_to_mouse - body_to_hand

func _physics_process(delta):
	is_colliding = get_colliding_bodies().size() > 0
	if !is_holding_object:
		#apply_central_impulse(hand_to_mouse.normalized() * hand_speed * delta)
		pass
	if is_colliding or is_holding_object:
		apply_forces(delta)

func apply_forces(delta):
	var normalized_direction = -hand_to_mouse.normalized()
	var linear_force = normalized_direction * force_multiplier * clamp(hand_to_mouse.length(), 0, max_arm_length)
	var vertical_force = linear_force.y * vertical_force_multiplier
	var horizontal_force = linear_force.x * horizontal_force_multiplier
	var force = Vector2(horizontal_force, vertical_force)
	
	body.apply_central_force(force)
	
	if is_holding_object and held_object != null:
		if held_object.has_method("apply_central_force"):
			if !held_object.has_method("destroy_driver"):
				held_object.apply_central_force(-force)
			body.apply_central_force(body.mass / (body.mass * held_object.mass) * body_acceleration * normalized_direction)
		else:
			body.apply_central_force(body_acceleration * normalized_direction)
	
func _input(event):
	if event.is_action_pressed("grab"):
		sprite.texture = closed_texture
		var contacts = grab_filter.get_overlapping_bodies()
		contacts.erase(self)
		contacts.erase(body)
		if contacts.size() > 0:
			held_object = contacts[0]
			hold_joint.node_b = held_object.get_path()
			is_holding_object = true

			body.linear_damp = 1
			if held_object.has_method("interact"):
				held_object.interact(self)
			if held_object.has_method("align"):
				#print("align")
				held_object.align(self)
			return
	if event.is_action_released("grab"):
		release()

func release():
	rotation_lock = false
	sprite.texture = open_texture
	body.gravity_scale = 1
	body.linear_damp = 0
	if is_holding_object && held_object != null:
		if held_object.has_method("release"):
			held_object.release(self)
			print("release")
		is_holding_object = false
		held_object = null
		if hold_joint != null:
			hold_joint.node_b = ''

func _integrate_forces(state):
	state.linear_velocity = hand_to_mouse * hand_speed
	if !rotation_lock:
		state.angular_velocity = rad_to_deg(get_angle_to(get_global_mouse_position()))
	elif held_object != null:
		state.angular_velocity = 0
		rotation = held_object.rotation
