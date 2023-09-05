class_name LeaderboardEntry

var id : String
var name : String
var score : float
var rank : int

func _init(id, name, score, rank = 10000):
	self.id = id
	self.name = name
	self.score = score
	self.rank = rank
