extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Troll.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $RayCast2D.is_colliding() and MainCharacter.openchest:
		$AnimatedSprite2D.play("Opening")
		$Timer.start()
		
		
		


func _on_timer_timeout() -> void:
	$Troll.text = "Nothing LOL"
