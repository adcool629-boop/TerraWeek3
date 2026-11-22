extends Node

var chosen_character: int = 0
var character_selected: bool = false
var fishables: bool = false
var moveables: bool = true
var total_coins: int = 1000000
var trash: int = 0
var wood: int = 0
var store_num: int = 0
var store: int = 0
var bridge1
var RemoveableWater1
var RemoveableFence1
var Fence1Access: bool = false
var InReach: bool = false
var PickedUp: bool = false
var AddHunger: bool = false
var game_over: bool = false
var seastone_given: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if game_over:
			game_over = false
			reset_game()
func reset_game() -> void:
	print("restarting")
	chosen_character = 0
	character_selected = false
	fishables = false
	moveables = true
	total_coins = 1000000
	trash = 0
	store_num = 0
	store = 0
	bridge1
	RemoveableWater1
	RemoveableFence1
	InReach = false
	PickedUp = false
	AddHunger = false
	game_over = false
	seastone_given = false
	get_tree().reload_current_scene()
