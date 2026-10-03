class_name Recruit
extends Task


var silhouette_scene = preload('uid://cgb34egynev5o')


#region init
func connect_signals() -> void:
	super.connect_signals()
	
	update_name()
	init_silhouettes()
	update_colors()

func update_name() -> void:
	%RecruitName.text = data.soul.name
	%GradeIcon.texture = load('res://entities/isle/house/card/echo/images/rank/%s.png' % Bozo.enum_to_string(Bozo.Type.RANK, data.soul.rank))
	%TalentIcon.texture = load('res://entities/isle/house/card/echo/images/talent/%d.png' % data.soul.talent)

func init_silhouettes() -> void:
	Helper.clear_children(%Silhouettes)
	
	for silhouette_data in data.silhouettes:
		add_silhouette(silhouette_data)

func add_silhouette(silhouette_data_: SilhouetteData) -> void:
	var silhouette = silhouette_scene.instantiate()
	%Silhouettes.add_child(silhouette)
	silhouette.data = silhouette_data_

func update_colors() -> void:
	var color = Digest.matter_to_color[data.soul.matter]
	%Top.get_theme_stylebox("panel").bg_color = color
#endregion

func _on_previous_recruit_button_pressed() -> void:
	data.master.changed_task(-1)

func _on_next_recruit_button_pressed() -> void:
	data.master.changed_task(1)
