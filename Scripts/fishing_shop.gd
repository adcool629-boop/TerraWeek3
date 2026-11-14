extends CanvasLayer

var irod_owned: bool = false
var arod_owned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	
	set_process(false)
	set_process_input(false)
	$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	$IntermediateFishingRod/ColorRect.position.x = 10000
	$IntermediateFishingRod/ColorRect.position.y = 10000
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	

func _on_buy_message_timer_timeout() -> void:
	$BuyMessage.text = ("")
	$IntermediateFishingRod/IRodButton.text = "5000 Coins"
	$AdvancedFishingRod/ARodButton.text = "15000 Coins"
#Clownfish Lure
func _on_clownfish_button_pressed() -> void:
	if MainCharacter.total_coins >= 200:
		MainCharacter.total_coins = MainCharacter.total_coins - 200
		if get_parent().CfL_amount == 0:
			MainCharacter.store_num += 1
		get_parent().CfL_amount += 1
		if get_parent().CfL_amount > 0:
			get_parent().clownfish_lure_add()
		
		print("Clownfish Lure Bought")
		$BuyMessage.text = ("Clownfish Lure Bought")
		$BuyMessage/BuyMessageTimer.start()
		$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	else:
		$BuyMessage.text = ("Not enough Coins")
		$BuyMessage/BuyMessageTimer.start()


func _on_cod_button_pressed() -> void:
	if MainCharacter.total_coins >= 300:
		MainCharacter.total_coins = MainCharacter.total_coins - 300
		if get_parent().CodL_amount == 0:
			MainCharacter.store_num += 1
		get_parent().CodL_amount += 1
		if get_parent().CodL_amount > 0:
			get_parent().cod_lure_add()
		
		print("Cod Lure Bought")
		$BuyMessage.text = ("Cod Lure Bought")
		$BuyMessage/BuyMessageTimer.start()
		$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	else:
		$BuyMessage.text = ("Not enough Coins")
		$BuyMessage/BuyMessageTimer.start()


func _on_goldfish_button_pressed() -> void:
	if MainCharacter.total_coins >= 150:
		MainCharacter.total_coins = MainCharacter.total_coins - 150
		if get_parent().GfL_amount == 0:
			MainCharacter.store_num += 1
		get_parent().GfL_amount += 1
		if get_parent().GfL_amount > 0:
			get_parent().goldfish_lure_add()
		
		print("Goldfish Lure Bought")
		$BuyMessage.text = ("Goldfish Lure Bought")
		$BuyMessage/BuyMessageTimer.start()
		$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	else:
		$BuyMessage.text = ("Not enough Coins")
		$BuyMessage/BuyMessageTimer.start()


func _on_fat_chance_button_pressed() -> void:
	if MainCharacter.total_coins >= 500:
		MainCharacter.total_coins = MainCharacter.total_coins - 500
		if get_parent().FC_amount == 0:
			MainCharacter.store_num += 1
		get_parent().FC_amount += 1
		if get_parent().FC_amount > 0:
			get_parent().fc_lure_add()
		
		print("FatChance Bait Bought")
		$BuyMessage.text = ("FatChance Bait Bought")
		$BuyMessage/BuyMessageTimer.start()
		$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	else:
		$BuyMessage.text = ("Not enough Coins")
		$BuyMessage/BuyMessageTimer.start()


func _on_close_button_pressed() -> void:
	get_parent().done_shopping()



func _on_i_rod_button_pressed() -> void:
	if irod_owned and arod_owned and get_parent().ARod:
		$IntermediateFishingRod/ColorRect.position.x = -100
		$IntermediateFishingRod/ColorRect.position.y = -75
		
	elif get_parent().IRod and not get_parent().ARod:
		$BuyMessage.text = "You already have this rod equipped"
		$BuyMessage/BuyMessageTimer.start()
	elif MainCharacter.total_coins >= 5000:
		MainCharacter.total_coins = MainCharacter.total_coins - 5000
		irod_owned = true
		get_parent().IRod = true
		get_parent().ARod = false
		print("Intermediate Rod Bought")
		$BuyMessage.text = "Intermediate Rod Bought"
		$IntermediateFishingRod/IRodButton.text = "Equipped"
		get_parent().intermediate_rod()
		$BuyMessage/BuyMessageTimer.start()
		$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	else:
		$BuyMessage.text = ("Not enough Coins")
		$BuyMessage/BuyMessageTimer.start()

func _on_a_rod_button_pressed() -> void:
	if get_parent().ARod:
		$BuyMessage.text = "You already have this rod equipped"
		$BuyMessage/BuyMessageTimer.start()
	elif irod_owned and arod_owned and get_parent().IRod:
		get_parent().ARod = true
		get_parent().IRod = false
		$BuyMessage.text = "Advanced Rod Equipped"
		$AdvancedFishingRod/ARodButton.text = 'Equipped'
		print("Advanced Rod Equipped")
		get_parent().advanced_rod()
		$BuyMessage/BuyMessageTimer.start()
	elif MainCharacter.total_coins >= 20000:
		MainCharacter.total_coins = MainCharacter.total_coins - 20000
		get_parent().ARod = true
		get_parent().IRod = false
		arod_owned = true
		print("Advanced Rod Bought")
		$BuyMessage.text = "Advanced Rod Bought"
		$AdvancedFishingRod/ARodButton.text = 'Equipped'
		get_parent().advanced_rod()
		$BuyMessage/BuyMessageTimer.start()
		$CoinsAmount.text = ("Coins: " +str(MainCharacter.total_coins))
	else:
		$BuyMessage.text = ("Not enough Coins")
		$BuyMessage/BuyMessageTimer.start()


func _on_yes_button_pressed() -> void:
	$IntermediateFishingRod/ColorRect.position.x = 10000
	$IntermediateFishingRod/ColorRect.position.y = 10000
	irod_owned = true
	get_parent().IRod = true
	get_parent().ARod = false
	print("Intermediate Rod Equipped")
	$BuyMessage.text = "Intermediate Rod Equipped"
	$IntermediateFishingRod/IRodButton.text = "Equipped"
	get_parent().intermediate_rod()
	$BuyMessage/BuyMessageTimer.start()


func _on_no_button_pressed() -> void:
	$IntermediateFishingRod/ColorRect.position.x = 10000
	$IntermediateFishingRod/ColorRect.position.y = 10000
