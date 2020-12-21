extends HBoxContainer


onready var tween := $Tween

var desired_score: int = 0
var score: int = 0

func _process(_delta: float):
	if PlayerVariables.score != desired_score:
		tween.stop(self)

		desired_score = PlayerVariables.score
		tween.interpolate_property(self, "score", score, desired_score, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.start()
	$ScoreLabel.text = "%10d" % score

