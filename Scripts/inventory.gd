extends CanvasLayer

#-------------------Amounts-----------------------

#----Fish-----
var cf_num: int = 1
var cod_num: int = 1
var gf_num: int = 1
var sf_num: int = 1
var bg_num: int = 1
var fanta_num: int = 1
var squid_num: int = 1


#----Lures-----
var ClownfishLure_amount: int = 0
var CodLure_amount: int = 0
var GoldfishLure_amount: int = 0
var FatChanceLure_amount: int = 0
var TrashBag_amount: int = 0
var SLuck_amount: int = 0
var MLuck_amount: int = 0
var LLuck_amount: int = 0

var fantalure_amount: int = 0
var squidlure_amount: int = 0

#-----Food-----
var apple_amount: int = 0
var bread_amount: int = 0
var cake_amount: int = 0

#-----Special----
var seastone_amount: int = 0

#-------------------Positions-----------------------

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
var Apple_positionX: int
var Apple_positionY: int
var FantaL_positionX: int
var FantaL_positionY: int
var SquidL_positionX: int 
var SquidL_positionY: int
var bread_positionX: int
var bread_positionY: int
var cake_positionX: int
var cake_positionY: int
var seastone_positionX: int
var seastone_positionY: int


#-------------------Equipped/Using-----------------------

var intermediate_equipped: bool = false
var advanced_equipped: bool = false
var basic_equipped: bool = true
var UseLargeLuck: bool = false
var UseMediumLuck: bool = false
var UseSmallLuck: bool = false
var EatApple: bool = false
var eatbread: bool = false
var eatcake: bool = false
var has_clownfish: bool = false
var has_cod: bool = false
var has_goldfish: bool = false
var has_skullfish: bool = false
var has_bluegill: bool = false
var has_fantasia: bool = false
var has_squid: bool = false

#-----------------
#Add Fish
#-----------------


var store_fish: Dictionary = {}
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
	$Node/SeaStone.visible = false
	$Node/Apple.visible = false
	$Node/FantasiaLure.visible = false
	$Node/SquidLure.visible = false
	$Node/Bread.visible = false
	$Node/Cake.visible = false
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
	if get_parent().apples > 0:
		$Node/Apple.visible = true
	if get_parent().fanta_amount > 0:
		$Node/FantasiaLure.visible = true
	if get_parent().squid_amount > 0:
		$Node/SquidLure.visible = true
	if get_parent().cake > 0:
		$Node/Cake.visible = true
	if get_parent().bread > 0:
		$Node/Bread.visible = true
	if get_parent().seastones > 0:
		$Node/SeaStone.visible = true
	if has_clownfish:
		print("Checking for Clownfish")
		show_clownfish()
	if has_cod:
		print("Checking for Cod")
		show_cod()
	if has_goldfish:
		print("Checking for Goldfish")
		show_goldfish()
	if has_skullfish:
		print("Checking for Skullfish")
		show_skullfish()
	if has_bluegill:
		print("Checking for Bluegill")
		show_bluegill()
	if has_fantasia:
		print("Checking for Fantasia")
		show_fantasia()
	if has_squid:
		print("Checking a Squid")
		show_squid()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Coins.text = str(MainCharacter.total_coins)
	
func add_clownfish() -> void:
	var add_fish = $Node/Clownfish.duplicate()
	var label = Label.new()
	var cfX = "Clownfish" +str(cf_num) + "X"
	var cfY = "Clownfish" +str(cf_num) + "Y"
	var cf_name = "Clownfish" +str(cf_num)
	var current_cf = cf_name
	var cfPX: int
	var cfPY: int
	
	has_clownfish = true
	print("clownfish created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[cf_name] = add_fish
	cf_num += 1
	
	
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[cf_name].position.x = (MainCharacter.store_num) * 125 + 75
		cfPX = (MainCharacter.store_num) * 125 + 75
		store_fish[cf_name].position.y = 100
		cfPY = 100
		print("adding clownfish to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[cf_name].position.x = (MainCharacter.store_num) * 125 - 800
		cfPX = (MainCharacter.store_num) * 125 - 800
		store_fish[cf_name].position.y = 250
		cfPY = 250
		print("adding clownfish to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[cf_name].position.x = (MainCharacter.store_num) * 125 - 1675
		cfPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[cf_name].position.y = 385
		cfPY = 385
		print("adding clownfish to row 3")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[cf_name].position.x = (MainCharacter.store_num) * 125 - 2500
		cfPX = (MainCharacter.store_num) * 125 - 2550
		store_fish[cf_name].position.y = 530
		cfPY = 530
		print("adding clownfish to row 4")
	store_fish[cfX] = cfPX
	store_fish[cfY] = cfPY
	print(store_fish[cf_name])
	print(store_fish[cfX])
	print(store_fish[cfY])
	
func show_clownfish() -> void:
	var cf_show_num: int  = 1
	var cf_show: String
	print(store_fish)
	for i in range(28):
		cf_show = "Clownfish" +str(cf_show_num)
		if store_fish.has(cf_show) and is_instance_valid(store_fish[cf_show]):
			print("Clownfish Found")
			store_fish[cf_show].visible = true
		cf_show_num += 1
	cf_show_num = 1

func hide_clownfish() -> void:
	var cf_show_num: int  = 1
	var cf_show: String
	print(store_fish)
	for i in range(28):
		cf_show = "Clownfish" +str(cf_show_num)
		if store_fish.has(cf_show) and is_instance_valid(store_fish[cf_show]):
			print("Clownfish Found")
			store_fish[cf_show].visible = false
		cf_show_num += 1
	cf_show_num = 1
	

func add_cod() -> void:
	var add_fish = $Node/Cod.duplicate()
	var label = Label.new()
	var codX = "Cod" +str(cod_num) + "X"
	var codY = "Cod" +str(cod_num) + "Y"
	var cod_name = "Cod" +str(cod_num)
	var current_cod = cod_name
	var codPX: int
	var codPY: int
	
	has_cod = true
	print("cod created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[cod_name] = add_fish
	cod_num += 1
	
	#-------------Position--------------
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[cod_name].position.x = (MainCharacter.store_num) * 125 + 75
		codPX = (MainCharacter.store_num) * 125 + 75
		store_fish[cod_name].position.y = 100
		codPY = 100
		print("adding cod to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[cod_name].position.x = (MainCharacter.store_num) * 125 - 800
		codPX = (MainCharacter.store_num) * 125 - 800
		store_fish[cod_name].position.y = 250
		codPY = 250
		print("adding cod to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[cod_name].position.x = (MainCharacter.store_num) * 125 - 1675
		codPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[cod_name].position.y = 385
		codPY = 385
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[cod_name].position.x = (MainCharacter.store_num) * 125 - 2550
		codPX = (MainCharacter.store_num) * 125 - 2550 
		store_fish[cod_name].position.y = 530
		codPY = 530
		print("adding cod to row 4")
	store_fish[codX] = codPX
	store_fish[codY] = codPY
	print(store_fish[cod_name])
	print(store_fish[codX])
	print(store_fish[codY])
	
	
func show_cod() -> void:
	var cod_show_num: int  = 1
	var cod_show: String
	print(store_fish)
	for i in range(28):
		cod_show = "Cod" +str(cod_show_num)
		if store_fish.has(cod_show) and is_instance_valid(store_fish[cod_show]):
			print("Cod Found")
			store_fish[cod_show].visible = true
		cod_show_num += 1
	cod_show_num = 1


func hide_cod() -> void:
	var cod_show_num: int  = 1
	var cod_show: String
	print(store_fish)
	for i in range(28):
		cod_show = "Cod" +str(cod_show_num)
		if store_fish.has(cod_show) and is_instance_valid(store_fish[cod_show]):
			print("Cod Found")
			store_fish[cod_show].visible = false
		cod_show_num += 1
	cod_show_num = 1
	
func add_goldfish() -> void:
	var add_fish = $Node/Goldfish.duplicate()
	var label = Label.new()
	var gfX = "Goldfish" +str(gf_num) + "X"
	var gfY = "Goldfish" +str(gf_num) + "Y"
	var gf_name = "Goldfish" +str(gf_num)
	var current_gf = gf_name
	var gfPX: int
	var gfPY: int
	
	has_goldfish = true
	print("Goldfish created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[gf_name] = add_fish
	gf_num += 1
	
	#-------------Position--------------
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[gf_name].position.x = (MainCharacter.store_num) * 125 + 75
		gfPX = (MainCharacter.store_num) * 125 + 75
		store_fish[gf_name].position.y = 100
		gfPY = 100
		print("adding Goldfish to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[gf_name].position.x = (MainCharacter.store_num) * 125 - 800
		gfPX = (MainCharacter.store_num) * 125 - 800
		store_fish[gf_name].position.y = 250
		gfPY = 250
		print("adding Goldfish to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[gf_name].position.x = (MainCharacter.store_num) * 125 - 1675
		gfPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[gf_name].position.y = 385
		gfPY = 385
		print("adding Goldfish to row 3")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[gf_name].position.x = (MainCharacter.store_num) * 125 - 2550
		gfPX = (MainCharacter.store_num) * 125 - 2550
		store_fish[gf_name].position.y = 530
		gfPY = 530
		print("adding Goldfish to row 4")
	store_fish[gfX] = gfPX
	store_fish[gfY] = gfPY
	print(store_fish[gf_name])
	print(store_fish[gfX])
	print(store_fish[gfY])
	
	
func show_goldfish() -> void:
	var gf_show_num: int  = 1
	var gf_show: String
	print(store_fish)
	for i in range(28):
		gf_show = "Goldfish" +str(gf_show_num)
		if store_fish.has(gf_show) and is_instance_valid(store_fish[gf_show]):
			print("Goldfish Found")
			store_fish[gf_show].visible = true
		gf_show_num += 1
	gf_show_num = 1


func hide_goldfish() -> void:
	var gf_show_num: int  = 1
	var gf_show: String
	print(store_fish)
	for i in range(28):
		gf_show = "Goldfish" +str(gf_show_num)
		if store_fish.has(gf_show) and is_instance_valid(store_fish[gf_show]):
			print("Goldfish Found")
			store_fish[gf_show].visible = false
		gf_show_num += 1
	gf_show_num = 1
	
func add_skullfish() -> void:
	var add_fish = $Node/Skullfish.duplicate()
	var label = Label.new()
	var sfX = "Skullfish" +str(sf_num) + "X"
	var sfY = "Skullfish" +str(sf_num) + "Y"
	var sf_name = "Skullfish" +str(sf_num)
	var current_sf = sf_name
	var sfPX: int
	var sfPY: int
	
	has_skullfish = true
	print("Skullfish created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[sf_name] = add_fish
	sf_num += 1
	
	
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[sf_name].position.x = (MainCharacter.store_num) * 125 + 75
		sfPX = (MainCharacter.store_num) * 125 + 75
		store_fish[sf_name].position.y = 100
		sfPY = 100
		print("adding Skullfish to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[sf_name].position.x = (MainCharacter.store_num) * 125 - 800
		sfPX = (MainCharacter.store_num) * 125 - 800
		store_fish[sf_name].position.y = 250
		sfPY = 250
		print("adding Skullfish to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[sf_name].position.x = (MainCharacter.store_num) * 125 - 1675
		sfPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[sf_name].position.y = 385
		sfPY = 385
		print("adding Skullfish to row 3")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[sf_name].position.x = (MainCharacter.store_num) * 125 - 2550
		sfPX = (MainCharacter.store_num) * 125 - 2550
		store_fish[sf_name].position.y = 530
		sfPY = 530
		print("adding Skullfish to row 4")
	store_fish[sfX] = sfPX
	store_fish[sfY] = sfPY
	print(store_fish[sf_name])
	print(store_fish[sfX])
	print(store_fish[sfY])
	
	
func show_skullfish() -> void:
	var sf_show_num: int  = 1
	var sf_show: String
	print(store_fish)
	for i in range(28):
		sf_show = "Skullfish" +str(sf_show_num)
		if store_fish.has(sf_show) and is_instance_valid(store_fish[sf_show]):
			print("Skullfish Found")
			store_fish[sf_show].visible = true
		sf_show_num += 1
	sf_show_num = 1
	
func hide_skullfish() -> void:
	var sf_show_num: int  = 1
	var sf_show: String
	print(store_fish)
	for i in range(28):
		sf_show = "Skullfish" +str(sf_show_num)
		if store_fish.has(sf_show) and is_instance_valid(store_fish[sf_show]):
			print("Skullfish Found")
			store_fish[sf_show].visible = false
		sf_show_num += 1
	sf_show_num = 1
	
func add_bluegill() -> void:
	var add_fish = $Node/Bluegill.duplicate()
	var label = Label.new()
	var bgX = "Bluegill" +str(bg_num) + "X"
	var bgY = "Bluegill" +str(bg_num) + "Y"
	var bg_name = "Bluegill" +str(bg_num)
	var current_bg = bg_name
	var bgPX: int
	var bgPY: int
	
	has_bluegill = true
	print("Bluegill created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[bg_name] = add_fish
	bg_num += 1
	
	#-------------Position--------------
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[bg_name].position.x = (MainCharacter.store_num) * 125 + 75
		bgPX = (MainCharacter.store_num) * 125 + 75
		store_fish[bg_name].position.y = 100
		bgPY = 100
		print("adding Bluegill to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[bg_name].position.x = (MainCharacter.store_num) * 125 - 800
		bgPX = (MainCharacter.store_num) * 125 - 800
		store_fish[bg_name].position.y = 250
		bgPY = 250
		print("adding Bluegill to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[bg_name].position.x = (MainCharacter.store_num) * 125 - 1675
		bgPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[bg_name].position.y = 385
		bgPY = 385
		print("adding Bluegill to row 3")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[bg_name].position.x = (MainCharacter.store_num) * 125 - 2550
		bgPX = (MainCharacter.store_num) * 125 - 2550
		store_fish[bg_name].position.y = 530
		bgPY = 530
		print("adding Bluegill to row 4")
	store_fish[bgX] = bgPX
	store_fish[bgY] = bgPY
	print(store_fish[bg_name])
	print(store_fish[bgX])
	print(store_fish[bgY])
	
	
func show_bluegill() -> void:
	var bg_show_num: int  = 1
	var bg_show: String
	print(store_fish)
	for i in range(28):
		bg_show = "Bluegill" +str(bg_show_num)
		if store_fish.has(bg_show) and is_instance_valid(store_fish[bg_show]):
			print("Bluegill Found")
			store_fish[bg_show].visible = true
		bg_show_num += 1
	bg_show_num = 1


func hide_bluegill() -> void:
	var bg_show_num: int  = 1
	var bg_show: String
	print(store_fish)
	for i in range(28):
		bg_show = "Bluegill" +str(bg_show_num)
		if store_fish.has(bg_show) and is_instance_valid(store_fish[bg_show]):
			print("Bluegill Found")
			store_fish[bg_show].visible = false
		bg_show_num += 1
	bg_show_num = 1
	
func add_fantasia() -> void:
	var add_fish = $Node/Fantasia.duplicate()
	var label = Label.new()
	var fantaX = "Fantasia" +str(fanta_num) + "X"
	var fantaY = "Fantasia" +str(fanta_num) + "Y"
	var fanta_name = "Fantasia" +str(fanta_num)
	var current_fanta = fanta_name
	var fantaPX: int
	var fantaPY: int
	
	has_fantasia = true
	print("Fantasia created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[fanta_name] = add_fish
	fanta_num += 1
	
	#-------------Position--------------
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[fanta_name].position.x = (MainCharacter.store_num) * 125 + 75
		fantaPX = (MainCharacter.store_num) * 125 + 75
		store_fish[fanta_name].position.y = 100
		fantaPY = 100
		print("adding Fantasia to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[fanta_name].position.x = (MainCharacter.store_num) * 125 - 800
		fantaPX = (MainCharacter.store_num) * 125 - 800
		store_fish[fanta_name].position.y = 250
		fantaPY = 250
		print("adding Fantasia to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[fanta_name].position.x = (MainCharacter.store_num) * 125 - 1675
		fantaPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[fanta_name].position.y = 385
		fantaPY = 385
		print("adding Fantasia to row 3")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[fanta_name].position.x = (MainCharacter.store_num) * 125 - 2550
		fantaPX = (MainCharacter.store_num) * 125 - 2550
		store_fish[fanta_name].position.y = 530
		fantaPY = 530
		print("adding Fantasia to row 4")
	store_fish[fantaX] = fantaPX
	store_fish[fantaY] = fantaPY
	print(store_fish[fanta_name])
	print(store_fish[fantaX])
	print(store_fish[fantaY])
	
	
func show_fantasia() -> void:
	var fanta_show_num: int  = 1
	var fanta_show: String
	print(store_fish)
	for i in range(28):
		fanta_show = "Fantasia" +str(fanta_show_num)
		if store_fish.has(fanta_show) and is_instance_valid(store_fish[fanta_show]):
			print("Fantasia Found")
			store_fish[fanta_show].visible = true
		fanta_show_num += 1
	fanta_show_num = 1


func hide_fantasia() -> void:
	var fanta_show_num: int  = 1
	var fanta_show: String
	print(store_fish)
	for i in range(28):
		fanta_show = "Fantasia" +str(fanta_show_num)
		if store_fish.has(fanta_show) and is_instance_valid(store_fish[fanta_show]):
			print("Fantasia Found")
			store_fish[fanta_show].visible = false
		fanta_show_num += 1
	fanta_show_num = 1
	
func add_squid() -> void:
	var add_fish = $Node/Squid.duplicate()
	var label = Label.new()
	var squidX = "Squid" +str(squid_num) + "X"
	var squidY = "Squid" +str(squid_num) + "Y"
	var squid_name = "Squid" +str(squid_num)
	var current_squid = squid_name
	var squidPX: int
	var squidPY: int
	
	has_squid = true
	print("Squid created")
	label.name = "value"
	label.add_theme_font_size_override("font_size",6)
	label.text = str(get_parent().fish_value)
	add_fish.add_child(label)
	$Node.add_child(add_fish)
	store_fish[squid_name] = add_fish
	squid_num += 1
	
	#-------------Position--------------
	if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
		store_fish[squid_name].position.x = (MainCharacter.store_num) * 125 + 75
		squidPX = (MainCharacter.store_num) * 125 + 75
		store_fish[squid_name].position.y = 100
		squidPY = 100
		print("adding Squid to row 1")
	elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
		store_fish[squid_name].position.x = (MainCharacter.store_num) * 125 - 800
		squidPX = (MainCharacter.store_num) * 125 - 800
		store_fish[squid_name].position.y = 250
		squidPY = 250
		print("adding Squid to row 2")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[squid_name].position.x = (MainCharacter.store_num) * 125 - 1675
		squidPX = (MainCharacter.store_num) * 125 - 1675
		store_fish[squid_name].position.y = 385
		squidPY = 385
		print("adding Squid to row 3")
	elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
		store_fish[squid_name].position.x = (MainCharacter.store_num) * 125 - 2550
		squidPX = (MainCharacter.store_num) * 125 - 2550
		store_fish[squid_name].position.y = 530
		squidPY = 530
		print("adding Squid to row 4")
	store_fish[squidX] = squidPX
	store_fish[squidY] = squidPY
	print(store_fish[squid_name])
	print(store_fish[squidX])
	print(store_fish[squidY])
	
	
func show_squid() -> void:
	var squid_show_num: int  = 1
	var squid_show: String
	print(store_fish)
	for i in range(28):
		squid_show = "Squid" +str(squid_show_num)
		if store_fish.has(squid_show) and is_instance_valid(store_fish[squid_show]):
			print("Squid Found")
			store_fish[squid_show].visible = true
		squid_show_num += 1
	squid_show_num = 1

func hide_squid() -> void:
	var squid_show_num: int  = 1
	var squid_show: String
	print(store_fish)
	for i in range(28):
		squid_show = "Squid" +str(squid_show_num)
		if store_fish.has(squid_show) and is_instance_valid(store_fish[squid_show]):
			print("Squid Found")
			store_fish[squid_show].visible = false
		squid_show_num += 1
	squid_show_num = 1
	
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
			$Node/ClownfishLure.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/ClownfishLure.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/ClownfishLure.position.y = 385
		elif MainCharacter.store_num < 21 and MainCharacter.store_num < 29:
			$Node/ClownfishLure.position.x = (MainCharacter.store_num) * 125 - 2550
			$Node/ClownfishLure.position.y = 530
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
		print("decreasing cod lure position")
	elif CodL_positionY > CfL_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if GfL_positionX > CfL_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish lure position")
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
	if Apple_positionX > CfL_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > CfL_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > CfL_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > CfL_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > CfL_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > CfL_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > CfL_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > CfL_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > CfL_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > CfL_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > CfL_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > CfL_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
	var cf_move_num: int  = 1
	var cf_move: String
	var cf_moveX: String
	var cf_moveY: String
	for i in range(28):
		cf_move = "Clownfish" +str(cf_move_num)
		cf_moveX = "Clownfish" +str(cf_move_num) + "X"
		cf_moveY = "Clownfish" +str(cf_move_num) + "Y"
		if store_fish.has(cf_move) and is_instance_valid(store_fish[cf_move]):
			if store_fish[cf_moveX] > CfL_positionX:
				store_fish[cf_move].position.x = store_fish[cf_moveX] - 125
				store_fish[cf_moveX] = store_fish[cf_moveX] -125
				print("decreasing clownfish position")
			elif store_fish[cf_moveY] > CfL_positionY and store_fish[cf_moveX] == 200 and store_fish[cf_moveY] == 250:
				store_fish[cf_move].position.x = 950
				print(store_fish[cf_move].position.x)
				store_fish[cf_moveX] = 950
				print(store_fish[cf_moveX])
				store_fish[cf_move].position.y = 100
				print(store_fish[cf_move].position.y)
				store_fish[cf_moveY] = 100
				print(store_fish[cf_moveY])
			elif store_fish[cf_moveY] > CfL_positionY and store_fish[cf_moveX] == 200 and store_fish[cf_moveY] == 385:
				store_fish[cf_move].position.x = 950
				store_fish[cf_moveX] = 950
				store_fish[cf_move].position.y = 250
				store_fish[cf_moveY] = 250
			elif store_fish[cf_moveY] > CfL_positionY and store_fish[cf_moveX] == 200 and store_fish[cf_moveY] == 530:
				store_fish[cf_move].position.x = 950
				store_fish[cf_moveX] = 950
				store_fish[cf_move].position.y = 385
				store_fish[cf_moveY] = 385
		cf_move_num += 1
	cf_move_num = 1
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
			$Node/CodLure.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/CodLure.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/CodLure.position.y = 385
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
	if Apple_positionX > CodL_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > CodL_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > CodL_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > CodL_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > CodL_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > CodL_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > CodL_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > CodL_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > CodL_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > CodL_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > CodL_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > CodL_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
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
			$Node/GoldfishLure.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/GoldfishLure.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/GoldfishLure.position.y = 385
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
	if Apple_positionX > GfL_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > GfL_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > GfL_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > GfL_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > GfL_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > GfL_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > GfL_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > GfL_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > GfL_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > GfL_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > GfL_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > GfL_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
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
			$Node/FatChance.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/FatChance.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/FatChance.position.y = 385
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
	if Apple_positionX > FC_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > FC_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > FC_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > FC_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > FC_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > FC_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > FC_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > FC_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > FC_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > FC_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
		
func add_trash() -> void:
	TrashBag_amount += 100
	MainCharacter.trash += 99
	print(TrashBag_amount)
	$Node/Trash/Label.text = str(TrashBag_amount)
	if get_parent().trash_amount > 0 and get_parent().trash_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/Trash.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/Trash.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/Trash.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/Trash.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/Trash.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/Trash.position.y = 385
		Trash_positionX = $Node/Trash.position.x
		Trash_positionY = $Node/Trash.position.y
		print("X Position is " +str(Trash_positionX))
		print("Y Position is " +str(Trash_positionY))
	get_parent().trash_amount += 99
	
func remove_trash() -> void:
	print(TrashBag_amount)
	$Node/Trash/Label.text = ''
	$Node/Trash.position.x = 0
	$Node/Trash.position.y = 0
	$Node/Trash.visible = false
	trash_move_back()
	get_parent().trash_remove()
		
		
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
	if Apple_positionX > Trash_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > Trash_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > Trash_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > Trash_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > Trash_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > Trash_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > Trash_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > Trash_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > Trash_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > Trash_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > Trash_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > Trash_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
func update_trash() -> void:
	TrashBag_amount += -1
	print(TrashBag_amount)
	$Node/Trash/Label.text = str(TrashBag_amount)
	
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
			$Node/SLuck.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/SLuck.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/SLuck.position.y = 385
		SLuck_positionX = $Node/SLuck.position.x
		SLuck_positionY = $Node/SLuck.position.y
		print("X Position is " +str(SLuck_positionX))
		print("Y Position is " +str(SLuck_positionY))
		
			
func remove_S_Luck_Potion() -> void:
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
	if Apple_positionX > SLuck_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > SLuck_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > SLuck_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > SLuck_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > SLuck_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > SLuck_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > SLuck_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > SLuck_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > SLuck_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > SLuck_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > SLuck_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > SLuck_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
func add_M_Luck_Potion() -> void:
	MLuck_amount += 1
	print(MLuck_amount)
	$Node/MLuck/Label.text = str(MLuck_amount)
	if get_parent().MLuck > 0 and get_parent().MLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/MLuck.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/MLuck.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/MLuck.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/MLuck.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/MLuck.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/MLuck.position.y = 385
		MLuck_positionX = $Node/MLuck.position.x
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
	if Apple_positionX > MLuck_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > MLuck_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > MLuck_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > MLuck_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > MLuck_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > MLuck_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > MLuck_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > MLuck_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > MLuck_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > MLuck_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > MLuck_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > MLuck_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
func add_L_Luck_Potion() -> void:
	LLuck_amount += 1
	print(LLuck_amount)
	$Node/LLuck/Label.text = str(LLuck_amount)
	if get_parent().LLuck > 0 and get_parent().LLuck < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/LLuck.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/LLuck.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/LLuck.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/LLuck.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/LLuck.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/LLuck.position.y = 385
		LLuck_positionX = $Node/LLuck.position.x
		LLuck_positionY = $Node/LLuck.position.y
		print("X Position is " +str(LLuck_positionX))
		print("Y Position is " +str(LLuck_positionY))
		
func remove_L_Luck_potion() -> void:
	print(LLuck_amount)
	$Node/LLuck/Label.text = ''
	$Node/LLuck.position.x = 0
	$Node/LLuck.position.y = 0
	$Node/LLuck.visible = false
	L_Luck_Potion_Move_Back()
	
	

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
	if Apple_positionX > LLuck_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > LLuck_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > LLuck_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > LLuck_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > LLuck_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > LLuck_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > LLuck_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > LLuck_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > LLuck_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > LLuck_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > LLuck_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > LLuck_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		

func add_apple() -> void:
	apple_amount += 1
	print(apple_amount)
	$Node/Apple/Label.text = str(apple_amount)
	if get_parent().apples > 0 and get_parent().apples < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/Apple.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/Apple.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/Apple.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/Apple.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/Apple.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/Apple.position.y = 385
		Apple_positionX = $Node/Apple.position.x
		Apple_positionY = $Node/Apple.position.y
		print("X Position is " +str(Apple_positionX))
		print("Y Position is " +str(Apple_positionY))
		
func decrease_apple() -> void:
	apple_amount += -1
	print(apple_amount)
	$Node/Apple/Label.text = str(apple_amount)
	
func remove_apple() -> void:
	print(apple_amount)
	$Node/Apple/Label.text = ''
	$Node/Apple.position.x = 0
	$Node/Apple.position.y = 0
	$Node/Apple.visible = false
	apple_move_back()
	
func apple_move_back() -> void:
	if MLuck_positionX > Apple_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > Apple_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > Apple_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > Apple_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > Apple_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > Apple_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > Apple_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > Apple_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > Apple_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > Apple_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > Apple_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > Apple_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > Apple_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > Apple_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > Apple_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX  = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > Apple_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	if FantaL_positionX > Apple_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > Apple_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > Apple_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > Apple_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > Apple_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > Apple_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > Apple_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > Apple_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > Apple_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > Apple_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
func add_fanta_lure() -> void:
	fantalure_amount += 1
	print(fantalure_amount)
	$Node/FantasiaLure/Label.text = str(fantalure_amount)
	if get_parent().fanta_amount > 0 and get_parent().fanta_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/FantasiaLure.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/FantasiaLure.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/FantasiaLure.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/FantasiaLure.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/FantasiaLure.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/FantasiaLure.position.y = 385
		FantaL_positionX = $Node/FantasiaLure.position.x
		FantaL_positionY = $Node/FantasiaLure.position.y
		print("X Position is " +str(FantaL_positionX))
		print("Y Position is " +str(FantaL_positionY))

func decrease_fanta_lure() -> void:
	fantalure_amount += -1
	print(fantalure_amount)
	$Node/FantasiaLure/Label.text = str(fantalure_amount)
	
func remove_fanta_lure() -> void:
	print(fantalure_amount)
	$Node/FantasiaLure/Label.text = ''
	$Node/FantasiaLure.position.x = 0
	$Node/FantasiaLure.position.y = 0
	$Node/FantasiaLure.visible = false
	fantasia_move_back()
	
func fantasia_move_back() -> void:
	if MLuck_positionX > FantaL_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > FantaL_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > FantaL_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > FantaL_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > FantaL_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > FantaL_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > FantaL_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > FantaL_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > FantaL_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > FantaL_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > FantaL_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > FantaL_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > FantaL_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > FantaL_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > FantaL_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX  = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > FantaL_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	if Apple_positionX > FantaL_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > FantaL_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if SquidL_positionX > FantaL_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > FantaL_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > FantaL_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > FantaL_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > FantaL_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > FantaL_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > FantaL_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > FantaL_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
		
func add_squid_lure() -> void:
	squidlure_amount += 1
	print(squidlure_amount)
	$Node/SquidLure/Label.text = str(squidlure_amount)
	if get_parent().squid_amount > 0 and get_parent().squid_amount < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/SquidLure.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/SquidLure.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/SquidLure.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/SquidLure.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/SquidLure.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/SquidLure.position.y = 385
		SquidL_positionX = $Node/SquidLure.position.x
		SquidL_positionY = $Node/SquidLure.position.y
		print("X Position is " +str(SquidL_positionX))
		print("Y Position is " +str(SquidL_positionY))
		
func decrease_squid_lure() -> void:
	squidlure_amount += -1
	print(squidlure_amount)
	$Node/SquidLure/Label.text = str(squidlure_amount)
	
func remove_squid_lure() -> void:
	print(squidlure_amount)
	$Node/SquidLure/Label.text = ''
	$Node/SquidLure.position.x = 0
	$Node/SquidLure.position.y = 0
	$Node/SquidLure.visible = false
	squid_move_back()
	
func squid_move_back() -> void:
	if MLuck_positionX > SquidL_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > SquidL_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > SquidL_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > SquidL_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > SquidL_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > SquidL_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > SquidL_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > SquidL_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > SquidL_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > SquidL_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > SquidL_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > SquidL_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > SquidL_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > SquidL_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > SquidL_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX  = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > SquidL_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	if Apple_positionX > SquidL_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > SquidL_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > SquidL_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > SquidL_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if bread_positionX > SquidL_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > SquidL_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > SquidL_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > SquidL_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > SquidL_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > SquidL_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
	
func add_bread() -> void:
	bread_amount += 1
	print(bread_amount)
	$Node/Bread/Label.text = str(bread_amount)
	if get_parent().bread > 0 and get_parent().bread < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/Bread.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/Bread.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/Bread.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/Bread.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/Bread.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/Bread.position.y = 385
		bread_positionX = $Node/Bread.position.x
		bread_positionY = $Node/Bread.position.y
		print("X Position is " +str(bread_positionX))
		print("Y Position is " +str(bread_positionY))

func decrease_bread() -> void:
	bread_amount += -1
	print(bread_amount)
	$Node/Bread/Label.text = str(bread_amount)
	
func remove_bread() -> void:
	print(bread_amount)
	$Node/Bread/Label.text = ''
	$Node/Bread.position.x = 0
	$Node/Bread.position.y = 0
	$Node/Bread.visible = false
	bread_move_back()
	
func bread_move_back() -> void:
	if MLuck_positionX > bread_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > bread_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > bread_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > bread_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > bread_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > bread_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > bread_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > bread_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > bread_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > bread_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > bread_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > bread_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > bread_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > bread_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > bread_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX  = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > bread_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	if Apple_positionX > bread_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > bread_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > bread_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > bread_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > bread_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > bread_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if cake_positionX > bread_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing cake position")
	elif cake_positionY > bread_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	if seastone_positionX > bread_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > bread_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
	
func add_cake() -> void:
	cake_amount += 1
	print(cake_amount)
	$Node/Cake/Label.text = str(cake_amount)
	if get_parent().cake > 0 and get_parent().cake < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/Cake.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/Cake.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/Cake.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/Cake.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/Cake.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/Cake.position.y = 385
		cake_positionX = $Node/Cake.position.x
		cake_positionY = $Node/Cake.position.y
		print("X Position is " +str(cake_positionX))
		print("Y Position is " +str(cake_positionY))

func decrease_cake() -> void:
	cake_amount += -1
	print(cake_amount)
	$Node/Cake/Label.text = str(cake_amount)
	
func remove_cake() -> void:
	print(cake_amount)
	$Node/Cake/Label.text = ''
	$Node/Cake.position.x = 0
	$Node/Cake.position.y = 0
	$Node/Cake.visible = false
	cake_move_back()
	
func cake_move_back() -> void:
	if MLuck_positionX > cake_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > cake_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > cake_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > cake_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > cake_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > cake_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > cake_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > cake_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > cake_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > cake_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > cake_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > cake_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > cake_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > cake_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > cake_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX  = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > cake_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	if Apple_positionX > cake_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > cake_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > cake_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > cake_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > cake_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > cake_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > cake_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > cake_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if seastone_positionX > cake_positionX:
		$Node/SeaStone.position.x = seastone_positionX - 125
		seastone_positionX = seastone_positionX - 125
		print("decreasing SeaStone position")
	elif seastone_positionY > cake_positionY and seastone_positionX == 200:
		$Node/SeaStone.position.x = 950
		seastone_positionX = 950
		$Node/SeaStone.position.y = 100
		seastone_positionY = 100
	
	
func add_seastone() -> void:
	seastone_amount += 1
	print(seastone_amount)
	$Node/SeaStone/Label.text = str(seastone_amount)
	if get_parent().seastones > 0 and get_parent().seastones < 2:
		if MainCharacter.store_num > 0 and MainCharacter.store_num < 8 :
			$Node/SeaStone.position.x = (MainCharacter.store_num) * 125 + 75
			$Node/SeaStone.position.y = 100
		elif MainCharacter.store_num > 7 and MainCharacter.store_num < 15:
			$Node/SeaStone.position.x = (MainCharacter.store_num) * 125 - 800
			$Node/SeaStone.position.y = 250
		elif MainCharacter.store_num > 14 and MainCharacter.store_num < 22:
			$Node/SeaStone.position.x = (MainCharacter.store_num) * 125 - 1675
			$Node/SeaStone.position.y = 385
		seastone_positionX = $Node/SeaStone.position.x
		seastone_positionY = $Node/SeaStone.position.y
		print("X Position is " +str(seastone_positionX))
		print("Y Position is " +str(seastone_positionY))
	
func remove_seastone() -> void:
	print(seastone_amount)
	$Node/SeaStone/Label.text = ''
	$Node/SeaStone.position.x = 0
	$Node/SeaStone.position.y = 0
	$Node/SeaStone.visible = false
	seastone_move_back()
	
func seastone_move_back() -> void:
	if MLuck_positionX > seastone_positionX:
		$Node/MLuck.position.x = MLuck_positionX - 125
		MLuck_positionX = MLuck_positionX - 125
		print("decreasing M Luck position")
	elif MLuck_positionY > seastone_positionY and MLuck_positionX == 200:
		$Node/MLuck.position.x = 950
		MLuck_positionX = 950
		$Node/MLuck.position.y = 100
		MLuck_positionY = 100
	if SLuck_positionX > seastone_positionX:
		$Node/SLuck.position.x = SLuck_positionX - 125
		SLuck_positionX = SLuck_positionX - 125
		print("decreasing S Luck position")
	elif SLuck_positionY > seastone_positionY and SLuck_positionX == 200:
		$Node/SLuck.position.x = 950
		SLuck_positionX = 950
		$Node/SLuck.position.y = 100
		SLuck_positionY = 100
	if Trash_positionX > seastone_positionX:
		$Node/Trash.position.x = Trash_positionX - 125
		Trash_positionX = Trash_positionX - 125
		print("decreasing Trash position")
	elif Trash_positionY > seastone_positionY and Trash_positionX == 200:
		$Node/Trash.position.x = 950
		Trash_positionX = 950
		$Node/Trash.position.y = 100
		Trash_positionY = 100
	if FC_positionX > seastone_positionX:
		$Node/FatChance.position.x = FC_positionX - 125
		FC_positionX = FC_positionX - 125
		print("decreasing FC position")
	elif FC_positionY > seastone_positionY and FC_positionX == 200:
		$Node/FatChance.position.x = 950
		FC_positionX = 950
		$Node/FatChance.position.y = 100
		FC_positionY = 100
	if GfL_positionX > seastone_positionX:
		$Node/GoldfishLure.position.x = GfL_positionX - 125
		GfL_positionX = GfL_positionX - 125
		print("decreasing goldfish_position")
	elif GfL_positionY > seastone_positionY and GfL_positionX == 200:
		$Node/GoldfishLure.position.x = 950
		GfL_positionX = 950
		$Node/GoldfishLure.position.y = 100
		GfL_positionY = 100
	if CodL_positionX > seastone_positionX:
		$Node/CodLure.position.x = CodL_positionX - 125
		CodL_positionX = CodL_positionX - 125
		print("decreasing cod position")
	elif CodL_positionY > seastone_positionY and CodL_positionX == 200:
		$Node/CodLure.position.x = 950
		CodL_positionX = 950
		$Node/CodLure.position.y = 100
		CodL_positionY = 100
	if CfL_positionX > seastone_positionX:
		$Node/ClownfishLure.position.x = CfL_positionX - 125
		CfL_positionX = CfL_positionX - 125
		print("decreasing clownfish position")
	elif CfL_positionY > seastone_positionY and CfL_positionX == 200:
		$Node/ClownfishLure.position.x = 950
		CfL_positionX = 950
		$Node/ClownfishLure.position.y = 100
		CfL_positionY = 100
	if LLuck_positionX > seastone_positionX:
		$Node/LLuck.position.x = LLuck_positionX - 125
		LLuck_positionX  = LLuck_positionX - 125
		print("decreasing L Luck position")
	elif LLuck_positionY > seastone_positionY and LLuck_positionX == 200:
		$Node/LLuck.position.x = 950
		LLuck_positionX = 950
		$Node/LLuck.position.y = 100
		LLuck_positionY = 100
	if Apple_positionX > seastone_positionX:
		$Node/Apple.position.x = Apple_positionX - 125
		Apple_positionX = Apple_positionX - 125
		print("decreasing apple position")
	elif Apple_positionY > seastone_positionY and Apple_positionX == 200:
		$Node/Apple.position.x = 950
		Apple_positionX = 950
		$Node/Apple.position.y = 100
		Apple_positionY = 100
	if FantaL_positionX > seastone_positionX:
		$Node/FantasiaLure.position.x = FantaL_positionX - 125
		FantaL_positionX = FantaL_positionX - 125
		print("decreasing fantasia position")
	elif FantaL_positionY > seastone_positionY and FantaL_positionX == 200:
		$Node/FantasiaLure.position.x = 950
		FantaL_positionX = 950
		$Node/FantasiaLure.position.y = 100
		FantaL_positionY = 100
	if SquidL_positionX > seastone_positionX:
		$Node/SquidLure.position.x = SquidL_positionX - 125
		SquidL_positionX = SquidL_positionX - 125
		print("decreasing squid position")
	elif SquidL_positionY > seastone_positionY and SquidL_positionX == 200:
		$Node/SquidLure.position.x = 950
		SquidL_positionX = 950
		$Node/SquidLure.position.y = 100
		SquidL_positionY = 100
	if bread_positionX > seastone_positionX:
		$Node/Bread.position.x = bread_positionX - 125
		bread_positionX = bread_positionX - 125
		print("decreasing bread position")
	elif bread_positionY > seastone_positionY and bread_positionX == 200:
		$Node/Bread.position.x = 950
		bread_positionX = 950
		$Node/Bread.position.y = 100
		bread_positionY = 100
	if cake_positionX > seastone_positionX:
		$Node/Cake.position.x = cake_positionX - 125
		cake_positionX = cake_positionX - 125
		print("decreasing SeaStone position")
	elif cake_positionY > seastone_positionY and cake_positionX == 200:
		$Node/Cake.position.x = 950
		cake_positionX = 950
		$Node/Cake.position.y = 100
		cake_positionY = 100
	
	
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
	$Node/Apple.visible = false
	$Node/SeaStone.visible = false
	$Node/FantasiaLure.visible = false
	$Node/SquidLure.visible = false
	$Node/Bread.visible = false
	$Node/Cake.visible = false
	if has_clownfish:
		hide_clownfish()
		print("Checking for Clownfish")
	if has_cod:
		print("Checking for Cod")
		hide_cod()
	if has_goldfish:
		print("Checking for Goldfish")
		hide_goldfish()
	if has_skullfish:
		print("Checking for Skullfish")
		hide_skullfish()
	if has_bluegill:
		print("Checking for Bluegill")
		hide_bluegill()
	if has_fantasia:
		print("Checking for Fantasia")
		hide_fantasia()
	if has_squid:
		print("Checking a Squid")
		hide_squid()
func _on_cf_l_button_pressed() -> void:
	get_parent().select_clownfish_lure()
	get_parent().unselect_cod_lure()
	get_parent().unselect_goldfish_lure()
	get_parent().unselect_fanta_lure()
	get_parent().unselect_squid_lure()
	$BaitSelected.text = "Clownfish Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()
	

func _on_cod_l_button_pressed() -> void:
	get_parent().select_cod_lure()
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_goldfish_lure()
	get_parent().unselect_fanta_lure()
	get_parent().unselect_squid_lure()
	$BaitSelected.text = "Cod Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()


func _on_gf_l_button_pressed() -> void:
	get_parent().select_goldfish_lure()
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_cod_lure()
	get_parent().unselect_fanta_lure()
	get_parent().unselect_squid_lure()
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
	get_parent().unselect_fanta_lure()
	get_parent().unselect_squid_lure()
	$BaitSelected.text = "Unselected All Lures and Baits"


func _on_s_luck_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Use.text = 'Use'
	$UseBackground/Back.text = 'Back'
	$UseBackground/Label.text = "Do you want to use small luck potion to boost your luck for the next 2 casts?"
	UseSmallLuck = true
	UseLargeLuck = false
	UseMediumLuck = false
	EatApple = false
	eatbread = false
	eatcake = false

func _on_m_luck_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Use.text = 'Use'
	$UseBackground/Back.text = 'Back'
	$UseBackground/Label.text = "Do you want to use medium luck potion to boost your luck for the next 6 casts?"
	UseMediumLuck = true
	UseLargeLuck = false
	UseSmallLuck = false
	EatApple = false
	eatbread = false
	eatcake = false
	
func _on_l_luck_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Use.text = 'Use'
	$UseBackground/Back.text = 'Back'
	$UseBackground/Label.text = "Do you want to use large luck potion to boost your luck for the next 20 casts?"
	UseLargeLuck = true
	UseMediumLuck = false
	UseSmallLuck = false
	EatApple = false
	eatbread = false
	eatcake = false


func _on_use_pressed() -> void:
	$UseBackground.set_process(false)
	$UseBackground.set_process_input(false)
	$UseBackground.position.x = -400
	if UseLargeLuck:
		get_parent().luck += 20
		LLuck_amount += -1
		get_parent().LLuck += -1
		if get_parent().LLuck <= 0:
			get_parent().L_Luck_Potion_remove()
		UseLargeLuck = false
		print("Luck is " + str(get_parent().luck))
	if UseMediumLuck:
		get_parent().luck += 6
		MLuck_amount += -1
		get_parent().MLuck += -1
		if get_parent().MLuck <= 0:
			get_parent().M_Luck_Potion_remove()
		UseMediumLuck = false
		print("Luck is " + str(get_parent().luck))
	if UseSmallLuck:
		get_parent().luck += 2
		SLuck_amount += -1
		get_parent().SLuck += -1
		if get_parent().SLuck <= 0:
			get_parent().S_Luck_Potion_remove()
		UseSmallLuck = false
		print("Luck is " + str(get_parent().luck))
	if EatApple:
		get_parent().apple_ate()
		get_parent().apples_decrease()
		if get_parent().apples <= 0:
			get_parent().apples_remove()
		EatApple = false
	if eatbread:
		get_parent().bread_ate()
		get_parent().bread_decrease()
		if get_parent().bread <= 0:
			get_parent().bread_remove()
		eatbread = false
	if eatcake:
		get_parent().cake_ate()
		get_parent().cake_decrease()
		if get_parent().cake <= 0:
			get_parent().cake_remove()
		eatcake = false

func _on_back_pressed() -> void:
	$UseBackground.set_process(false)
	$UseBackground.set_process_input(false)
	$UseBackground.position.x = -400
	$UseBackground/Use.text = ''
	$UseBackground/Back.text = ''
	$UseBackground/Label.text = ''
	UseLargeLuck = false
	UseMediumLuck = false
	UseSmallLuck = false
	EatApple = false
	eatbread = false
	eatcake = false

func _on_apple_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Label.text = "Do you want to eat apple?"
	$UseBackground/Use.text = 'Yes'
	$UseBackground/Back.text = 'No'
	UseLargeLuck = false
	UseMediumLuck = false
	UseSmallLuck = false
	EatApple = true
	eatbread = false
	eatcake = false

func _on_bread_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Label.text = "Do you want to eat bread?"
	$UseBackground/Use.text = 'Yes'
	$UseBackground/Back.text = 'No'
	UseLargeLuck = false
	UseMediumLuck = false
	UseSmallLuck = false
	EatApple = false
	eatcake = false
	eatbread = true


func _on_cake_button_pressed() -> void:
	$UseBackground.visible = true
	$UseBackground.position.x = 400
	$UseBackground/Label.text = "Do you want to eat bread?"
	$UseBackground/Use.text = 'Yes'
	$UseBackground/Back.text = 'No'
	UseLargeLuck = false
	UseMediumLuck = false
	UseSmallLuck = false
	EatApple = false
	eatcake = true
	eatbread = false


func _on_fanta_l_button_pressed() -> void:
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_cod_lure()
	get_parent().unselect_goldfish_lure()
	get_parent().select_fanta_lure()
	get_parent().unselect_squid_lure()
	$BaitSelected.text = "Fantasia Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()


func _on_squid_l_button_pressed() -> void:
	get_parent().unselect_clownfish_lure()
	get_parent().unselect_cod_lure()
	get_parent().unselect_goldfish_lure()
	get_parent().unselect_fanta_lure()
	get_parent().select_squid_lure()
	$BaitSelected.text = "Squid Lure Selected"
	$BaitSelected/BaitSelectedTimer.start()
