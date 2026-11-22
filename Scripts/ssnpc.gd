extends CanvasLayer

var close_ready: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Next") and close_ready:
		close()
func text_one() -> void:
	close_ready = false
	$".".visible = true
	$".".set_process(true)
	$".".set_process_input(true)
	$ColorRect/Text.text = "Hello, do you want this seastone I found for 150,000"
	$Buy.visible = true
	$No.visible = true

func _on_buy_pressed() -> void:
	$Buy.visible = false
	$No.visible = false
	if MainCharacter.total_coins >= 150000:
		MainCharacter.total_coins += -150000
		get_parent().seastone_add()
		$ColorRect/Text.text = "Thanks so much, come back again if you ever need another one."
		close_ready = true
		$ColorRect/Next.text = "Press Enter to Close"
	elif MainCharacter.total_coins < 150000:
		text_one()
		



func _on_no_pressed() -> void:
	$Buy.visible = false
	$No.visible = false
	$ColorRect/Text.text = "Fine, I wasn't going to sell it to you anyway."
	close_ready = true
	$ColorRect/Next.text = "Press Enter to Close"

func close() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	get_parent().shopping = false
