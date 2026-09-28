class_name MusicianData
extends MasterData



func init_dinamic_tasks() -> void:
	tasks.clear()
	
	for origin in guild.barkeeper.origins:
		add_veteran(origin)
	
	current_task = tasks.front()

func add_veteran(origin_: OriginData) -> void:
	var intro_sum = origin_.intro.get_sum() + Digest.talent_to_veteran[origin_.talent]
	var intro = Digest.sum_to_matter_to_intro[intro_sum][origin_.matter].pick_random()
	var verse = origin_.verse
	var new_origin = OriginData.new(self, origin_.matter, intro, verse, origin_.talent)
	var veteran = VeteranData.new(self, origin_.talent, new_origin)
	tasks.append(veteran)
