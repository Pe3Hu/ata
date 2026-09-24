class_name Recruit
extends PanelContainer


var silhouette_scene = preload('uid://cgb34egynev5o')

var data: RecruitData:
	set(value_):
		data = value_
		
		connect_signals()
		init_silhouettes()
		update_colors()


func connect_signals() -> void:
	if not data.musician.recruit_changed.is_connected(_on_recruit_changed):
		data.musician.recruit_changed.connect(_on_recruit_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()

func _on_recruit_changed() -> void:
	data = data.musician.current_recruit
	_on_quotum_changed()

func _on_quotum_changed() -> void:
	%Quotum.data = data.tribute.current_quotum

func init_silhouettes() -> void:
	Helper.clear_children(%Silhouettes)
	
	for silhouette_data in data.silhouettes:
		add_silhouette(silhouette_data)

func add_silhouette(silhouette_data_: SilhouetteData) -> void:
	var silhouette = silhouette_scene.instantiate()
	%Silhouettes.add_child(silhouette)
	silhouette.data = silhouette_data_

func update_colors() -> void:
	var color = Digest.matter_to_color[data.origin.matter]
	%Top.get_theme_stylebox("panel").bg_color = color


func _on_previous_recruit_button_pressed() -> void:
	data.musician.changed_recruit(-1)

func _on_next_recruit_button_pressed() -> void:
	data.musician.changed_recruit(1)

func _on_previous_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(1)
