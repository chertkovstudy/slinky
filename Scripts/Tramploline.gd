extends StaticBody2D

func _ready():
	$AnimationPlayer.play("bounce")

func _on_area_2d_body_entered(body):
	$AnimationPlayer.play("bounce")
