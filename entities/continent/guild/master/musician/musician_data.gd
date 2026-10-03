class_name MusicianData
extends MasterData



func init_tasks() -> void:
	for soul in guild.barkeeper.souls:
		add_veteran(soul)

func add_veteran(soul_: SoulData) -> void:
	var intro = soul_.reincarnation_intro
	var verse = soul_.verse
	var new_soul = SoulData.new(self, soul_.matter, intro, verse, soul_.talent, soul_.name)
	VeteranData.new(self, soul_.talent, new_soul)
