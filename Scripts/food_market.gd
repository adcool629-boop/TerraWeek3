extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	set_process(false)
	set_process_input(false)
	$CoinsNumber.text = ("Coins: " +str(MainCharacter.total_coins))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	get_parent().done_shopping()


func _on_buy_timer_timeout() -> void:
	$BuyMessage.text = ("")




func _on_apple_button_pressed() -> void:
	if MainCharacter.total_coins >= 20000:
		MainCharacter.total_coins - 20000
		if get_parent().apples == 0:
			MainCharacter.store_num += 1
		$Purchase.playing = true
		get_parent().apples += 1
		if get_parent().apples > 0:
			get_parent().apples_add()
		$BuyMessage.text = "Apple Bought"
		$BuyTimer.start()
	else:
		$BuyMessage.text = "Not Enough Coins"
		$Error.playing = true
		$BuyTimer.start()


func _on_bread_button_pressed() -> void:
	if MainCharacter.total_coins >= 20000:
		MainCharacter.total_coins - 20000
		if get_parent().bread == 0:
			MainCharacter.store_num += 1
		$Purchase.playing = true
		get_parent().bread += 1
		if get_parent().bread > 0:
			get_parent().bread_add()
		$BuyMessage.text = "Bread Bought"
		$BuyTimer.start()
	else:
		$BuyMessage.text = "Not Enough Coins"
		$Error.playing = true
		$BuyTimer.start()


func _on_cake_button_pressed() -> void:
	if MainCharacter.total_coins >= 20000:
		MainCharacter.total_coins - 20000
		if get_parent().cake == 0:
			MainCharacter.store_num += 1
		$Purchase.playing = true
		get_parent().cake += 1
		if get_parent().cake > 0:
			get_parent().cake_add()
		get_parent().luck += 5
		$BuyMessage.text = "Chocolate Cake Bought"
		$BuyTimer.start()
	else:
		$BuyMessage.text = "Not Enough Coins"
		$Error.playing = true
		$BuyTimer.start()
