extends Node

func _ready():
	await $LootLocker.authenticate_guest_session(OS.get_unique_id())
	#await $LootLocker.submit_highscore(1500, "rukoblood")
	#await $LootLocker.submit_highscore(500, "rukoblood3")
	var list = await $LootLocker.get_leaderboard(10)
	for entry in list:
		print(entry.name + ": " + str(entry.score))
	#print(await $LootLocker.get_player_info($LootLocker.playerID))
