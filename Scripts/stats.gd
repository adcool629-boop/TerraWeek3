extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#---------------------FISH---------------------
	$FishCategory/CfCaught.text = "Clownfish Caught: " +str(get_parent().cf_caught)
	$FishCategory/CodCaught.text = "Cod Caught: " +str(get_parent().cods_caught)
	$FishCategory/GfCaught.text = "Goldfish Caught: " +str(get_parent().gf_caught)
	$FishCategory/SfCaught.text = "Skullfish Caught: " +str(get_parent().sf_caught)
	$FishCategory/BgCaught.text = "Bluegills Caught: " +str(get_parent().bg_caught)
	$FishCategory/FantaCaught.text = "Fantasia's Caught: " +str(get_parent().fanta_caught)
	$FishCategory/SquidCaught.text = "Squids Caught: " +str(get_parent().squids_caught)
	$FishCategory/Trash.text = "Trash Caught: " +str(get_parent().trash)
	$FishCategory/Seastones.text = "Seastones Caught: " +str(get_parent().seastone)
	$FishCategory/TotalFishCaught.text = "Total Fish Caught: " +str(get_parent().tf_caught)
	#-----------------------CASTS---------------------
	$Casting/CastsMade.text = "Casts Made: " +str(get_parent().cast)
	$Casting/TimeWaitd.text = "Time Waited: " +str(get_parent().time)
	$Casting/Perfects.text = "Perfects: " +str(get_parent().perfects)
	$Casting/Goods.text = "Goods: " +str(get_parent().goods)
	$Casting/Mehs.text = "Mehs" +str(get_parent().mehs)
	$Casting/Bads.text = "Bads" +str(get_parent().bads)
	
	#-----------------REELS---------------------
	$Reeling/MGPlayed.text = "Mini-Games Played: " +str(get_parent().mg_played)
	$Reeling/MGWon.text = "Mini-Games Won: " +str(get_parent().mg_won)
	$Reeling/MGLost.text = "Mini-Games Lost: " +str(get_parent().mg_lost)
	$Reeling/QTPlayed.text = "Quick Time Events Played: " +str(get_parent().qte_played)
	$Reeling/QTWon.text = "Quick Time Events Won: " +str(get_parent().qte_won)
	$Reeling/QTLost.text = "Quick Time Events Lost: " +str(get_parent().qte_lost)
	$Reeling/SCPlayed.text = "Skill Checks Played: " +str(get_parent().sc_played)
	$Reeling/SCWon.text = "Skill Checks Won: " +str(get_parent().sc_won)
	$Reeling/SCLost.text =  "Skill Checks Lost: " +str(get_parent().sc_lost)
	
	#-----------------WEALTH---------------------
	$Wealth/Coins.text = "Coins Amassed:  " +str(MainCharacter.coins)
	$Wealth/Trash.text = "Trash Collected: " +str(MainCharacter.total_trash)
	$Wealth/Wood.text = "Wood Harvested: " +str(MainCharacter.total_wood)
	
	#-----------------CONSUMABLES---------------------
	$Consumables/CfL.text = "Clownfish Lures Used: " +str(get_parent().cfl_used)
	$Consumables/CodL.text = "Cod Lures Used: " +str(get_parent().codl_used)
	$Consumables/GfL.text = "Goldfish Lures Used: " +str(get_parent().gfl_used)
	$Consumables/FC.text = "Fat Chances Used: " +str(get_parent().fc_used)
	$Consumables/FantasiaL.text = "Fantasia Lures Used: " +str(get_parent().fanta_used)
	$Consumables/SquidL.text = "Squid Lures Used: " +str(get_parent().squid_used)
	$Consumables/SLP.text = "Small Luck Potions Used: " +str(get_parent().slp_used)
	$Consumables/MLP.text = "Medium Luck Potions Used: " +str(get_parent().mlp_used)
	$Consumables/LLP.text = "Large Luck Potions Used: " +str(get_parent().llp_used)
	$Consumables/Apples.text = "Apples Eaten: " +str(get_parent().apples_eaten)
	$Consumables/Bread.text = "Bread Eaten: " +str(get_parent().bread_eaten)
	$Consumables/Cake.text = "Cake Eaten: " +str(get_parent().cake_eaten)
	
	#------------------RECORDS-------------------------
	$Records/HeaviestFish.text = "Heaviest Fish: " +str(MainCharacter.heaviest)
	$Records/LightestFish.text = "Lightest Fish: " +str(MainCharacter.lightest)
	$Records/MostExpensive.text = "Most Valuable Fish: " +str(MainCharacter.most_value)
	$Records/Cheapest.text = "Least Valuable Fish: " +str(MainCharacter.least_value)
	$"Records/Longest Wait".text = "Longest Wait: " +str(MainCharacter.longest_wait)
	$"Records/Shortest Wait".text = "Shortest Wait: " +str(MainCharacter.shortest_wait)
	
	
func _on_close_button_pressed() -> void:
	get_parent().hide_stats()
