extends HBoxContainer

func _process(_delta):
	$CoinCount.text = "%d" % int(PlayerVariables.coin)
