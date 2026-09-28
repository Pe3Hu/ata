class_name TributeData
extends RefCounted


signal quotum_changed

var price: int
var volumes: Array[int]

var quotums: Array[QuotumData]

var current_quotum: QuotumData:
	set(value_):
		current_quotum = value_
		quotum_changed.emit()


func _init(price_: int, volumes_: Array) -> void:
	price = price_
	volumes.append_array(volumes_)
	
	init_quotums()

func init_quotums() -> void:
	for volume in volumes:
		if price % volume == 0:
			@warning_ignore("integer_division")
			var amount = price / volume
			
			for matter in Digest.volume_to_matters[volume]:
				var quotum = QuotumData.new(matter, volume, amount)
				quotums.append(quotum)
	
	current_quotum = quotums.front()

func changed_quotum(shift_: int) -> void:
	var index = quotums.find(current_quotum)
	var n = quotums.size()
	index = (index + shift_ + n) % n
	current_quotum = quotums[index]
