extends Node2D
var clownfish_base = 25
var cod_base = 25
var goldfish_base = 15
var skullfish_base = 50
var bluegill_base = 100
var fantasia_base = 500
var squid_base = 1000
var total: float = 0 
var player = get_parent()
var clownfish_lure = false
var cod_lure = false
var goldfish_lure = false
var FatChance = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Cod.visible = false
	$Clownfish.visible = false
	$Goldfish.visible = false
	$Skullfish.visible = false
	$Bluegill.visible = false
	$Trash.visible = false
	$Fantasia.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func pick_fish() -> void:
	var pick = randf()
	#-----------------------------------------------------------------------------------------------------------------------------
	#------------------------------------Intermediate Rod-------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------------
	if get_parent().IRod:
		if get_parent().CfL_amount > 0 and clownfish_lure:
			get_parent().CfL_amount += -1
			get_parent().clownfish_lure_decrease()
			if get_parent().CfL_amount == 0:
				get_parent().clownfish_lure_remove()
			print("Clownfish Lure Used")
			if pick > 0.5 and pick < 0.95:
				$Clownfish.visible = true
				clownfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Clownfish!')
			if pick > 0.10 and pick < 0.15 :
				$Cod.visible = true
				cod_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Cod!')
			if pick > 0.05 and pick < 0.10:
				$Goldfish.visible = true
				goldfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Goldfish!')
			if pick < 0.05:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.15 and pick < 0.40:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.4 and pick < 0.5:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
			
			
		elif get_parent().CodL_amount > 0 and cod_lure:
			get_parent().CodL_amount += -1
			get_parent().cod_lure_decrease()
			if get_parent().CodL_amount == 0:
				get_parent().cod_lure_remove()
			print("Cod Lure Used")
			if pick < 0.05:
				$Clownfish.visible = true
				clownfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Clownfish!')
			if pick > 0.5 and pick < 0.95:
				$Cod.visible = true
				cod_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Cod!')
			if pick > 0.10 and pick < 0.15:
				$Goldfish.visible = true
				goldfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Goldfish!')
			if pick > 0.05 and pick < 0.10:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.15 and pick < 0.40:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.4 and pick < 0.5:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
			
			
		elif get_parent().GfL_amount > 0 and goldfish_lure:
			get_parent().GfL_amount += -1
			get_parent().goldfish_lure_decrease()
			if get_parent().GfL_amount == 0:
				get_parent().goldfish_lure_remove()
			print("Goldfish Lure Used")
			if pick > 0.05 and pick < 0.10:
				$Clownfish.visible = true
				clownfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Clownfish!')
			if pick < 0.05:
				$Cod.visible = true
				cod_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Cod!')
			if pick > 0.5 and pick < 0.95:
				$Goldfish.visible = true
				goldfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Goldfish!')
			if pick > 0.10 and pick < 0.15 :
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.15 and pick < 0.40:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.4 and pick < 0.5:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
			
		else:
			if pick < 0.05:
				$Clownfish.visible = true
				clownfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Clownfish!')
				#player.clownfish_add()
			if pick > 0.1 and pick < 0.15:
				$Cod.visible = true
				cod_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Cod!')
			if pick > 0.15 and pick < 0.20:
				$Goldfish.visible = true
				goldfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Goldfish!')
			if pick > 0.05 and pick < 0.1:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.20 and pick < 0.60:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.6 and pick < 0.95:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
	#-----------------------------------------------------------------------------------------------------------------------------
	#------------------------------------Advanced Rod-----------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------------
	elif get_parent().ARod:
		if get_parent().CfL_amount > 0 and clownfish_lure:
			get_parent().CfL_amount += -1
			get_parent().clownfish_lure_decrease()
			if get_parent().CfL_amount == 0:
				get_parent().clownfish_lure_remove()
			print("Clownfish Lure Used")
			if pick > 0.5 and pick < 0.95:
				$Clownfish.visible = true
				clownfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Clownfish!')
			if pick < 0.05:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.20 and pick < 0.35:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.05 and pick < 0.20:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if pick > 0.35 and pick < 0.5:
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
				print("Fantasia Caught")
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Squid.visible = true
				squid_picked()
				$ShowFish.start()
				$Label.text = "You caught a Squid"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
			
			
		elif get_parent().CodL_amount > 0 and cod_lure:
			get_parent().CodL_amount += -1
			get_parent().cod_lure_decrease()
			if get_parent().CodL_amount == 0:
				get_parent().cod_lure_remove()
				print("Cod Lure Used")
			if pick > 0.5 and pick < 0.95:
				$Cod.visible = true
				cod_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Cod!')
			if pick < 0.05:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.20 and pick < 0.35:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.05 and pick < 0.20:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if pick > 0.35 and pick < 0.5:
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Squid.visible = true
				squid_picked()
				$ShowFish.start()
				$Label.text = "You caught a Squid"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
			
			
		elif get_parent().GfL_amount > 0 and goldfish_lure:
			get_parent().GfL_amount += -1
			get_parent().goldfish_lure_decrease()
			if get_parent().GfL_amount == 0:
				get_parent().goldfish_lure_remove()
			print("Goldfish Lure Used")
			if pick > 0.5 and pick < 0.95:
				$Goldfish.visible = true
				goldfish_picked()
				$ShowFish.start()
				$Label.text = ('You caught a Goldfish!')
			if pick < 0.05:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if pick > 0.20 and pick < 0.35:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.05 and pick < 0.20:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if pick > 0.35 and pick < 0.5:
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Squid.visible = true
				squid_picked()
				$ShowFish.start()
				$Label.text = "You caught a Squid"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
			
			
		else:
			if pick > 0.05 and pick < 0.25:
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
			if pick > 0.25 and pick < 0.55:
				$Bluegill.visible = true
				bluegill_picked()
				$ShowFish.start ()
				$Label.text = "You caught a Bluegill"
			if pick > 0.55 and pick < 0.95:
				$Fantasia.visible = true
				fantasia_picked()
				$ShowFish.start()
				$Label.text = "You caught a Fantasia"
			if pick < 0.05:
				$Trash.visible = true
				trash_picked()
				$ShowFish.start()
				$Label.text = ("You Got Trash")
				get_parent().trash_add()
			if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Squid.visible = true
				squid_picked()
				$ShowFish.start()
				$Label.text = "You caught a Squid"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
			elif get_parent().luck <= 0 and pick > 0.95:
				pick_fish()
			if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
				pick_fish()
	#-----------------------------------------------------------------------------------------------------------------------------
	#------------------------------------Basic Rod--------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------------
	elif get_parent().CfL_amount > 0 and clownfish_lure and not get_parent().IRod and not get_parent().ARod:
		get_parent().CfL_amount += -1
		get_parent().clownfish_lure_decrease()
		if get_parent().CfL_amount == 0:
			get_parent().clownfish_lure_remove()
		print("Clownfish Lure Used")
		if pick > 0.3 and pick < 0.95:
			$Clownfish.visible = true
			clownfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Clownfish!')
		if pick < 0.10:
			$Cod.visible = true
			cod_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Cod!')
		if pick > 0.10 and pick < 0.2:
			$Goldfish.visible = true
			goldfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Goldfish!')
		if pick > 0.2 and pick < 0.3:
			$Trash.visible = true
			trash_picked()
			$ShowFish.start()
			$Label.text = ("You Got Trash")
			get_parent().trash_add()
		if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
		elif get_parent().luck <= 0 and pick > 0.95:
			pick_fish()
		if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
			pick_fish()
			
			
	elif get_parent().CodL_amount > 0 and cod_lure and not get_parent().IRod and not get_parent().ARod:
		get_parent().CodL_amount += -1
		get_parent().cod_lure_decrease()
		if get_parent().CodL_amount == 0:
			get_parent().cod_lure_remove()
		print("Cod Lure Used")
		if pick > 0.10 and pick < 0.2:
			$Clownfish.visible = true
			clownfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Clownfish!')
		if pick > 0.3:
			$Cod.visible = true
			cod_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Cod!')
		if pick < 0.1:
			$Goldfish.visible = true
			goldfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Goldfish!')
		if pick > 0.2 and pick < 0.3:
			$Trash.visible = true
			trash_picked()
			$ShowFish.start()
			$Label.text = ("You Got Trash")
			get_parent().trash_add()
		if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
		elif get_parent().luck <= 0 and pick > 0.95:
			pick_fish()
		if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
			pick_fish()
			
			
	elif get_parent().GfL_amount > 0 and goldfish_lure and not get_parent().IRod and not get_parent().ARod:
		get_parent().GfL_amount += -1
		get_parent().goldfish_lure_decrease()
		if get_parent().GfL_amount == 0:
			get_parent().goldfish_lure_remove()
		print("Goldfish Lure Used")
		if pick < 0.1:
			$Clownfish.visible = true
			clownfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Clownfish!')
		if pick > 0.1 and pick < 0.2:
			$Cod.visible = true
			cod_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Cod!')
		if pick > 0.3:
			$Goldfish.visible = true
			goldfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Goldfish!')
		if pick > 0.2 and pick < 0.3:
			$Trash.visible = true
			trash_picked()
			$ShowFish.start()
			$Label.text = ("You Got Trash")
			get_parent().trash_add()
		if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
		elif get_parent().luck <= 0 and pick > 0.95:
			pick_fish()
		if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
			pick_fish()
		
			
			
	else:
		if pick < 0.25:
			$Clownfish.visible = true
			clownfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Clownfish!')
			#player.clownfish_add()
		if pick > 0.75:
			$Cod.visible = true
			cod_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Cod!')
		if pick > 0.5 and pick < 0.75:
			$Goldfish.visible = true
			goldfish_picked()
			$ShowFish.start()
			$Label.text = ('You caught a Goldfish!')
		if pick > 0.25 and pick < 0.5:
			$Trash.visible = true
			trash_picked()
			$ShowFish.start()
			$Label.text = ("You Got Trash")
			get_parent().trash_add()
		if get_parent().luck > 0 and pick > 0.95:
				get_parent().luck += -1
				$Skullfish.visible = true
				skullfish_picked()
				$ShowFish.start()
				$Label.text = "You caught a Skullfish"
				$RareCatch.add_theme_color_override("font_color", Color("255fff"))
				$RareCatch.text = "Rare Catch"
		elif get_parent().luck <= 0 and pick > 0.95:
			pick_fish()
		if pick == 0.05 or pick == 0.1 or pick == 0.15 or pick == 0.4 or pick == 0.5 or pick == 0.95:
			pick_fish()
			
func _on_show_fish_timeout() -> void:
	$Clownfish.visible = false
	$Cod.visible = false
	$Goldfish.visible = false
	$Skullfish.visible = false
	$Bluegill.visible = false
	$Trash.visible = false
	$Fantasia.visible = false
	$Label.text = ('')
	$RareCatch.text = ""
func clownfish_picked() -> void:
	var weight = randf() * 2.50
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
		weight = weight * 3
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = clownfish_base * weight * 2
		elif get_parent().good:
			total = clownfish_base * weight * 1.5
		elif get_parent().meh:
			total = clownfish_base * weight
		elif get_parent().bad:
			total = clownfish_base * weight * 0.5
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = clownfish_base * weight * 2
		elif get_parent().good:
			total = clownfish_base * weight * 1.5
		elif get_parent().meh:
			total = clownfish_base * weight
		elif get_parent().bad:
			total = clownfish_base * weight * 0.5
	print("Clownfish Caught")
	print(total)
	#MainCharacter.store_num += 1
	inventory_value()
	
func cod_picked() -> void:
	var weight = randf() * 5.00
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
		weight = weight * 3
		print('Weight is', str(weight))
		if get_parent().perfect:
			total = cod_base * weight * 2
		elif get_parent().good:
			total = cod_base * weight * 1.5
		elif get_parent().meh:
			total = cod_base * weight
		elif get_parent().bad:
			total = cod_base * weight * 0.5
			
			
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = cod_base * weight * 2
		elif get_parent().good:
			total = cod_base * weight * 1.5
		elif get_parent().meh:
			total = cod_base * weight
		elif get_parent().bad:
			total = cod_base * weight * 0.5
	print('Cod Caught')
	print(total)
	#MainCharacter.store_num += 1
	inventory_value()
	
func goldfish_picked() -> void:
	var weight = randf() * 3.00
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
		
		weight = weight * 3
		print('Weight is', str(weight))
		if get_parent().perfect:
			total = goldfish_base * weight * 2
		elif get_parent().good:
			total = goldfish_base * weight * 1.5
		elif get_parent().meh:
			total = goldfish_base * weight
		elif get_parent().bad:
			total = goldfish_base * weight * 0.5
			
			
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = goldfish_base * weight * 2
		elif get_parent().good:
			total = goldfish_base * weight * 1.5 
		elif get_parent().meh:
			total = goldfish_base * weight
		elif get_parent().bad:
			total = goldfish_base * weight * 0.5
	print('Goldfish Caught')
	print(total)
	#MainCharacter.store_num += 1
	inventory_value()
	
func trash_picked() -> void:
	get_parent().trash_amount += 1
	
func skullfish_picked() -> void:
	var weight = randf() * 20
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
	
		weight = weight * 3
		print('Weight is', str(weight))
		if get_parent().perfect:
			total = skullfish_base * weight * 2
		elif get_parent().good:
			total = skullfish_base * weight * 1.5
		elif get_parent().meh:
			total = skullfish_base * weight
		elif get_parent().bad:
			total = skullfish_base * weight * 0.5
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = skullfish_base * weight * 2
		elif get_parent().good:
			total = skullfish_base * weight * 1.5 
		elif get_parent().meh:
			total = skullfish_base * weight
		elif get_parent().bad:
			total = skullfish_base * weight * 0.5
	print("Skullfish Caught")
	print(total)
	inventory_value()

func bluegill_picked() -> void:
	var weight = randf() * 20
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
	
		weight = weight * 3
		print('Weight is', str(weight))
		if get_parent().perfect:
			total = bluegill_base * weight * 2
		elif get_parent().good:
			total = bluegill_base * weight * 1.5
		elif get_parent().meh:
			total = bluegill_base * weight
		elif get_parent().bad:
			total = bluegill_base * weight * 0.5
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = bluegill_base * weight * 2
		elif get_parent().good:
			total = bluegill_base * weight * 1.5 
		elif get_parent().meh:
			total = bluegill_base * weight
		elif get_parent().bad:
			total = bluegill_base * weight * 0.5
	print("Bluegill Caught")
	print(total)
	inventory_value()

func fantasia_picked() -> void:
	var weight = randf() * 20
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
	
		weight = weight * 3
		print('Weight is', str(weight))
		if get_parent().perfect:
			total = fantasia_base * weight * 2
		elif get_parent().good:
			total = fantasia_base * weight * 1.5
		elif get_parent().meh:
			total = fantasia_base * weight
		elif get_parent().bad:
			total = fantasia_base * weight * 0.5
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = fantasia_base * weight * 2
		elif get_parent().good:
			total = fantasia_base * weight * 1.5 
		elif get_parent().meh:
			total = fantasia_base * weight
		elif get_parent().bad:
			total = fantasia_base * weight * 0.5
	print("Fantasia Caught")
	print(total)
	inventory_value()

func squid_picked() -> void:
	var weight = randf() * 20
	if get_parent().IRod:
		weight = weight * 2
	if get_parent().ARod:
		weight = weight * 4
	if get_parent().FC_amount > 0 and FatChance:
		get_parent().FC_amount += -1
		get_parent().fc_decrease()
		print("Fat Chance Used")
		if get_parent().FC_amount == 0:
			get_parent().fc_lure_remove()
	
		weight = weight * 3
		print('Weight is', str(weight))
		if get_parent().perfect:
			total = squid_base * weight * 2
		elif get_parent().good:
			total = squid_base * weight * 1.5
		elif get_parent().meh:
			total = squid_base * weight
		elif get_parent().bad:
			total = squid_base * weight * 0.5
	else:
		print('Weight is',str(weight))
		if get_parent().perfect:
			total = squid_base * weight * 2
		elif get_parent().good:
			total = squid_base * weight * 1.5 
		elif get_parent().meh:
			total = squid_base * weight
		elif get_parent().bad:
			total = squid_base * weight * 0.5
	print("Squid Caught")
	print(total)
	inventory_value()
func inventory_value() -> void:
	#until you can store the value for each caught fish 
	MainCharacter.total_coins = int(total) + MainCharacter.total_coins
	print(MainCharacter.total_coins)
	total = 0
