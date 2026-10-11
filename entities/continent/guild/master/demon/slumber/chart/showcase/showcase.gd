class_name Showcase
extends PanelContainer


@export var tune: Bozo.Tune = Bozo.Tune.NONE


func update_razors(razor_datas_: Array) -> void:
	var matters = []
	var sum_value = 0
	var suffix = Digest.tune_to_suffix[tune]
	
	for _i in razor_datas_.size():
		var razor = %Razors.get_child(_i)
		razor.data = razor_datas_[_i]
		sum_value += razor.data.volume
		
		if matters.is_empty():
			matters.append_array(razor.data.matters)
	
	%SumRein.data = ReinData.new(sum_value, matters, Bozo.Element.NONE, suffix)
