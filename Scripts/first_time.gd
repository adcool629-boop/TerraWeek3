extends CanvasLayer

var first_text: bool = false
var second_text: bool = false
var close_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ClaimButton.visible = false
	$ClaimButton.set_process(false)
	$ClaimButton.set_process_input(false)
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if first_text and event.is_action_pressed("Next"):
		first_text = false
		text_two()
		
	if second_text and event.is_action_pressed("Next"):
		second_text = false
		text_three()
	if close_ready and event.is_action_pressed("Next"):
		close_dialogue()
func text_one() -> void:
	$ColorRect/Text.text = "It's been a long time since I've seen a new face around these parts."
	print("First Message")
	$Read1.start()

func text_two() -> void:
	$ColorRect/Text.text = "See that yellow bar in the bottom left? That your hunger. New perks are applied to your character evertime you go to a new island. Your hungry decrease by 10/100 every 60 seconds. Here take these apples, not much grows here."
	print("Second Message")
	$Read2.start()
func text_three() -> void:
	$ColorRect/Text.text = "Fair Warning, the fish around here aren't exactly the best for eating."
	print("Third Message")
	$ColorRect/Next.text = ""
	$ClaimButton.visible = true

func directions() -> void:
	$ColorRect/Text.text = "Talk to me again to open the shop."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"
	
func close_dialogue() -> void:
	$".".queue_free()
	get_parent().shopping = false
	


func _on_claim_button_pressed() -> void:
	if get_parent().apples == 0:
		MainCharacter.store_num += 1
	for i in range(10):
		get_parent().apples += 1
		get_parent().apples_add()

	
	$ClaimButton.visible = false
	$ClaimButton.set_process(false)
	$ClaimButton.set_process_input(false)
	directions()


func _on_read_1_timeout() -> void:
	first_text = true


func _on_read_2_timeout() -> void:
	second_text = true
