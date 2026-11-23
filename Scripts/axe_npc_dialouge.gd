extends CanvasLayer

var close_ready = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if close_ready and event.is_action_pressed("Next"):
		get_parent().shopping = false
		queue_free()
func text_one() -> void:
	$ColorRect/Text.text = "To make it this far without starving, truly impressive. Take this axe to help you get out, I know it will be well used"
	


func _on_take_axe_pressed() -> void:
	$ColorRect/Text.text = 'Speaking of which did you happen to see that lone tree on your way over here. Its rumored to have infinite wood, of course only those "Worthy" can actually obtain wood from it  '
	$ColorRect/Next.text = "Press Enter to Close"
	close_ready = true
	$TakeAxe.visible = false
	get_parent().add_axe()
