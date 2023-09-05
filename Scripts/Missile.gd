#не доработано и не вошло в финальную игру
extends RigidBody2D

@export var active = false
@export var launch_speed : float = 100.0
@export var carry_speed : float = 60.0
@export var rotation_speed : float = 20.0
@export var explosion_time : float = 3.0

@onready var explosion_timer = $ExplosionTimer

@export var target : Node2D
var is_held = false

func _integrate_forces(state):
	var speed = launch_speed
	linear_velocity = Vector2.UP.rotated(rotation) * speed
	
	if target != null:
		var target_pos = to_local(target.body.global_position)
		var angle = get_angle_to(target_pos) + PI / 2.0
		angular_velocity = clamp(angle, -rotation_speed, rotation_speed)
		print(angular_velocity)
		
func interact(hand):
	if !active:
		active = true
	is_held = true
	target = null
	explosion_timer.start(explosion_time)

func release():
	is_held = false
	
func explode():
	queue_free()
	

func _on_explosion_timer_timeout():
	explode()


func _on_body_entered(body):
	explode()
