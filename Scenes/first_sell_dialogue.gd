extends CanvasLayer

var first_line = false
var second_line = false
var third_line = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if first_line and event.is_action_pressed("Next"):
		first_line = false
		text_two()
	if second_line and event.is_action_pressed("Next"):
		second_line = false
		text_three()
	if third_line and event.is_action_pressed("Next"):
		get_parent().shopping = false
		queue_free()
func text_one() -> void:
	$ColorRect/Text.text = "Hello, this must be your first time selling something. I buy wares of all sorts of wares, when talking to me just click on the item you want to sell."
	$TextOne.start()

func text_two() -> void:
	$ColorRect/Text.text = "You'll find me and my brothers across every zone so you'll never have to worry about selling items. We might not look like much but we're pretty tuff"
	$TextTwo.start()
	
func text_three() -> void:
	$ColorRect/Text.text = "Talk to me again to open the sell menu, and btw one click is all it takes to sell so be careful."
	$ColorRect/Next.text = "Press Enter To Close..."
	$TextThree.start()
	
func _on_text_one_timeout() -> void:
	first_line = true


func _on_text_two_timeout() -> void:
	second_line = true


func _on_text_three_timeout() -> void:
	third_line = true
