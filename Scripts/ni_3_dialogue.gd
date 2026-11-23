extends CanvasLayer

var close_ready: bool = false
var no: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$Give.visible = false
	$Cant.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if no and close_ready and event.is_action_pressed("Next"):
		close()
func text_one() -> void:
	$ColorRect/Text.text = "So you want to enter my domain eh?"
	
func text_two() -> void:
	$ColorRect/Text.text = "Very Well. Bring me 50 wood 100 trash, and 100,000 Coins"

func _on_no_pressed() -> void:
	no = true
	$ColorRect/Text.text = "Then Scram"
	$ColorRect/Next.text = "Press Enter to Close"
	close_ready = true
	$Yes.visible = false
	$No.visible = false
	
	
func close() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	get_parent().shopping = false
	no = false
	close_ready = false


func _on_yes_pressed() -> void:
	text_two()
	$Give.visible = true
	$Cant.visible = true
	$Yes.visible = false
	$No.visible = false


func _on_cant_pressed() -> void:
	$ColorRect/Text.text = "If you want to pass come back when you have the materials"


func _on_give_pressed() -> void:
	if MainCharacter.total_coins >= 100000 and MainCharacter.wood >= 50 and MainCharacter.trash >= 100:
		MainCharacter.total_coins += -100000
