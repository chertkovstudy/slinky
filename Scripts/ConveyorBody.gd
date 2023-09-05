#тело конвейера
#здесь обрабатываются коллизии
extends StaticBody2D

var driver = preload("res://Objects/BeltDriver.tscn")
var driver_instance : Object = null
var speed : float = 200
var incline : Vector2

var end_a
var end_b
var r

func _initialize(_incline, _speed, _end_a, _end_b, _r):
	speed = _speed
	incline = _incline
	end_a = _end_a
	end_b = _end_b
	r = 2.0 * _r
	constant_linear_velocity = speed * Vector2.RIGHT
	#print("linear_velocity " + str(constant_linear_velocity))

func _process(delta):
	if driver_instance != null:
		var dist
		if speed > 0:
			dist = (driver_instance.global_position - end_b - global_position).length()
		if speed < 0:
			dist = (driver_instance.global_position - end_a - global_position).length()
		print(dist)
		if dist < r:
			driver_instance.destroy_driver()

func interact(hand):
	print("attach driver")
	driver_instance = driver.instantiate()
	driver_instance._initialize(speed, incline, hand)
	add_child(driver_instance)
	driver_instance.global_position = hand.global_position
	hand.held_object = driver_instance
	hand.hold_joint.node_b = driver_instance.get_path()

func release(hand):
	if driver_instance != null:
		driver_instance.destroy_driver()
		driver_instance = null

func _on_boundary_body_exited(body):
	if body.has_method("destroy_driver"):
		print("driver exited")
		driver_instance.destroy_driver()
		driver_instance = null

func align(hand):
	hand.rotation = Vector2.UP.angle_to(incline)
	hand.rotation_lock = true
