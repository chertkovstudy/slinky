extends Control

var options = preload("res://Gameworks/UI/Options.tscn")
var leaderboard = preload("res://Gameworks/Leaderboards/Leaderboard.tscn")

var showing_options = false
var showing_leaderboards = false
var options_instance
var leaderboard_instance

func _on_options_button_button_down():
	if leaderboard_instance != null:
		hide_leaderboard()
		
	options_instance = options.instantiate()
	add_child(options_instance)
	show_options()

func hide_leaderboard():
	leaderboard_instance.queue_free()
	
func hide_options():
	options_instance.queue_free()

func show_options():
	pass

func show_leaderboard():
	pass

func _on_leaderboard_button_button_down():
	if options_instance != null:
		hide_options()
	leaderboard_instance = leaderboard.instantiate()
	add_child(leaderboard_instance)
	show_leaderboard()

func _on_start_button_button_down():
	get_tree().change_scene_to_packed(load("res://Levels/MainLevel.tscn"))
