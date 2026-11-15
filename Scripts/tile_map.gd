extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bridge1.visible = false
	MainCharacter.bridge1 = $Bridge1
	MainCharacter.RemoveableWater1 = $RemovableWater1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D/Label.text = ("Barren Lands")
	$Area2D/Timer.start()
	print("Message Show")


func _on_timer_timeout() -> void:
	$Area2D.queue_free()
	print("Message Cleared")
