extends Control

func _ready():
	$FSCheckButton.button_pressed = Global.fullscreen
	$TimerCheckButton.button_pressed = Global.show_timer
	$CheckpointsCheckButton.button_pressed = Global.checkpoints

func _on_checkpoints_check_button_toggled(button_pressed):
	Global.checkpoints = !Global.checkpoints

func _on_fs_check_button_toggled(button_pressed):
	Global.fullscreen = button_pressed
	if Global.fullscreen:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)

func _on_timer_check_button_toggled(button_pressed):
	Global.show_timer = !Global.show_timer

