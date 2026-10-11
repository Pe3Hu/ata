class_name Chart
extends PanelContainer


var data: ChartData:
	set(value_):
		data = value_
		
		%IntroShowcase.update_razors(data.intro_razors)
		%VerseShowcase.update_razors(data.verse_rarozs)
