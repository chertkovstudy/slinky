#этот объект только рисует тело конвейера
#за весь мусор в конвейере - извиняюсь, делал его в самом конце
extends Line2D

@export var speed : float = 200.0

var attached_hand = null
var incline

@onready var belt = $StaticBody
@onready var end_l = $EndL
@onready var end_r = $EndR

var end_a
var end_b
var line_scale

func _ready():
	end_a = get_point_position(0)
	end_b = get_point_position(1)
	
	incline = (end_b - end_a).normalized()
	belt.incline = incline
	#нормаль
	var ortho = Vector2(-incline.y, incline.x)
	#определяю границы хитбокса
	var point_a = end_a - ortho * width / 2 - incline * texture.region.size.x
	var point_b = end_a + ortho * width / 2 - incline * texture.region.size.x
	var point_c = end_b - ortho * width / 2
	var point_d = end_b + ortho * width / 2
	var polygon = PackedVector2Array([point_a, point_b, point_d, point_c])
	$StaticBody/CollisionShape2D.polygon = polygon
	
	belt._initialize(incline, speed, end_a, end_b, texture.region.size.x)
	line_scale = width / end_l.texture.get_height()
	end_l.scale = Vector2(line_scale, line_scale)
	end_l.position = end_a
	end_l.rotation = (Vector2.RIGHT.angle_to(incline))
	end_l.visible = true
	end_r.scale = Vector2(line_scale, line_scale)
	end_r.position = end_b
	end_r.rotation = (Vector2.RIGHT.angle_to(incline))
	end_r.visible = true
	if speed > 0:
		end_a -= incline * texture.region.size.x * line_scale
	if speed < 0:
		pass

func _process(delta):

	set_point_position(0, get_point_position(0) + speed * delta * incline) 
	if speed > 0 and (get_point_position(0) - end_a).length() > texture.region.size.x * line_scale:
		set_point_position(0, get_point_position(0) - incline * texture.region.size.x * line_scale)
	if speed < 0 and (get_point_position(0) - end_a).length() > texture.region.size.x * line_scale:
		set_point_position(0, get_point_position(0) + incline * texture.region.size.x * line_scale)
