class_name MagistralData
extends RefCounted


var mainland: MainlandData
var wastelands: Array[WastelandData]


func _init(mainland_: MainlandData, wastelands_: Array) -> void:
	mainland = mainland_
	wastelands.append_array(wastelands_)
	
	mainland.magistrals.append(self)

func init_trods() -> void:
	for _i in wastelands.size():
		for _j in range(_i + 1, wastelands.size(), 1):
			var is_troded: bool = false
			
			for a in wastelands[_i].structures:
				for b in wastelands[_j].structures:
					var a_coord = a.get_global_coord()#wastelands[_i].internals.front() + a.coord
					var b_coord = b.get_global_coord()#wastelands[_j].internals.front() + b.coord
					var l = abs(a_coord.x - b_coord.x) + abs(a_coord.y - b_coord.y) 
					if l == 2:
						var _trod = TrodData.new(mainland, [a, b])
						is_troded = true
						break
				if is_troded: break
