class_name Showcase
extends PanelContainer


func update_razors(razor_datas_: Array) -> void:
	var matters = []
	var sum_value = 0
	
	for _i in razor_datas_.size():
		var razor = %Razors.get_child(_i)
		razor.data = razor_datas_[_i]
		sum_value += razor.data.volume
		
		if matters.is_empty():
			matters.append_array(razor.data.matters)
	
	%SumRazor.data = RazorData.new(sum_value, matters)
