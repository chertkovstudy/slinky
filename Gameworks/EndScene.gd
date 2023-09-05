extends Node2D

func _ready():
	$Control/TimeLabel.text = "Your time is " + Global.show_time(Global.run_time)
	$Control/PBLabel.text = "Your personal best is " + Global.show_time(Global.personal_best)

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("back"):
		get_tree().change_scene_to_packed(load("res://Levels/MainMenu.tscn"))
