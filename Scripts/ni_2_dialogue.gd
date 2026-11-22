extends CanvasLayer

var first_text = false
var second_text = false
var close_ready = false
var bought = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$SeaStoneButton.visible = false
	$SeaStoneButton.set_process(false)
	$SeaStoneButton.set_process_input(false)
	$RejectButton.visible = false
	$RejectButton.set_process(false)
	$RejectButton.set_process_input(false)
	get_parent().shopping = false

func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if first_text and event.is_action_pressed("Next"):
		if bought:
			close_dialogue()
		else:
			text_two()
		
	if second_text and event.is_action_pressed("Next"):
		second_text = false
		text_three()
	if close_ready and event.is_action_pressed("Next"):
		close_dialogue()

func text_one() -> void:
	if bought:
		$ColorRect/Text.text = "Stay safe. The Forest is a dangerous place."
		$ColorRect/Next.text = "Press Enter to Close"
	else:
		$ColorRect/Text.text = "Halt. You Cannot Pass"
		print("First Message")
	$Read1.start()

func text_two() -> void:
	$ColorRect/Text.text = "To enter this jungle you must prove your worth."
	print("Second Message")
	$Read2.start()
func text_three() -> void:
	$ColorRect/Text.text = "Present me with a SeaStone and your path will be open"
	print("Third Message")
	second_text = false
	$ColorRect/Next.text = ""
	$SeaStoneButton.visible = true
	$SeaStoneButton.set_process(true)
	$SeaStoneButton.set_process_input(true)
	$RejectButton.visible = true
	$RejectButton.set_process(true)
	$RejectButton.set_process_input(true)

func directions() -> void:
	$ColorRect/Text.text = "Thank you for proving your worth, many have died in this forest I hope you will not end up the same.."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"

func come_back() -> void:
	$ColorRect/Text.text = "Such a shame. Come back when you are ready to advance to the next island."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"
func no_seastone() -> void:
	$ColorRect/Text.text =  "You do not have a seastone, come back when you have one."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"
func close_dialogue() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$SeaStoneButton.visible = false
	$SeaStoneButton.set_process(false)
	$SeaStoneButton.set_process_input(false)
	$RejectButton.visible = false
	$RejectButton.set_process(false)
	$RejectButton.set_process_input(false)
	get_parent().shopping = false
	first_text = false
	second_text = false
	close_ready = false

func _on_sea_stone_button_pressed() -> void:
	if get_parent(). seastones > 0:
		get_parent().seastones += -1
		directions()
		$SeaStoneButton.visible = false
		$SeaStoneButton.set_process(false)
		$SeaStoneButton.set_process_input(false)
		$RejectButton.visible = false
		$RejectButton.set_process(false)
		$RejectButton.set_process_input(false)
		bought = true
	else:
		come_back()
		$SeaStoneButton.visible = false
		$SeaStoneButton.set_process(false)
		$SeaStoneButton.set_process_input(false)
		$RejectButton.visible = false
		$RejectButton.set_process(false)
		$RejectButton.set_process_input(false)
		
func _on_read_1_timeout() -> void:
	first_text = true


func _on_read_2_timeout() -> void:
	first_text = false
	second_text = true


func _on_read_3_timeout() -> void:
	pass
	


func _on_reject_button_pressed() -> void:
	come_back()
	$SeaStoneButton.visible = false
	$SeaStoneButton.set_process(false)
	$SeaStoneButton.set_process_input(false)
	$RejectButton.visible = false
	$RejectButton.set_process(false)
	$RejectButton.set_process_input(false)
