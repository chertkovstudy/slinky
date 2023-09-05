#камера отдаляется на большой скорости, сдвигается относительно руки
#(чтобы дать достаточно места для длижения мышкой на экране)
#и перемещается так, чтобы игрок был примерно на 1/3 экрана
extends Camera2D

var player
var RESOLUTION = Vector2(1280, 720)

@export var smooth_lean : float = 8.0
@export var scale_lean : float = 0.8
@export var max_offset : float = 100.0

@export var zoom_threshhold : float = 0.3
@export var min_zoom : float = 0.2
@export var max_zoom : float = 0.4
@export var smooth_zoom : float = 0.8

@export var smooth_stop : float = 0.8
@export var smooth_move : float = 0.9

@export var player_speed_threshold : float = 1500.0
@export var max_distance : float = 300.0

enum mode {ACTIVE, CUTSCENE}

@export var camera_mode = mode.ACTIVE

func _physics_process(delta):
	match(camera_mode):
		mode.CUTSCENE:
			pass
		mode.ACTIVE:
			if player == null:
				return
			var player_motion = player.body.linear_velocity
			var player_position = player.body.global_position
			
			#lean
			var aim = get_global_mouse_position()
			var direction_to_aim = self.to_local(aim).normalized()
			var distance_to_aim = global_position.distance_to(aim)
			var lean = direction_to_aim * distance_to_aim 
			lean = clamp(lean.length(), 0.0, max_offset) * lean.normalized()
			var offset_blend = 1 - pow(0.5, delta * smooth_lean)
			offset = lerp(offset, lean, offset_blend)
			
			#zoom
#			var zoom_ratio = distance_to_aim / (zoom_threshhold * RESOLUTION.y)
#			zoom_ratio = clamp(zoom_ratio, min_zoom, max_zoom)
#			var zoom_blend = 1 - pow(0.5, delta * smooth_zoom)
			#zoom = lerp(zoom, Vector2(zoom_ratio, zoom_ratio), zoom_blend)

			var speed_ratio = player_motion.length() / player_speed_threshold
			speed_ratio = clamp(speed_ratio, 0.0, 1.0)
			var zoom_ratio = lerp(max_zoom, min_zoom, speed_ratio)
			var zoom_blend = 1 - pow(0.5, delta * smooth_zoom)
			zoom = lerp(zoom, Vector2(zoom_ratio, zoom_ratio), zoom_blend)
			
			var target = player_position + player_motion.normalized() * speed_ratio * (1.0/6.0) * RESOLUTION
			var position_blend
			if player_motion == Vector2.ZERO:
				position_blend = 1 - pow(0.5, delta * smooth_stop)
				position_blend = 0.03
			else:
				position_blend = 1 - pow(0.5, delta * smooth_move)
				position_blend = 0.06
			global_position = lerp(global_position, target, position_blend)
			if (player_position - global_position).length() > max_distance:
				var vector = player_position - global_position
				vector = clamp(vector.length(), 0, max_distance) * vector.normalized()
				global_position = player_position - vector
