extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$Coins.text = ("Coins: " +str(MainCharacter.total_coins))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Coins.text = ("Coins: " +str(MainCharacter.total_coins))


func _on_close_pressed() -> void:
	get_parent().done_shopping()



func _on_fantasia_lure_button_pressed() -> void:
	if MainCharacter.total_coins >= 10000:
		MainCharacter.total_coins = MainCharacter.total_coins - 10000
		if get_parent().fanta_amount == 0:
			MainCharacter.store_num += 1
		$Purchase.playing = true
		get_parent().fanta_amount += 1
		if get_parent().fanta_amount > 0:
			get_parent().fanta_lure_add()
		$BuyMessage.text = "Fantasia Lure Bought"
		$BuyTimer.start()
	else:
		$BuyMessage.text = "Not Enough Coins"
		$Error.playing = true
		$BuyTimer.start()
		


func _on_buy_timer_timeout() -> void:
	$BuyMessage.text = ""



func _on_squid_lure_button_pressed() -> void:
	if MainCharacter.total_coins >= 10000:
		MainCharacter.total_coins = MainCharacter.total_coins - 20000
		if get_parent().squid_amount == 0:
			MainCharacter.store_num += 1
		$Purchase.playing = true
		get_parent().squid_amount += 1
		if get_parent().squid_amount > 0:
			get_parent().squid_lure_add()
		$BuyMessage.text = "Squid Lure Bought"
		$BuyTimer.start()
	else:
		$BuyMessage.text = "Not Enough Coins"
		$Error.playing = true
		$BuyTimer.start()
		
