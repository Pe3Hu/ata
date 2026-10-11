class_name Elite
extends PanelContainer


@export var slumber: Slumber
@export var gloom: Gloom


func set_gloom(gloom_data_: GloomData) -> void:
	%Gloom.data = gloom_data_
	
	if gloom_data_.is_elite:
		if Catalog.limiter_elements.has(gloom_data_.element):
			var tune = Digest.element_to_tune[gloom_data_.element]
			
			match tune:
				Bozo.Tune.INTRO:
					%Gloom.offset_transform_position.x = Catalog.GLOOM_OFFSET
					%IntroLimiter.update()
				Bozo.Tune.VERSE:
					%Gloom.offset_transform_position.x = -Catalog.GLOOM_OFFSET
					%VerseLimiter.update()
