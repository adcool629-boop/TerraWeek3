extends CanvasLayer

var grod_not_purchased: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$UseBackground.visible = false
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
	$GamblersRod/GRodButton.text = str(40000)



func _on_squid_lure_button_pressed() -> void:
	
	if MainCharacter.total_coins >= 10000:
		MainCharacter.total_coins = MainCharacter.total_coins - 20000
		if get_parent().squid_amount == 0 and MainCharacter.store_num == 28:
			return
		elif get_parent().squid_amount == 0:
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
		


func _on_g_rod_button_pressed() -> void:
	if grod_not_purchased:
		if MainCharacter.total_coins >= 40000:
			MainCharacter.total_coins += -40000
			get_parent().GRod = true
			get_parent().GRod_uses += 3
			get_parent().ARod = false
			get_parent().IRod = false
			grod_not_purchased = false
			print("GRod Bought")
		elif MainCharacter.total_coins < 40000:
			print("Not enough Coins")
	elif not grod_not_purchased and not get_parent().GRod:
		print("Decide")
		$UseBackground.visible = true
		
	elif get_parent().GRod:
		print("Already Equipped")
		$GamblersRod/GRodButton.text = "Equipped"
		get_parent().ARod = false
		get_parent().IRod = false

func _on_yes_pressed() -> void:
	print("GRod Equipped")
	get_parent().GRod = true
	get_parent().ARod = false
	get_parent().IRod = false
	$GamblersRod/GRodButton.text = "Equipped"
	$UseBackground.visible = false


func _on_no_pressed() -> void:
	print("Not Equipped")
	$UseBackground.visible = false
