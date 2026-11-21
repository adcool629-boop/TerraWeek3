extends CharacterBody2D


const SPEED = 300.0
var LastDirection: Vector2 = Vector2.RIGHT
var fishing: bool = false
var cast_finished: bool = false
var casting: bool = false
var reeling: bool = false
var shopping: bool = false
var perfect: bool = false
var good: bool = false
var meh: bool = false
var bad: bool = false
var inv_closed: bool = true
var value: int = 0
var luck: int = 0
var first_time = true

#-----------------------------------------------
#Baits
#-----------------------------------------------

var CfL_amount: int = 0
var CodL_amount: int = 0
var GfL_amount: int = 0
var FC_amount: int = 0
var trash_amount: int = 0
var fanta_amount: int = 0
var squid_amount: int = 0
var seastones: int = 0
#------------------Potions-------------------

var SLuck: int = 0
var MLuck: int = 0
var LLuck: int = 0

#------------------Food-------------------

var apples: int = 0
var cake: int = 0
var bread: int = 0

#-----------------------------------------------
#store fish
#-----------------------------------------------

var store_clownfish: bool = false
var store_cod: bool = false
var store_goldfish: bool = false
var fish_value: int

#-----------------------------------------------
#Rods
#-----------------------------------------------

var IRod: bool = false
var ARod: bool = false
var GRod: bool = false


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fishing_detector: RayCast2D = $FishingDetector

func _process(delta: float) -> void:
	
	if MainCharacter.PickedUp:
		MainCharacter.PickedUp = false
		if trash_amount == 0:
			trash_add()
		elif trash_amount > 0:
			get_child(15).add_trash()
		MainCharacter.PickedUp = false
	if MainCharacter.game_over:
		LastDirection = Vector2.RIGHT
		fishing = false
		cast_finished = false
		casting = false
		reeling = false
		shopping= false
		perfect = false
		good = false
		meh = false
		bad = false
		inv_closed = true
		value = 0
		luck = 0
		first_time = true

		#-----------------------------------------------
		#Baits
		#-----------------------------------------------
		CfL_amount = 0
		CodL_amount = 0
		GfL_amount = 0
		FC_amount = 0
		trash_amount = 0
		fanta_amount = 0
		squid_amount = 0
		seastones = 0
		#------------------Potions-------------------

		SLuck = 0
		MLuck = 0
		LLuck = 0

		#------------------Food-------------------

		apples = 0
		cake = 0
		bread = 0
		#-----------------------------------------------
		#store fish
		#-----------------------------------------------
		store_clownfish = false
		store_cod = false
		store_goldfish = false

		#-----------------------------------------------
		#Rods
		#-----------------------------------------------
		IRod = false
		ARod = false
		GRod = false
		get_tree().reload_current_scene()
		
		
func _physics_process(delta: float) -> void:
	if fishing or shopping:
		velocity = Vector2.ZERO
		$Walking.playing = false
		move_and_slide()
		return
	process_movement()
	process_animation()
	move_and_slide()
	
func process_movement() -> void:
	
	
	var direction := Input.get_vector("Left","Right","Down","Up")
	
	if direction != Vector2.ZERO:
		
		velocity = direction * SPEED
		LastDirection = direction
		fishing_detector.target_position = direction * 32.0
		$PShopDetector.target_position = direction * 32.0
		$NPCDetector.target_position = direction * 32.0
		$TrashDetector.target_position = direction * 5
		$FShopDetector.target_position = direction * 32.0
		$FShopDetector2.target_position = direction * 32.0
		$MShopDetector.target_position = direction * 32.0
	else:
		velocity = Vector2.ZERO
		
func process_animation() -> void:
	
	if velocity != Vector2.ZERO:
		if not $Walking.playing:
			$Walking.playing = true
		play_animation('Walk', LastDirection)
		
	else:
		if $Walking.playing:
			$Walking.playing = false
		play_animation('Idle', LastDirection)
		
		
		

func play_animation(prefix:String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + 'Right')
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + 'Left')
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + 'Down')
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + 'Up')

#-----------------------------------------------
#Fishing
#-----------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed('Fishing') and not fishing:
		if fishing_detector.is_colliding():
			start_fishing()
		else:
			$FishError.text = ('Get closer and face the water')
			$ErrorTimer.start()
			
	if $FShopDetector.is_colliding():
		$ShopHelp.text = ('Press F to Interact')
		if $FShopDetector.is_colliding() and event.is_action_pressed('Interact'):
			$FishingShop.set_process(true)
			$FishingShop.set_process_input(true)
			$FishingShop.visible = true
			shopping = true
	elif not $FShopDetector.is_colliding():
			$ShopHelp.text = ("")
	if $PShopDetector.is_colliding():
		$ShopHelp.text = ('Press F to Interact')
		if $PShopDetector.is_colliding() and event.is_action_pressed('Interact'):
			$PotionShop.set_process(true)
			$PotionShop.set_process_input(true)
			$PotionShop.visible = true
			shopping = true
	
	if $NPCDetector.is_colliding():
		$ShopHelp.text = ('Press F to Interact')
	if $NPCDetector.is_colliding() and event.is_action_pressed('Interact'):
		$NI_Dialogue.set_process(true)
		$NI_Dialogue.set_process_input(true)
		$NI_Dialogue.visible = true
		shopping = true
		get_child(19).text_one()
	if $TrashDetector.is_colliding():
		$ShopHelp.text = ('Press F to Pick Up')
		if $TrashDetector.is_colliding() and event.is_action_pressed('Interact'):
			MainCharacter.InReach = true
			print("Picking Up")
			
	if $FShopDetector2.is_colliding():
		$ShopHelp.text = ('Press F to Interact')
		if $FShopDetector2.is_colliding() and event.is_action_pressed('Interact'):
			if first_time:
				first_time = false
				$FirstTime.visible = true
				$FirstTime.set_process(true)
				$FirstTime.set_process_input(true)
				get_child(23).text_one()
			elif not first_time:
				$FishingShop2.visible = true
				$FishingShop2.set_process(true)
				$FishingShop2.set_process_input(true)
			shopping = true
	if $MShopDetector.is_colliding():
		$ShopHelp.text = ('Press F to Interact')
		if $MShopDetector.is_colliding() and event.is_action_pressed("Interact"):
			$FoodMarket.set_process(true)
			$FoodMarket.set_process_input(true)
			$FoodMarket.visible = true
			shopping = true
	if inv_closed:
		if event.is_action_pressed('OpenInventory'):
			get_child(15).openinv()
			#get_child(15).add_clownfish()
			
	
#Making the fishing more organized
func start_fishing() -> void:
	$FishingSC.visible = true
	$FishingSC.set_process(true)
	$FishingSC.set_process_input(true)
	fishing = true
	casting = true
	process_cast()
	
func cast_end() -> void:
	$FishingSC.visible = false
	$FishingSC.set_process(false)
	$FishingSC.set_process_input(false)
	casting = false
	cast_finished = true
	$CastEnd.play()
	process_wait()
	
	

func process_cast() -> void:
	if casting:
		play_cast('Cast', LastDirection)
func play_cast(prefix:String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + 'Right')
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + 'Left')
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + 'Down')
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + 'Up')
	
func process_wait() -> void:
	if cast_finished:
		play_wait('Wait', LastDirection)
		wait_time()
func play_wait(prefix:String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + 'Right')
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + 'Left')
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + 'Down')
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + 'Up')

func _on_error_timer_timeout() -> void:
	$FishError.text = ("")
	
#-----------------------------------------------
#Fishing Mini Games
#-----------------------------------------------
func wait_time() -> void:
	var waiting = randf() * 3
	if ARod:
		waiting = waiting * 1/4
		$WaitTimer.wait_time = waiting
		$WaitTimer.start()
		print("Wait Time Decreased by 1/4th")
	elif IRod:
		waiting = waiting * 1/2
		$WaitTimer.wait_time = waiting
		$WaitTimer.start()
		print("Wait Time halved")
	else:
		$WaitTimer.wait_time = waiting
		$WaitTimer.start()

func _on_wait_timer_timeout() -> void:
	print("Mini-Game Start")
	reeling = true 
	process_reel()
	$FishHooked.text = ("Fish Hooked!")
	$FishHooked/FishHookedTimer.start()
	
func minigame_select() -> void:
	# When more minigames are made use this to randomly select one.
	var minigame = randf()
	if minigame > 1:
		quick_time_start()
	elif minigame < 1:
		skill_check_start()
	elif minigame == 1:
		minigame_select()
func quick_time_start() -> void:
	if reeling:
		$MiniGame1.visible = true
		$MiniGame1.set_process(true)
		$MiniGame1.set_process_input(true)
		get_child(7).IRod_progress_timer()
		get_child(7).ARod_progress_timer()
		get_child(7).minigame_start()
		print("quick time start")
func quick_time_end() -> void:
		reeling = false
		fishing = false
		$MiniGame1.visible = false
		$MiniGame1.set_process(false)
		$MiniGame1.set_process_input(false)
		$Reeling.playing = false
func skill_check_start() -> void:
	if reeling:
		$MiniGame2.visible = true
		$MiniGame2.set_process(true)
		$MiniGame2.set_process_input(true)
		get_child(13).minigame_start()
	
func skill_check_end() -> void:
	reeling = false
	fishing = false
	$MiniGame2.visible = false
	$MiniGame2.set_process(false)
	$MiniGame2.set_process_input(false)
	$Reeling.playing = false
func process_reel() -> void:
	if reeling:
		$Reeling.playing = true
		play_reel('Reel', LastDirection)
		
func play_reel(prefix:String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + 'Right')
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + 'Left')
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + 'Down')
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + 'Up')
		
func fish_caught() -> void:
	get_child(9).pick_fish()
	

#-----------------------------------------------
#Shops
#-----------------------------------------------
func done_shopping() -> void:
	$FishingShop.visible = false
	$FishingShop.set_process(false)
	$FishingShop.set_process_input(false)
	$PotionShop.visible = false
	$PotionShop.set_process(false)
	$PotionShop.set_process_input(false)
	$FoodMarket.visible = false
	$FoodMarket.set_process(false)
	$FoodMarket.set_process_input(false)
	$FishingShop2.visible = false
	$FishingShop2.set_process(false)
	$FishingShop2.set_process_input(false)
	shopping = false

#-----------------------------------------------
func _on_fish_hooked_timer_timeout() -> void:
	$FishHooked.text = ("")
	minigame_select()

#-----------------------------------------------
#Inventory
#-----------------------------------------------
func clownfish_lure_add() -> void:
	print(CfL_amount)
	if CfL_amount > 0:
		get_child(15).add_clownfish_lure()
func clownfish_lure_decrease() -> void:
	get_child(15).decrease_clownfish_lure()
func clownfish_lure_remove() -> void:
	if CfL_amount == 0:
		MainCharacter.store_num += -1
		get_child(15).remove_clownfish_lure()
func select_clownfish_lure() -> void:
	get_child(9).clownfish_lure = true
func unselect_clownfish_lure() -> void:
	get_child(9).clownfish_lure = false
	
func cod_lure_add() -> void:
	if CodL_amount > 0:
		get_child(15).add_cod_lure()
func cod_lure_decrease() -> void:
	get_child(15).decrease_cod_lure()
func cod_lure_remove() -> void:
	if CodL_amount == 0:
		MainCharacter.store_num += -1
		get_child(15).remove_cod_lure()
func select_cod_lure() -> void:
	get_child(9).cod_lure = true
func unselect_cod_lure() -> void:
	get_child(9).cod_lure = false
	
func goldfish_lure_add() -> void:
	if GfL_amount > 0:
		get_child(15).add_goldfish_lure()
func goldfish_lure_decrease() -> void:
	get_child(15).decrease_goldfish_lure()
func goldfish_lure_remove() -> void:
	if GfL_amount == 0:
		MainCharacter.store_num += -1
		get_child(15).remove_goldfish_lure()
func select_goldfish_lure() -> void:
	get_child(9).goldfish_lure = true 
func unselect_goldfish_lure() -> void:
	get_child(9).goldfish_lure = false
	
func fc_lure_add() -> void:
	if FC_amount > 0:
		get_child(15).add_fc_lure() 
func fc_decrease() -> void:
	get_child(15).decrease_fc()
func fc_lure_remove() -> void:
	if FC_amount == 0:
		MainCharacter.store_num += -1
		get_child(15).remove_fc_lure()
func select_fatchance() -> void:
	get_child(9).FatChance = true
func unselect_fatchance() -> void:
	get_child(9).FatChance = false

func trash_add() -> void:
	trash_amount += 1
	MainCharacter.trash += 1
	if MainCharacter.trash > 0 and MainCharacter.trash < 2:
		MainCharacter.store_num += 1
	get_child(15).add_trash()
	
func trash_remove() -> void:
	if trash_amount == 0:
		get_child(15).remove_trash()
		MainCharacter.store_num += -1
func trash_update() -> void:
	get_child(15).update_trash()
	
func advanced_rod() -> void:
	get_child(15).advanced_equipped = true
	get_child(15).basic_equipped = false
	get_child(15).intermediate_equipped = false
	
func intermediate_rod() -> void:
	get_child(15).intermediate_equipped = true
	get_child(15).advanced_equipped = false
	get_child(15).basic_equipped = false

func S_Luck_Potion_add() -> void:
	get_child(15).add_S_Luck_Potion()

func S_Luck_Potion_decrease() -> void:
	get_child(15).decrease_S_Luck_Potion()
	
func S_Luck_Potion_remove() -> void:
	if SLuck == 0:
		get_child(15).remove_S_Luck_Potion()
		MainCharacter.store_num += -1
	
	
func M_Luck_Potion_add() -> void:
	get_child(15).add_M_Luck_Potion()

func M_Luck_Potion_decrease() -> void:
	MLuck += -1
	get_child(15).decrease_M_Luck_Potion()
	
func M_Luck_Potion_remove() -> void:
	if MLuck == 0:
		get_child(15).remove_M_Luck_potion()
		MainCharacter.store_num += -1
	

func L_Luck_Potion_add() -> void:
	get_child(15).add_L_Luck_Potion()

func L_Luck_Potion_decrease() -> void:
	LLuck += -1
	get_child(15).decrease_L_Luck_Potion()
	
func L_Luck_Potion_remove() -> void:
	if LLuck == 0:
		get_child(15).remove_L_Luck_Potion()
		MainCharacter.store_num += -1
		
func apples_add() -> void:
	get_child(15).add_apple()
	
func apples_decrease() -> void:
	apples += -1
	get_child(15).decrease_apple()
	
func apple_ate() -> void:
	print(get_children(27))
	print(get_child_count())
	$Hunger.eating_apple()

func apples_remove() -> void:
	if apples == 0:
		get_child(15).remove_apple()
		MainCharacter.store_num += -1
		
func fanta_lure_add() -> void:
	get_child(15).add_fanta_lure()
	
func fanta_lure_remove() -> void:
	if fanta_amount == 0:
		get_child(15).remove_fanta_lure()
		MainCharacter.store_num += -1
	
func fanta_decrease() -> void:
	fanta_amount += -1
	get_child(15).decrease_fanta_lure()
	
func select_fanta_lure() -> void:
	get_child(9).fanta_lure = true
	
func unselect_fanta_lure() -> void:
	get_child(9).fanta_lure = false
	
func squid_lure_add() -> void:
	get_child(15).add_squid_lure()

func squid_lure_remove() -> void:
	if squid_amount == 0:
		get_child(15).remove_squid_lure()
		MainCharacter.store_num += -1
		
func squid_decrease() -> void:
	squid_amount += -1
	get_child(15).decrease_squid_lure()
	
func select_squid_lure() -> void:
	get_child(9).squid_lure = true

func unselect_squid_lure() -> void:
	get_child(9).squid_lure = false
func bread_add() -> void:
	get_child(15).add_bread()
	
func bread_remove() -> void:
	if bread == 0:
		get_child(15).remove_bread()
		MainCharacter.store_num += -1
		
func bread_ate() -> void:
	$Hunger.eating_bread()
	
func bread_decrease() -> void:
	bread += -1
	get_child(15).decrease_bread()
	
func cake_add() -> void:
	get_child(15).add_cake()

func cake_remove() -> void:
	if cake == 0:
		get_child(15).remove_cake()
		MainCharacter.store_num += -1
		
func cake_ate() -> void:
	$Hunger.eating_cake()
	luck += 5

func cake_decrease() -> void:
	cake += -1
	get_child(15).decrease_cake()
	
func seastone_add() -> void:
	seastones += 1
	get_child(15).add_seastone()

func clownfish_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_clownfish()

func cod_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_cod()
	
func goldfish_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_goldfish()
	
func skullfish_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_skullfish()

func bluegill_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_bluegill()
	
func fantasia_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_fantasia()
	
func squid_caught() -> void:
	fish_value = get_child(9).total
	get_child(15).add_squid()
