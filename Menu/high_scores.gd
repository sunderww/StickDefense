extends BaseScene


func _ready() -> void:
	var scores = ScoreService.load_scores()
	scores.sort_custom(ScoreService, "sort_scores")
	
	var position = 1	
	for score in scores:
		add_score_line(position, score)
		position += 1


func _dict_sum(dict: Dictionary) -> int:
	var sum = 0
	for value in dict.values():
		sum += value
	return sum


func _date_to_str(date: Dictionary) -> String:
	return "%02d/%02d/%d - %02d:%02d" % [
		date["day"],
		date["month"],
		date["year"],
		date["hour"],
		date["minute"],
	]

func add_score_line(position: int, score: Dictionary) -> void:
	var theme = preload("res://GUI/DefaultTheme.tres")
	var position_label = Label.new()
	var wave_label = Label.new()
	var score_label = Label.new()
	var killed_label = Label.new()
	var lost_label = Label.new()
	var ratio_label = Label.new()
	var date_label = Label.new()
	
	position_label.theme = theme
	wave_label.theme = theme
	score_label.theme = theme
	killed_label.theme = theme
	lost_label.theme = theme
	ratio_label.theme = theme
	date_label.theme = theme
	
	var killed = _dict_sum(score["killed"])
	var lost = _dict_sum(score["spawned"])
	var ratio = float(killed) / float(lost)
	position_label.text = "#%2d" % position
	wave_label.text = str(score["level"])
	score_label.text = str(score["score"])
	killed_label.text = str(killed)
	lost_label.text = str(lost)
	ratio_label.text = "%.2f" % ratio
	date_label.text = _date_to_str(score["datetime"])
	
	var container = $Controls/CenterContainer/GridContainer
	container.add_child(position_label)
	container.add_child(wave_label)
	container.add_child(score_label)
	container.add_child(killed_label)
	container.add_child(lost_label)
	container.add_child(ratio_label)
	container.add_child(date_label)
