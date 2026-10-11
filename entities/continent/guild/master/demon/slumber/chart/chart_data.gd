class_name ChartData
extends RefCounted


var soul: SoulData
#var intro: IntroDiceData
#var verse: VerseDiceData

var intro_razors: Array[RazorData]
var verse_rarozs: Array[RazorData]



func _init(soul_: SoulData) -> void:
#func _init(intro_: IntroDiceData, verse_: VerseDiceData) -> void:
	#intro = intro_
	#verse = verse_
	soul = soul_
	
	update_intro()
	update_verse()

func update_intro() -> void:
	intro_razors.clear()
	var matters = [soul.matter]
	
	for volume in soul.intro.values:
		var razor = RazorData.new(volume, matters)
		intro_razors.append(razor)

func update_verse() -> void:
	if soul.verse == null: return
	verse_rarozs.clear()
	var matters = [soul.matter]
	
	for volume in soul.verse.values:
		if Digest.factor_to_matter.has(volume):
			var matter = Digest.factor_to_matter[volume]
			
			if not matters.has(matter):
				matters.append(matter)
				break
	
	for volume in soul.verse.values:
		var razor = RazorData.new(volume, matters)
		verse_rarozs.append(razor)
