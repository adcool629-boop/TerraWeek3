extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	set_process(false)
	set_process_input(false)
	$TrashAmount.text = ("Trash: " + str(MainCharacter.trash))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TrashAmount.text = ("Trash: " + str(MainCharacter.trash))


func _on_buy_timer_timeout() -> void:
	$BuyMessage.text = ""


func _on_sl_potion_pressed() -> void:
	if MainCharacter.trash >= 1:
		MainCharacter.trash += -1
		if get_parent().SLuck == 0:
			MainCharacter.store_num += 1
		get_parent().SLuck += 1
		if get_parent().SLuck > 0:
			get_parent().S_Luck_Potion_add()
			
		print("Small Luck Potion Bought")
		$BuyMessage.text = "Small Luck Potion Bought"
		$BuyMessage/BuyTimer.start()
		$TrashAmount.text = ("Trash: " + str(MainCharacter.trash))
	else:
		$BuyMessage.text = "Not enoguh Trash"
		$BuyMessage/BuyTimer.start()



func _on_ml_potion_pressed() -> void:
	if MainCharacter.trash >= 3:
		MainCharacter.trash += -3
		if get_parent().MLuck == 0:
			MainCharacter.store_num += 1
		get_parent().MLuck += 1
		if get_parent().MLuck > 0:
			get_parent().M_Luck_Potion_add()
			
		print("Medium Luck Potion Bought")
		$BuyMessage.text = "Medium Luck Potion Bought"
		$BuyMessage/BuyTimer.start()
		$TrashAmount.text = ("Trash: " + str(MainCharacter.trash))
	else:
		$BuyMessage.text = "Not enoguh Trash"
		$BuyMessage/BuyTimer.start()


func _on_ll_potion_pressed() -> void:
	if MainCharacter.trash >= 3:
		MainCharacter.trash += -3
		if get_parent().LLuck == 0:
			MainCharacter.store_num += 1
		get_parent().LLuck += 1
		if get_parent().LLuck > 0:
			get_parent().L_Luck_Potion_add()
			
		print("Large Luck Potion Bought")
		$BuyMessage.text = "Large Luck Potion Bought"
		$BuyMessage/BuyTimer.start()
		$TrashAmount.text = ("Trash: " + str(MainCharacter.trash))
	else:
		$BuyMessage.text = "Not enoguh Trash"
		$BuyMessage/BuyTimer.start()


func _on_close_button_pressed() -> void:
	get_parent().done_shopping()
