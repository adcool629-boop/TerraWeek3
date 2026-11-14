extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bridge1.visible = false
	MainCharacter.bridge1 = $Bridge1
	MainCharacter.RemoveableWater1 = $RemovableWater1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
