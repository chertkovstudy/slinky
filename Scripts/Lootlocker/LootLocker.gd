extends HTTPRequest

class_name LootLocker

var token
var playerID : String
var game_api = "dev_b49a92dd4e4841f78b0df522ada2e7ef"
var boardID = "Slinky"

func authenticate_guest_session(id):
	playerID = id
	var url = "https://api.lootlocker.io/game/v2/session/guest"
	var header = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var request_body = {
		"game_key" : game_api, 
		"game_version" : "0.0.0", 
		"player_identifier" : playerID, 
		"development_mode" : "true"
	}
	#var jsonResponse : JSON
	#print(JSON.stringify(request_body))
	request(url, header, method, JSON.stringify(request_body))
	#yield(self, "request_completed")[3]
	var response = (await self.request_completed)[3]
	
	response = JSON.parse_string(response.get_string_from_utf8())
	#print(str(response))
	print("login successful")
	if "session_token" in response:
		token = response["session_token"]
		#print(response)
		
func submit_highscore(highscore, player_name):
	var url = "https://api.lootlocker.io/game/leaderboards/%s/submit" % boardID
	var header = ["Content-Type: application/json", "x-session-token: %s" % token]
	var method = HTTPClient.METHOD_POST
	var request_body = {
		"score" : str(highscore),
		"member_id" : playerID,
		"metadata" : player_name
	}
	#print(request_body)
	request(url, header, method, JSON.stringify(request_body))
	await self.request_completed

func get_leaderboard(number):
	var url = "https://api.lootlocker.io/game/leaderboards/%s/list?count=%s" % [boardID, str(number)]
	var header = ["Content-Type: application/json", "x-session-token: %s" % token]
	var method = HTTPClient.METHOD_GET
	
	request(url, header, method)
	var response = (await self.request_completed)[3]
	
	response = JSON.parse_string(response.get_string_from_utf8())
	#print(response)
	if "items" in response:
		var board = response["items"]
		var entry_list = []
		number = min(number, board.size())
		for i in number:
			var entry = board[i]
			entry_list.append(LeaderboardEntry.new(entry['member_id'], entry['metadata'], entry['score'], i + 1))
			#entry_list[i['member_id']] = i['score']
			#'metadata'
		return entry_list
	else:
		return null
		pass
func get_player_info(id):
	var url = "https://api.lootlocker.io/game/leaderboards/%s/member/%s" %[boardID, playerID]
	var header = ["Content-Type: application/json", "x-session-token: %s" % token]
	var method = HTTPClient.METHOD_GET
	
	request(url, header, method)
	var response = (await self.request_completed)[3]
	
	response = JSON.parse_string(response.get_string_from_utf8())
	var rank = int(response["rank"])
	var score = response["score"]
	var player_name = response["metadata"]
	return LeaderboardEntry.new(id, player_name, score, rank)
	
