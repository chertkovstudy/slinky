extends RigidBody2D

@export var length : float = 40
@export var width : float = 20

func _ready():
	var collision_shape = $CollisionShape2D
	collision_shape.shape.height = length
	collision_shape.shape.radius = width / 2.0
	collision_shape.position = Vector2(0.0, length / 2.0)
	var pinjoint = $PinJoint2D
	pinjoint.position = Vector2(0.0, length)

#если рука схватилась за звено, то ее можно сонаправить
func align(hand):
	hand.rotation = rotation
	hand.rotation_lock = true
