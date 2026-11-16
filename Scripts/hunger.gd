extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MainCharacter.AddHunger:
		hunger_start()
		MainCharacter.AddHunger = false
func hunger_start() -> void:
	print("Hunger Added")
	$".".visible = true
	$Timer.start()


func _on_timer_timeout() -> void:
	print("Decreasing Hunger")
	$TextureRect/TextureProgressBar.value += -10
	if $TextureRect/TextureProgressBar.value == 0:
		MainCharacter.game_over = true
	
func eating_apple() -> void:
	$TextureRect/TextureProgressBar.value += 20
	print("Apple Consumed, Restoring Saturation")
	$AudioStreamPlayer.play()

func eating_bread() -> void:
	$TextureRect/TextureProgressBar.value += 25
	print("Bread Consumed")
	$AudioStreamPlayer.play()

func eating_cake() -> void:
	$TextureRect/TextureProgressBar.value += 25
	print("Cake Consumed")
	$AudioStreamPlayer.play()
	
