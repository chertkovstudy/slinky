#цепь изначально содержит только якорь
#все звенья создаются процедурно на старте сцены
extends Node2D

@onready var line = $Line2D

@export var link_length : float = 40.0
@export var link_width : float = 20
@export var link_num : int = 10

var links = []
var link = preload("res://Objects/Chain/Link.tscn")

func _ready():
	var parent = $Anchor
	var parent_pos = parent.position - Vector2(0.0, 20.0)
	for i in link_num:
		parent = add_link(parent, i, parent_pos + Vector2(0.0, link_length))
		links.append(parent)
		line.add_point(parent.position)
		parent_pos = parent.position
	line.add_point(parent.position + Vector2(0.0, link_length))
	#print(line.points)
	line.width = link_width

func _process(delta):
	for i in link_num:
		line.set_point_position(i, links[i].position)
	line.set_point_position(link_num, links[link_num - 1].get_node("PinJoint2D").global_position - global_position)

func add_link(parent, id, pos):
	var joint = parent.get_node("PinJoint2D")
	var link_instance = link.instantiate()
	link_instance.length = link_length
	link_instance.width = link_width
	link_instance.position = pos
	add_child(link_instance)
	link_instance.set_name("link" + str(id))
	joint.node_b = link_instance.get_path()
	return link_instance
