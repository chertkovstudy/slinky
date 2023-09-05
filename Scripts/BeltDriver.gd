#когда рука хватается за конвейер, создается этот объект, и рука перецепляется на него
#известен баг, когда он начинает отходить от конвейера
#вероятно, я где-то неправильно рассчитал угол
extends RigidBody2D

var speed : float
var direction : Vector2
var end

func _physics_process(delta):
	rotation = Vector2.UP.angle_to(direction)
	pass

func _initialize(_speed, _incline, _hand):
	speed = _speed
	direction = _incline
	global_position = _hand.global_position

func destroy_driver():
	queue_free()
	
func _integrate_forces(state):
	state.linear_velocity = speed * direction

func release(hand):
	destroy_driver()
	
func align(hand):
	hand.rotation = Vector2.UP.angle_to(direction)
	hand.rotation_lock = true
