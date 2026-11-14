extends CanvasLayer
var clownfish_num: int = 0
#125.x gap between the each panel
var ClownfishLure_amount: int = 0
var CodLure_amount: int = 0
var GoldfishLure_amount: int = 0
var FatChanceLure_amount: int = 0
var TrashBag_amount: int = 0
var SLuck_amount: int = 0
var MLuck_amount: int = 0
var LLuck_amount: int = 0
var CfL_position: int
var CodL_position: int
var GfL_position: int
var FC_position: int
var Trash_position: int
var SLuck_position: int
var MLuck_position: int
var LLuck_position: int
var intermediate_equipped: bool = false
var advanced_equipped: bool = false
var basic_equipped: bool = true
var UseLargeLuck: bool = false
var UseMediumLuck: bool = false
var UseSmallLuck: bool = false

#-----------------
#Add Fish
#-----------------

var fish_num: int = 0
var store_fish: Dictionary = {
	"fish": {"clownfish" = 1, "cod" = 1, "goldfish" = 1}
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$Node/ClownfishLure.visible = false
	$Node/CodLure.visible = false
	$Node/GoldfishLure.visible = false
	$Node/FatChance.visible = false
	$Node/Cod.visible = false
	$Node/Clownfish.visible = false
	$Node/Goldfish.visible = false
	$IRod.visible = false
	$ARod.visible = false
	$BRod.visible = false
	$Node/Trash.visible = false
	$Node/SLuck.visible = false
	$Node/MLuck.visible = false
	$Node/LLuck.visible = false
	$UseBackground.position.x = -400
func openinv() -> void:
	$".".visible = true
	$UseBackground.visible = false
	if get_parent().CfL_amount > 0:
		$Node/ClownfishLure.visible = true
	if get_parent().CodL_amount > 0:
		$Node/CodLure.visible = true
	if get_parent().GfL_amount > 0:
		$Node/GoldfishLure.visible = true
	if get_parent().FC_amount > 0:
		$Node/FatChance.visible = true
	if basic_equipped:
		$BRod.visible = true
	elif intermediate_equipped:
		$IRod.visible = true
	elif advanced_equipped:
		$ARod.visible = true
	if get_parent().trash_amount > 0:
		$Node/Trash.visible = true
	if get_parent().SLuck > 0:
		$Node/SLuck.visible = true
	if get_parent().MLuck > 0:
		$Node/MLuck.visible = true
	if get_parent().LLuck > 0:
		$Node/LLuck.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	$Coins.text = str(MainCharacter.total_coins)
#func add_clownfish() -> void:
	#fish_num += 1
	#store_fish['Clownfish' + str(fish_num)]
	#print(store_fish['Clownfish' + str(fish_num)])
			
func add_clownfish_lure() -> void:
	ClownfishLure_amount += 1
	print(ClownfishLure_amount)
	$Node/ClownfishLure/Amount.text =  str(ClownfishLure_amount)
	if get_parent().CfL_amount > 0 and get_parent().CfL_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			
			$Node/ClownfishLure.position.x = (MainCharacter.store_num) * 125 + 75
			CfL_position = $Node/ClownfishLure.position.x
			$Node/ClownfishLure.position.y = 100
			print("Position is " +str(CfL_position))
			
func decrease_clownfish_lure() -> void:
	ClownfishLure_amount += -1
	$Node/ClownfishLure/Amount.text = str(ClownfishLure_amount)
	
func remove_clownfish_lure() -> void:
	print(ClownfishLure_amount)
	$Node/ClownfishLure/Amount.text = ''
	$Node/ClownfishLure.position.x = 0
	$Node/ClownfishLure.position.y = 0
	$Node/ClownfishLure.visible = false
	clownfish_lure_move_back()
	get_parent().unselect_clownfish_lure()
	
func clownfish_lure_move_back() -> void:
	if CodL_position > CfL_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if GfL_position > CfL_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish position")
	if FC_position > CfL_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing FC position")
	if Trash_position > FC_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing trash position")
	if SLuck_position > FC_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if MLuck_position > FC_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
	if LLuck_position > FC_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")
func add_cod_lure() -> void:
	CodLure_amount += 1
	print(CodLure_amount)
	$Node/CodLure/Label.text = str(CodLure_amount)
	if get_parent().CodL_amount > 0 and get_parent().CodL_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/CodLure.position.x = (MainCharacter.store_num) * 125 + 75
			CodL_position = $Node/CodLure.position.x
			$Node/CodLure.position.y = 100
			print(CodL_position)
			
func decrease_cod_lure() -> void:
	CodLure_amount += -1
	$Node/CodLure/Label.text = str(CodLure_amount)
	
func remove_cod_lure() -> void:
	print(CodLure_amount)
	$Node/CodLure/Label.text = ''
	$Node/CodLure.position.x = 0
	$Node/CodLure.position.y = 0
	$Node/CodLure.visible = false
	cod_lure_move_back()
	get_parent().unselect_cod_lure()
	
func cod_lure_move_back() -> void:
	if CfL_position > CodL_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if GfL_position > CodL_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish position")
	if FC_position > CodL_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing FC position")
	if Trash_position > FC_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing trash position")
	if SLuck_position > FC_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if MLuck_position > FC_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
	if LLuck_position > FC_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")
func add_goldfish_lure() -> void:
	GoldfishLure_amount += 1
	print(GoldfishLure_amount)
	$Node/GoldfishLure/Label.text = str(GoldfishLure_amount)
	if get_parent().GfL_amount > 0 and get_parent().GfL_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/GoldfishLure.position.x = (MainCharacter.store_num) * 125 + 75
			GfL_position = $Node/GoldfishLure.position.x
			$Node/GoldfishLure.position.y = 100
	
func decrease_goldfish_lure() -> void:
	GoldfishLure_amount += -1
	$Node/GoldfishLure/Label.text = str(GoldfishLure_amount)
	
func remove_goldfish_lure() -> void:
	print("It works!")
	print(GoldfishLure_amount)
	$Node/GoldfishLure/Label.text = ''
	$Node/GoldfishLure.position.x = 0
	$Node/GoldfishLure.position.y = 0
	$Node/GoldfishLure.visible = false
	goldfish_lure_move_back()
	get_parent().unselect_goldfish_lure()
	
func goldfish_lure_move_back() -> void:
	print("It works 2x")
	if CfL_position > GfL_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if CodL_position > GfL_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if FC_position > GfL_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing fc position")
	if Trash_position > FC_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing trash position")
	if SLuck_position > FC_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if MLuck_position > FC_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
	if LLuck_position > FC_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")
	print("It works 3x")
func add_fc_lure() -> void:
	FatChanceLure_amount += 1
	print(FatChanceLure_amount)
	$Node/FatChance/Label.text = str(FatChanceLure_amount)
	if get_parent().FC_amount > 0 and get_parent().FC_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/FatChance.position.x = (MainCharacter.store_num) * 125 + 75
			FC_position = $Node/FatChance.position.x
			$Node/FatChance.position.y = 100
			
func decrease_fc() -> void:
	FatChanceLure_amount += -1
	$Node/FatChance/Label.text = str(FatChanceLure_amount)
	
func remove_fc_lure() -> void:
	print("it does work")
	print(FatChanceLure_amount)
	$Node/FatChance/Label.text = ''
	$Node/FatChance.position.x = 0
	$Node/FatChance.position.y = 0
	$Node/FatChance.visible = false
	fc_move_back()
	get_parent().unselect_fatchance()
	print("it does work 2x")
func fc_move_back() -> void:
	if CfL_position > FC_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if GfL_position > FC_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish_position")
	if CodL_position > FC_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if Trash_position > FC_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing trash position")
	if SLuck_position > FC_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if MLuck_position > FC_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
	if LLuck_position > FC_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")

func add_trash() -> void:
	TrashBag_amount += 1
	print(TrashBag_amount)
	$Node/Trash/Label.text = str(TrashBag_amount)
	if get_parent().trash_amount > 0 and get_parent().trash_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/Trash.position.x = (MainCharacter.store_num) * 125 + 75
			Trash_position = $Node/Trash.position.x
			$Node/Trash.position.y = 100
		
func remove_trash() -> void:
	print(TrashBag_amount)
	$Node/Trash/Label.text = ''
	$Node/Trash.position.x = 0
	$Node/Trash.position.y = 0
	$Node/Trash.visible = false
	trash_move_back()
		
		
func trash_move_back() -> void:
	if CfL_position > Trash_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if GfL_position > Trash_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish_position")
	if CodL_position > Trash_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if FC_position > Trash_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing FC position")
	if SLuck_position > Trash_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if MLuck_position > Trash_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
	if LLuck_position > Trash_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")
func add_S_Luck_Potion() -> void:
	SLuck_amount += 1
	print(SLuck_amount)
	$Node/SLuck/Label.text = str(SLuck_amount)
	if get_parent().SLuck > 0 and get_parent().SLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/SLuck.position.x = (MainCharacter.store_num) * 125 + 75
			SLuck_position = $Node/SLuck.position.x
			$Node/SLuck.position.y = 100
			
func remove_S_Luck_potion() -> void:
	print(SLuck_amount)
	$Node/SLuck/Label.text = ''
	$Node/SLuck.position.x = 0
	$Node/SLuck.position.y = 0
	$Node/SLuck.visible = false
	S_Luck_Potion_Move_Back()
func S_Luck_Potion_Move_Back() -> void:
	if CfL_position > SLuck_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if GfL_position > SLuck_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish_position")
	if CodL_position > SLuck_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if FC_position > SLuck_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing FC position")
	if Trash_position > SLuck_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing Trash position")
	if MLuck_position > SLuck_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
	if LLuck_position > SLuck_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")
func add_M_Luck_Potion() -> void:
	MLuck_amount += 1
	print(MLuck_amount)
	$Node/MLuck/Label.text = str(MLuck_amount)
	if get_parent().MLuck > 0 and get_parent().MLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/MLuck.position.x = (MainCharacter.store_num) * 125 + 75
			MLuck_position = $Node/MLuck.position.x
			$Node/MLuck.position.y = 100
func remove_M_Luck_potion() -> void:
	print(MLuck_amount)
	$Node/MLuck/Label.text = ''
	$Node/MLuck.position.x = 0
	$Node/MLuck.position.y = 0
	$Node/MLuck.visible = false
	M_Luck_Potion_Move_Back()
	
func M_Luck_Potion_Move_Back() -> void:
	if CfL_position > MLuck_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if GfL_position > MLuck_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish_position")
	if CodL_position > MLuck_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if FC_position > MLuck_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing FC position")
	if Trash_position > MLuck_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing Trash position")
	if SLuck_position > MLuck_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if LLuck_position > MLuck_position:
		$Node/LLuck.position.x = LLuck_position - 125
		LLuck_position = LLuck_position - 125
		print("decreasing L Luck position")
	
func add_L_Luck_Potion() -> void:
	LLuck_amount += 1
	print(LLuck_amount)
	$Node/LLuck/Label.text = str(LLuck_amount)
	if get_parent().LLuck > 0 and get_parent().LLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/LLuck.position.x = (MainCharacter.store_num) * 125 + 75
			LLuck_position = $Node/LLuck.position.x
			$Node/LLuck.position.y = 100
func remove_L_Luck_potion() -> void:
	print(LLuck_amount)
	$Node/LLuck/Label.text = ''
	$Node/LLuck.position.x = 0
	$Node/LLuck.position.y = 0
	$Node/LLuck.visible = false

func L_Luck_Potion_Move_Back() -> void:
	if CfL_position > LLuck_position:
		$Node/ClownfishLure.position.x = CfL_position - 125
		CfL_position = CfL_position - 125
		print("decreasing clownfish position")
	if GfL_position > LLuck_position:
		$Node/GoldfishLure.position.x = GfL_position - 125
		GfL_position = GfL_position - 125
		print("decreasing goldfish_position")
	if CodL_position > LLuck_position:
		$Node/CodLure.position.x = CodL_position - 125
		CodL_position = CodL_position - 125
		print("decreasing cod position")
	if FC_position > LLuck_position:
		$Node/FatChance.position.x = FC_position - 125
		FC_position = FC_position - 125
		print("decreasing FC position")
	if Trash_position > LLuck_position:
		$Node/Trash.position.x = Trash_position - 125
		Trash_position = Trash_position - 125
		print("decreasing Trash position")
	if SLuck_position > LLuck_position:
		$Node/SLuck.position.x = SLuck_position - 125
		SLuck_position = SLuck_position - 125
		print("decreasing S Luck position")
	if MLuck_position > LLuck_position:
		$Node/MLuck.position.x = MLuck_position - 125
		MLuck_position = MLuck_position - 125
		print("decreasing M Luck position")
func _on_close_pressed() -> void:
	$".".visible = false
	$Node/ClownfishLure.visible = false
	$Node/CodLure.visible = false
	$Node/GoldfishLure.visible = false
	$Node/FatChance.visible = false
	$Node/Cod.visible = false
	$Node/Clownfish.visible = false
	$Node/Goldfish.visible = false
	get_parent().inv_closed = true
	$BRod.visible = false
	$IRod.visible = false
	$ARod.visible = false
	$Node/SLuck.visible = false
	$Node/MLuck.visible = false
	$Node/LLuck.visible = false
	$Node/Trash.visible = false
	$UseBackground.visible = false
	
func _on_cf_l_button_pressed() -> void:
	get_parent().select_clownfish_lure()
	get_parent().unselect_cod_lure()
	get_parent().unselect_goldfish_lure()
	$BaitSelected.text = "Clownfish Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()
	

func _on_cod_l_button_pressed() -> void:
	get_parent().select_cod_lure()
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_goldfish_lure()
	$BaitSelected.text = "Cod Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()


func _on_gf_l_button_pressed() -> void:
	get_parent().select_goldfish_lure()
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_cod_lure()
	$BaitSelected.text = "Goldfish Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()


func _on_bait_selected_timer_timeout() -> void:
	$BaitSelected.text = ''


func _on_fc_button_pressed() -> void:
	get_parent().select_fatchance()
	$BaitSelected.text = "FatChance Selected"
	$BaitSelected/BaitSelectedTimer.start()


func _on_unselect_all_pressed() -> void:
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_cod_lure()
	get_parent().unselect_goldfish_lure()
	get_parent().unselect_fatchance()
	$BaitSelected.text = "Unselected All Lures and Baits"


func _on_s_luck_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Label.text = "Do you want to use small luck potion to boost your luck for the next 2 casts?"
	UseSmallLuck = true
	UseLargeLuck = false
	UseMediumLuck = false


func _on_m_luck_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Label.text = "Do you want to use medium luck potion to boost your luck for the next 6 casts?"
	UseMediumLuck = true
	UseLargeLuck = false
	UseSmallLuck = false

func _on_l_luck_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Label.text = "Do you want to use large luck potion to boost your luck for the next 20 casts?"
	UseLargeLuck = true
	UseMediumLuck = false
	UseSmallLuck = false


func _on_use_pressed() -> void:
	$UseBackground.set_process(false)
	$UseBackground.set_process_input(false)
	$UseBackground.position.x = -400
	if UseLargeLuck:
		get_parent().luck += 20
		UseLargeLuck = false
	if UseMediumLuck:
		get_parent().luck += 6
		UseMediumLuck = false
	if UseSmallLuck:
		get_parent().luck += 2
		UseSmallLuck = false
	print("Luck is " + str(get_parent().luck))
	
