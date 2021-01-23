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
	var score_label = Label.new()
	var killed_label = Label.new()
	var lost_label = Label.new()
	var date_label = Label.new()
	
	position_label.theme = theme
	score_label.theme = theme
	killed_label.theme = theme
	lost_label.theme = theme
	date_label.theme = theme
	
	position_label.text = str(position)
	score_label.text = str(score["score"])
	killed_label.text = str(_dict_sum(score["killed"]))
	lost_label.text = str(_dict_sum(score["spawned"]))
	date_label.text = _date_to_str(score["datetime"])
	
	var container = $Controls/CenterContainer/GridContainer
	container.add_child(position_label)
	container.add_child(score_label)
	container.add_child(killed_label)
	container.add_child(lost_label)
	container.add_child(date_label)
