extends CanvasLayer

@onready var bar: TextureRect = $Outline/Bar
@onready var pin: ColorRect = $Outline/Bar/Pin
@export var pin_speed: float = 800.0
var pin_position: float
var pin_direction: float = 1.0
var tries: int = 3
var active: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.visible = false
	$TriesLeft.visible = false
	$".".visible = false
	set_process(false)
	set_process_input(false)
	
	

func minigame_start() -> void:
	active = true
	$TriesLeft.visible = true
	$Instructions.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		if pin_position <= -3:
			pin_direction = 1
		elif pin_position >= 905 :
			pin_direction = -1
		pin.position.x += pin_speed * delta * pin_direction
		pin_position = pin.position.x

func _unhandled_input(event: InputEvent) -> void:
	if active:
		if event.is_action_pressed("PressSpaceBar") and tries > 0 and get_parent().IRod:
			print("Pass limited to IRod Range")
			if pin_position >= 424.5 and pin_position <= 481.5:
				print("Pass")
				active = false
				$WinTimer.start()
				$Instructions.visible = false
				$TriesLeft.visible = false
				$Label.visible = true
				set_process(false)
				set_process_input(false)
				active = false
			elif tries > 0:
				tries += -1
				$TriesLeft.text = ('Tries Left '+ str(tries))
				print(tries)
			elif tries <= 0:
				print("Lose")
				$TriesLeft.text = "Out of tries. Try again next time"
				$LoseTimer.start()
				set_process(false)
				set_process_input(false)
				active = false
		elif event.is_action_pressed("PressSpaceBar") and tries > 0 and get_parent().ARod:
			print("Pass limited to ARod Range")
			if pin_position >= 439 and pin_position <= 467:
				print("Pass")
				active = false
				$WinTimer.start()
				$Instructions.visible = false
				$TriesLeft.visible = false
				$Label.visible = true
				set_process(false)
				set_process_input(false)
				active = false
			elif tries > 0:
				tries += -1
				$TriesLeft.text = ('Tries Left '+ str(tries))
				print(tries)
			elif tries <= 0:
				print("Lose")
				$TriesLeft.text = "Out of tries. Try again next time"
				$LoseTimer.start()
				set_process(false)
				set_process_input(false)
				active = false
		elif event.is_action_pressed("PressSpaceBar") and tries > 0 and not get_parent().IRod and not get_parent().ARod:
			if pin_position >= 400 and pin_position <= 510:
				print("Pass")
				active = false
				$WinTimer.start()
				$Instructions.visible = false
				$TriesLeft.visible = false
				$Label.visible = true
				set_process(false)
				set_process_input(false)
				active = false
			elif tries > 0:
				tries += -1
				$TriesLeft.text = ('Tries Left '+ str(tries))
				print(tries)
			elif tries <= 0:
				print("Lose")
				$TriesLeft.text = "Out of tries. Try again next time"
				$LoseTimer.start()
				set_process(false)
				set_process_input(false)
				active = false



func _on_win_timer_timeout() -> void:
	
	get_parent().fish_caught()
	get_parent().skill_check_end()
	pin.position.x = -3
	tries = 3
	
func _on_lose_timer_timeout() -> void:

	get_parent().skill_check_end()
	pin.position.x = -3
	tries = 3
