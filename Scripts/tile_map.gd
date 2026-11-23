extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bridge1.visible = false
	MainCharacter.bridge1 = $Bridge1
	MainCharacter.RemoveableWater1 = $RemovableWater1
	MainCharacter.RemoveableFence1 = $RemoveableFence1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MainCharacter.game_over:
		get_tree().reload_current_scene()




func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D/Label.text = ("Barren Lands")
	MainCharacter.AddHunger = true
	$Area2D/Timer.start()
	print("Message Show")


func _on_timer_timeout() -> void:
	$Area2D.queue_free()
	print("Message Cleared")


func _on_gate_add_body_entered(body: Node2D) -> void:
	$RemoveableFence1.enabled = true
	
	



		


func _on_gate_remove_body_entered(body: Node2D) -> void:
	if MainCharacter.Fence1Access:
		$RemoveableFence1.enabled = false
		MainCharacter.Fence1Access = false


func _on_tree_trap_1_body_entered(body: Node2D) -> void:
	$TreeBlockage1.enabled = true
