extends HBoxContainer

onready var tween := $Tween

var desired_coin: int = 0
var coin: int = 0

func _process(_delta: float):
	if int(PlayerVariables.coin) != desired_coin:
		tween.stop(self)
		desired_coin = int(PlayerVariables.coin)
		
		# In case we just gained 1 coin, or we lost coin,
		# don't apply the tween, just change the text
		if desired_coin == coin + 1 or desired_coin < coin:
			coin = desired_coin
		else:
			tween.interpolate_property(self, "coin", coin, desired_coin, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			tween.start()
	$CoinCount.text = str(coin)

