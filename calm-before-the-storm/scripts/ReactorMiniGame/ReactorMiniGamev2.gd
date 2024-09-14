extends Control

var core_level: float = 50.0
var game_active: bool = false
var game_timer: Timer = null
var time_limit_timer: Timer = null
var progress: float = 0.0

@onready var core: Control = $ColorRect/CoreRect
@onready var status_label: Label = $ColorRect/StatusLabel
@onready var start_button: Button = $ColorRect/StartButton
@onready var progress_meter: ProgressBar = $ColorRect/ProgressBar

func _ready():
	$ColorRect/DecreaseButton.connect("pressed", self._on_decrease_pressed)
	$ColorRect/IncreaseButton.connect("pressed", self._on_increase_pressed)
	start_button.connect("pressed", self.start_game)
	
	game_timer = Timer.new()
	game_timer.connect("timeout", self._on_game_tick)
	game_timer.wait_time = 0.1 
	add_child(game_timer)
	
	time_limit_timer = Timer.new()
	time_limit_timer.connect("timeout", self._on_time_limit_reached)
	time_limit_timer.wait_time = 30.0
	time_limit_timer.one_shot = true
	add_child(time_limit_timer)
	
	update_core()

func update_core():
	core.size.x = core_level * 2
	core.position.x = 100 - core.size.x / 2
	if core_level < 40:
		core.modulate = Color(1, 0, 0)  # Red
	elif core_level > 60:
		core.modulate = Color(1, 0.5, 0)  # Orange
	else:
		core.modulate = Color(0, 1, 0)  # Green, player must keep bar green in order to make progress

func start_game():
	game_active = true
	core_level = randf_range(0, 100)
	progress = 0.0
	update_core()
	start_button.hide()
	status_label.text = "Stabilize the core!"
	game_timer.start()
	time_limit_timer.start()
	progress_meter.value = progress

func end_game(win: bool):
	game_active = false
	game_timer.stop()
	time_limit_timer.stop()
	status_label.text = "Core stabilized! Good job" if win else "You messed up everyone dead"
	start_button.show()
	start_button.text = "Play Again"

func _on_decrease_pressed():
	if game_active:
		core_level = max(0, core_level - 5)
		update_core()

func _on_increase_pressed():
	if game_active:
		core_level = min(100, core_level + 5)
		update_core()

func _on_game_tick():
	if not game_active:
		return
	
	# Random core movement
	core_level += (randf() - 0.5) * 15 
	core_level = clamp(core_level, 0, 100)
	update_core()
	
	# Increase progress if core is green, decrease otherwise
	if 40 <= core_level and core_level <= 60:
		progress += 3  # Increase progress when green
	else:
		progress -= 1  # Decrease progress when not green
	
	progress = clamp(progress, 0.0, 100.0)
	progress_meter.value = progress
	
	check_win_condition()

#Progress bar reaches 100% and you win!
func check_win_condition():
	if progress >= 100.0:
		end_game(true)

#
func _on_time_limit_reached():
	if game_active:
		end_game(false)
