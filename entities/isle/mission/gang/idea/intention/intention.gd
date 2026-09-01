class_name Intention
extends TextureRect


var data: IntentionData:
	set(value_):
		data = value_
		
		modulate = Digest.element_to_color
