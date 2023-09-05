extends Node

var personal_best : int = INF
var run_time : int = INF

var fullscreen = false
var checkpoints = false
var show_timer = false

#переводит время в строку
func show_time(time : int):
	if time < 0:
		return "N/A"
	var ms = time % 1000
	var sec = time / 1000
	var s = sec % 60
	var m = s / 60
	return str(m) + ":" + str(s) + "." + str(ms)
