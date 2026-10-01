class_name Sculpture
extends Task




func _ready() -> void:
	var matters = [Bozo.Matter.SOLID]
	Helper.update_matter_colors(%PreparedBody, matters)

func connect_signals() -> void:
	super.connect_signals()
	
	for asterism in Mother.welkin.asterisms:
		if not asterism.external_star.current_changed.is_connected(_on_star_changed):
			asterism.external_star.current_changed.connect(_on_star_changed)
		
		if not asterism.internal_star.current_changed.is_connected(_on_star_changed):
			asterism.internal_star.current_changed.connect(_on_star_changed)
	
	_on_star_changed()
	
	connect_asterisms()

func connect_asterisms() -> void:
	for _i in Mother.welkin.asterisms.size():
		var asterism = Mother.welkin.asterisms[_i]
		var constellation = %Constellations.get_child(_i)
		constellation.asterism = asterism

func _on_star_changed() -> void:
	var current_prepared = Mother.welkin.get_prepared_amount()
	var rank_prepared = data.master.altars.size() + 1
	%PreparedLabel.text = str(rank_prepared)
	%PreparedBody.visible = current_prepared >= rank_prepared
