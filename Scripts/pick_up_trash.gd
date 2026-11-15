extends Area2D

var PickupAble: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MainCharacter.InReach:
		delete()
	




func _on_body_entered(body: Node2D) -> void:
	PickupAble = true
	print("can pick up")
func delete() -> void:
	if PickupAble:
		print("Picked Up")
		MainCharacter.InReach = false
		queue_free()
		MainCharacter.PickedUp = true
		PickupAble = false
	


func _on_body_exited(body: Node2D) -> void:
	PickupAble = false
	print("Can't Pick Up")
