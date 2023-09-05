extends Node2D

@onready var camera = $Camera
@onready var cursor = $Cursor
@onready var player = $Player

var start_time : int = 0
var personal_best : int = 10000000000000
var count_time = true

var player_scene = preload("res://Player/Player.tscn")

func _ready():
	count_time = true
	initialization()
	start_timer()
	cursor.base_alpha = 1.0

func _process(delta):
	if count_time:
		#print(Time.get_ticks_msec() - start_time)
		pass


func _on_finish_body_entered(body):
	if count_time:
		Global.run_time = Time.get_ticks_msec() - start_time
		count_time = false
		get_tree().change_scene_to_packed(load("res://Gameworks/EndScene.tscn"))
		if Global.run_time < Global.personal_best:
			Global.personal_best = Global.run_time

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("1") and Global.checkpoints:
		var old_player = player
		player = player_scene.instantiate()
		add_child(player)
		old_player.queue_free()
		initialization()
		player.transform.origin = $Checkpoints/Pit.global_position
		
	if event.is_action_pressed("2") and Global.checkpoints:
		var old_player = player
		player = player_scene.instantiate()
		add_child(player)
		old_player.queue_free()
		initialization()
		player.transform.origin = $Checkpoints/Ropes.global_position
	if event.is_action_pressed("3") and Global.checkpoints:
		var old_player = player
		player = player_scene.instantiate()
		add_child(player)
		old_player.queue_free()
		initialization()
		player.transform.origin = $Checkpoints/Belts.global_position
	if event.is_action_pressed("4") and Global.checkpoints:
		var old_player = player
		player = player_scene.instantiate()
		add_child(player)
		old_player.queue_free()
		initialization()
		player.transform.origin = $Checkpoints/Gym.global_position
	if event.is_action_pressed("5") and Global.checkpoints:
		var old_player = player
		player = player_scene.instantiate()
		add_child(player)
		old_player.queue_free()
		initialization()
		player.transform.origin = $Checkpoints/Chimney.global_position
	if event.is_action_pressed("back"):
		get_tree().change_scene_to_packed(load("res://Levels/MainMenu.tscn"))

func start_timer():
	start_time = Time.get_ticks_msec()
	
func initialization():
	if camera != null:
		camera.player = player
	if cursor != null:
		cursor.player = player
