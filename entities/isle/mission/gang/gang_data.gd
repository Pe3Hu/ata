class_name GangData
extends RefCounted


var mission: MissionData
var ambition: AmbitionData
var attempt: AttemptData

var ideas: Array[IdeaData]


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	attempt = AttemptData.new(self)
	ambition = AmbitionData.new(self)
	init_ideas()

func init_ideas() -> void:
	var indexs = 8
	var options = range(1, Catalog.OPPORTUNINITY_AMOUNT + 1)
	options.shuffle()
	
	for _i in indexs:
		var index = options.pop_back()
		var _idea = IdeaData.new(self, index)

func test() -> void:
	var n = 21
	
	for _i in range(1, n, 1):
		var a = load('res://entities/isle/mission/gang/idea/opportunity/%d.tres' % _i)
		
		for _j in range(_i + 1, n, 1):
			var b = load('res://entities/isle/mission/gang/idea/opportunity/%d.tres' % _j)
			var r = Helper.find_intersection(a.intentions, b.intentions)
			if r.size() != 1:
				pass
