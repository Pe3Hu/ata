class_name Recruit
extends PanelContainer


var silhouette_scene = preload('uid://cgb34egynev5o')

var data: RecruitData:
	set(value_):
		data = value_
		
		init_silhouettes()
		update_colors()


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
