class_name Instrument
extends PanelContainer


var razor_scene = preload('uid://2smcb1akyroc')

var data: InstrumentData:
	set(value_):
		data = value_
		
		connect_signals()
		update_rank()
		init_razors()


func update_rank() -> void:
	%RankBody.texture = load('res://entities/continent/guild/master/blacksmith/rank/images/%d/body.png' % data.rank)
	%RankBorder.texture = load('res://entities/continent/guild/master/blacksmith/rank/images/%d/border.png' % data.rank)

func init_razors() -> void:
	Helper.clear_children(%Razors)
	
	for razor_data in data.razors:
		add_razor(razor_data)

func add_razor(razor_data_: RazorData) -> void:
	var razor = razor_scene.instantiate()
	%Razors.add_child(razor)
	razor.data = razor_data_

func connect_signals() -> void:
	if not data.blacksmith.instrument_changed.is_connected(_on_instrument_changed):
		data.blacksmith.instrument_changed.connect(_on_instrument_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()

func _on_instrument_changed() -> void:
	data = data.blacksmith.current_instrument
	_on_quotum_changed()

func _on_quotum_changed() -> void:
	%Quotum.data = data.tribute.current_quotum
	update_colors()

func update_colors() -> void:
	Helper.update_matter_colors(%RankBody, [data.tribute.current_quotum.shard.matter])
	
	for razor in %Razors.get_children():
		razor.update_quotum_matter()

#region buttons
func _on_previous_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(1)

func _on_previous_rank_button_pressed() -> void:
	data.blacksmith.changed_instrument(-1)

func _on_next_rank_button_pressed() -> void:
	data.blacksmith.changed_instrument(1)
#endregion
