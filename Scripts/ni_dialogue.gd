extends CanvasLayer

var first_text = false
var second_text = false
var close_ready = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YesButton.visible = false
	$YesButton.set_process(false)
	$YesButton.set_process_input(false)
	$NoButton.visible = false
	$NoButton.set_process(false)
	$NoButton.set_process_input(false)
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if first_text and event.is_action_pressed("Next"):
		text_two()
		
	if second_text and event.is_action_pressed("Next"):
		first_text = false
		text_three()
	if close_ready and event.is_action_pressed("Next"):
		close_dialogue()
func text_one() -> void:
	$ColorRect/Text.text = "Hello Fellow Fisherman. Do you seek Adventure?"
	print("First Message")
	$Read1.start()

func text_two() -> void:
	$ColorRect/Text.text = "Give me your riches and I shall reveal the path"
	print("Second Message")
	$Read2.start()
func text_three() -> void:
	$ColorRect/Text.text = "Give Adventurous Fisherman 50,000 Coins?"
	print("Third Message")
	second_text = false
	$ColorRect/Next.text = ""
	$YesButton.visible = true
	$NoButton.visible = true

func directions() -> void:
	$ColorRect/Text.text = "Thank you Fisherman! If you head straight down you shall find a path to the next island."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"

func come_back() -> void:
	$ColorRect/Text.text = "Such a shame. Come back when you are ready to advance to the next island."
	close_ready = true
	
func _on_yes_button_pressed() -> void:
	if MainCharacter.total_coins >= 50000:
		MainCharacter.total_coins = MainCharacter.total_coins - 50000
		$YesButton.visible = false
		$YesButton.set_process(false)
		$YesButton.set_process_input(false)
		$NoButton.visible = false
		$NoButton.set_process(false)
		$NoButton.set_process_input(false)
		directions()
		MainCharacter.bridge1.visible = true
		MainCharacter.RemoveableWater1.queue_free()
		
	elif MainCharacter.total_coins < 50000:
		$ColorRect.text = "Not Enoguh Coins"
		


func _on_no_button_pressed() -> void:
	$YesButton.visible = false
	$YesButton.set_process(false)
	$YesButton.set_process_input(false)
	$NoButton.visible = false
	$NoButton.set_process(false)
	$NoButton.set_process_input(false)
	come_back()

func close_dialogue() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	get_parent().shopping = false


func _on_read_1_timeout() -> void:
	first_text = true


func _on_read_2_timeout() -> void:
	second_text = true
