extends CanvasLayer

var first_text = false
var second_text = false
var close_ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YesButton.visible = false
	$YesButton.set_process(false)
	$YesButton.set_process_input(false)
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
	$ColorRect/Text.text = "It's been a long time since I've seen a new face around these parts."
	print("First Message")
	$Read1.start()

func text_two() -> void:
	$ColorRect/Text.text = "Take these apples, not much grows here."
	print("Second Message")
	$Read2.start()
func text_three() -> void:
	$ColorRect/Text.text = "Fair Warning, the fish around here aren't exactly the best for eating."
	print("Third Message")
	second_text = false
	$ColorRect/Next.text = ""
	$ClaimButton.visible = true

func directions() -> void:
	$ColorRect/Text.text = "Make sure to stay safe and fed."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"

func come_back() -> void:
	$ColorRect/Text.text = "Such a shame. Come back when you are ready to advance to the next island."
	close_ready = true
	
func close_dialogue() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	get_parent().shopping = false
