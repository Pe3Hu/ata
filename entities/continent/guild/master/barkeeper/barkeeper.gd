class_name Barkeeper
extends Master


func _ready() -> void:
	data = Mother.guild.barkeeper
	super._ready()

func connect_signals() -> void:
	data.recruit_changed.connect(_on_recruit_changed)
	_on_recruit_changed()

func _on_recruit_changed() -> void:
	%Recruit.data = data.current_recruit

func _on_previous_button_pressed() -> void:
	data.changed_recruit(-1)

func _on_next_button_pressed() -> void:
	data.changed_recruit(1)
