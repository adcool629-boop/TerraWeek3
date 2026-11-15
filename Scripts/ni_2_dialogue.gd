extends CanvasLayer

var first_text = false
var second_text = false
var close_ready = false
var bought = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if first_text and event.is_action_pressed("Next"):
		if bought:
			close_dialogue()
		else:
			text_two()
		
	if second_text and event.is_action_pressed("Next"):
		first_text = false
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
	$ColorRect/Text.text = "Present me with a SeaStone and your capabilities will show themselves"
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
	
func close_dialogue() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$YesButton.visible = false
	$YesButton.set_process(false)
	$YesButton.set_process_input(false)
	$NoButton.visible = false
	$NoButton.set_process(false)
	$NoButton.set_process_input(false)
	
	get_parent().shopping = false
