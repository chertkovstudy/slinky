extends Control

func _ready():
	await $LootLocker.authenticate_guest_session(OS.get_unique_id())
	var list = await $LootLocker.get_leaderboard(10)
	for entry in list:
		print(str(entry.rank) + " " + entry.name + ": " + str(entry.score))


func _process(delta):
	pass
