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
var CfL_positionX: int
var CfL_positionY: int
var CodL_positionX: int
var CodL_positionY: int
var GfL_positionX: int
var GfL_positionY: int
var FC_positionX: int
var FC_positionY: int
var Trash_positionX: int
var Trash_positionY: int
var SLuck_positionX: int
var SLuck_positionY: int
var MLuck_positionX: int
var MLuck_positionY: int
var LLuck_positionX: int
var LLuck_positionY: int
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
			$Node/ClownfishLure.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/ClownfishLure.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/ClownfishLure.position.y = 200
		CfL_positionX = $Node/ClownfishLure.position.x
		CfL_positionY = $Node/ClownfishLure.position.y
		print("X Position is " +str(CfL_positionX))
		print("Y Position is " +str(CfL_positionY))
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
	if CodL_positionX > CfL_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > CfL_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if GfL_positionX > CfL_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish position")
	elif GfL_positionY > CfL_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if FC_positionX > CfL_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > CfL_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if Trash_positionX > CfL_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing trash position")
	elif Trash_positionY > CfL_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if SLuck_positionX > CfL_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > CfL_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if MLuck_positionX > CfL_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > CfL_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if LLuck_positionX > CfL_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > CfL_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	
func add_cod_lure() -> void:
	CodLure_amount += 1
	print(CodLure_amount)
	$Node/CodLure/Label.text = str(CodLure_amount)
	if get_parent().CodL_amount > 0 and get_parent().CodL_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/CodLure.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/CodLure.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/CodLure.position.x = (MainCharacter.store_num) * 125 - 800
			CodLure_amount = $Node/CodLure.position.x
			$Node/CodLure.position.y = 200
		CodL_positionX = $Node/CodLure.position.x
		CodL_positionY = $Node/CodLure.position.y
		print("X Position is " +str(CodL_positionX))
		print("Y Position is " +str(CodL_positionY))
			
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
	if CfL_positionX > CodL_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > CodL_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if GfL_positionX > CodL_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish position")
	elif GfL_positionY > CodL_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if FC_positionX > CodL_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > CodL_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if Trash_positionX > CodL_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing trash position")
	elif Trash_positionY > CodL_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if SLuck_positionX > CodL_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > CodL_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if MLuck_positionX > CodL_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > CodL_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if LLuck_positionX > CodL_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > CodL_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
func add_goldfish_lure() -> void:
	GoldfishLure_amount += 1
	print(GoldfishLure_amount)
	$Node/GoldfishLure/Label.text = str(GoldfishLure_amount)
	if get_parent().GfL_amount > 0 and get_parent().GfL_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/GoldfishLure.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/GoldfishLure.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/GoldfishLure.position.x = (MainCharacter.store_num) * 125 - 800
			GoldfishLure_amount = $Node/GoldfishLure.position.x
			$Node/GoldfishLure.position.y = 200
		GfL_positionX = $Node/GoldfishLure.position.x
		GfL_positionY = $Node/GoldfishLure.position.y
		print("X Position is " +str(GfL_positionX))
		print("Y Position is " +str(GfL_positionY))
	
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
	if CodL_positionX > GfL_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > GfL_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > GfL_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > GfL_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if FC_positionX > GfL_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > GfL_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if Trash_positionX > GfL_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing trash position")
	elif Trash_positionY > GfL_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if SLuck_positionX > GfL_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > GfL_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if MLuck_positionX > GfL_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > GfL_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if LLuck_positionX > GfL_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > GfL_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
func add_fc_lure() -> void:
	FatChanceLure_amount += 1
	print(FatChanceLure_amount)
	$Node/FatChance/Label.text = str(FatChanceLure_amount)
	if get_parent().FC_amount > 0 and get_parent().FC_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/FatChance.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/FatChance.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/FatChance.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/FatChance.position.y = 200
		FC_positionX = $Node/FatChance.position.x
		FC_positionY = $Node/FatChance.position.y
		print("X Position is " +str(FC_positionX))
		print("Y Position is " +str(FC_positionY))
			
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

	if GfL_positionX > FC_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > FC_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > FC_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > FC_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > FC_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > FC_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if Trash_positionX > FC_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing trash position")
	elif Trash_positionY > FC_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if SLuck_positionX > FC_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > FC_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if MLuck_positionX > FC_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > FC_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if LLuck_positionX > FC_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > FC_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100

func add_trash() -> void:
	TrashBag_amount += 1
	print(TrashBag_amount)
	$Node/Trash/Label.text = str(TrashBag_amount)
	if get_parent().trash_amount > 0 and get_parent().trash_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/Trash.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/Trash.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/Trash.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/Trash.position.y = 200
		Trash_positionX = $Node/Trash.position.x
		Trash_positionY = $Node/Trash.position.y
		print("X Position is " +str(Trash_positionX))
		print("Y Position is " +str(Trash_positionY))
		
func remove_trash() -> void:
	print(TrashBag_amount)
	$Node/Trash/Label.text = ''
	$Node/Trash.position.x = 0
	$Node/Trash.position.y = 0
	$Node/Trash.visible = false
	trash_move_back()
		
		
func trash_move_back() -> void:
	if FC_positionX > Trash_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > Trash_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > Trash_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > Trash_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > Trash_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > Trash_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > Trash_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > Trash_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if SLuck_positionX > Trash_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > Trash_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if MLuck_positionX > Trash_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > Trash_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if LLuck_positionX > Trash_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > Trash_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
func add_S_Luck_Potion() -> void:
	SLuck_amount += 1
	print(SLuck_amount)
	$Node/SLuck/Label.text = str(SLuck_amount)
	if get_parent().SLuck > 0 and get_parent().SLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/SLuck.position.x = (MainCharacter.store_num) * 125 + 75
			SLuck_positionX = $Node/SLuck.position.x
			$Node/SLuck.position.y = 100
			SLuck_positionY = $Node/SLuck.position.y
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/SLuck.position.x = (MainCharacter.store_num) * 125 - 800
			SLuck_positionX = $Node/SLuck.position.x
			$Node/SLuck.position.y = 200
			SLuck_positionY = $Node/SLuck.position.y
		print("X Position is " +str(SLuck_positionX))
		print("Y Position is " +str(SLuck_positionY))
		
			
func remove_S_Luck_potion() -> void:
	print(SLuck_amount)
	$Node/SLuck/Label.text = ''
	$Node/SLuck.position.x = 0
	$Node/SLuck.position.y = 0
	$Node/SLuck.visible = false
	S_Luck_Potion_Move_Back()
func S_Luck_Potion_Move_Back() -> void:
	if Trash_positionX > SLuck_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > SLuck_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > SLuck_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > SLuck_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > SLuck_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > SLuck_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > SLuck_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > SLuck_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > SLuck_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > SLuck_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if MLuck_positionX > SLuck_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > SLuck_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if LLuck_positionX > SLuck_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > SLuck_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
func add_M_Luck_Potion() -> void:
	MLuck_amount += 1
	print(MLuck_amount)
	$Node/MLuck/Label.text = str(MLuck_amount)
	if get_parent().MLuck > 0 and get_parent().MLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/MLuck.position.x = (MainCharacter.store_num) * 125 + 75
			MLuck_positionX = $Node/MLuck.position.x
			$Node/MLuck.position.y = 100
			MLuck_positionY = $Node/MLuck.position.y
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/MLuck.position.x = (MainCharacter.store_num) * 125 - 800
			MLuck_positionX = $Node/MLuck.position.x
			$Node/MLuck.position.y = 200
			MLuck_positionY = $Node/MLuck.position.y
		print("X position is " +str(MLuck_positionX))
		print("Y position is " +str(MLuck_positionY))
func remove_M_Luck_potion() -> void:
	print(MLuck_amount)
	$Node/MLuck/Label.text = ''
	$Node/MLuck.position.x = 0
	$Node/MLuck.position.y = 0
	$Node/MLuck.visible = false
	M_Luck_Potion_Move_Back()
	
func M_Luck_Potion_Move_Back() -> void:
	if SLuck_positionX > MLuck_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > MLuck_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > MLuck_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > MLuck_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > MLuck_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > MLuck_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > MLuck_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > MLuck_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > MLuck_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > MLuck_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > MLuck_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > MLuck_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > MLuck_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > MLuck_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	
func add_L_Luck_Potion() -> void:
	LLuck_amount += 1
	print(LLuck_amount)
	$Node/LLuck/Label.text = str(LLuck_amount)
	if get_parent().LLuck > 0 and get_parent().LLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/LLuck.position.x = (MainCharacter.store_num) * 125 + 75
			LLuck_positionX = $Node/LLuck.position.x
			$Node/LLuck.position.y = 100
			LLuck_positionY = $Node/LLuck.position.y
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/LLuck.position.x = (MainCharacter.store_num) * 125 - 800
			LLuck_positionX = $Node/LLuck.position.x
			$Node/LLuck.position.y = 200
			LLuck_positionY = $Node/LLuck.position.y
		print("X Position is " +str(LLuck_positionX))
		print("Y Position is " +str(LLuck_positionY))
	LLuck_positionX = $Node/LLuck.position.x
func remove_L_Luck_potion() -> void:
	print(LLuck_amount)
	$Node/LLuck/Label.text = ''
	$Node/LLuck.position.x = 0
	$Node/LLuck.position.y = 0
	$Node/LLuck.visible = false

func L_Luck_Potion_Move_Back() -> void:
	if MLuck_positionX > LLuck_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > LLuck_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > LLuck_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > LLuck_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > LLuck_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > LLuck_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > LLuck_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > LLuck_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > LLuck_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > LLuck_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > LLuck_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > LLuck_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > LLuck_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > LLuck_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
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
		LLuck_amount += -1
		get_parent().LLuck += -1
		if get_parent().LLuck <= 0:
			remove_L_Luck_potion()
		UseLargeLuck = false
	if UseMediumLuck:
		get_parent().luck += 6
		MLuck_amount += -1
		get_parent().MLuck += -1
		if get_parent().MLuck <= 0:
			remove_M_Luck_potion()
		UseMediumLuck = false
	if UseSmallLuck:
		get_parent().luck += 2
		SLuck_amount += -1
		get_parent().SLuck += -1
		if get_parent().SLuck <= 0:
			remove_S_Luck_potion()
		UseSmallLuck = false
	print("Luck is " + str(get_parent().luck))
	
