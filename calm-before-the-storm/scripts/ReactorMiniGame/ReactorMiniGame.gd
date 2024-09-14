extends Control

var core_level: int = 50
var game_active: bool = false
var game_timer: Timer = null

@onready var core = $ColorRect/CoreRect
@onready var status_label = $ColorRect/StatusLabel
@onready var start_button = $ColorRect/StartButton

func _ready():
	$ColorRect/DecreaseButton.connect("pressed", self._on_decrease_pressed)
	$ColorRect/IncreaseButton.connect("pressed", self._on_increase_pressed)
	start_button.connect("pressed", self.start_game)
	
	# Set up the game timer
	game_timer = Timer.new()
	game_timer.connect("timeout", self._on_game_tick)
	game_timer.set_wait_time(0.5)
	add_child(game_timer)
	
	update_core()

func update_core():
	core.size.x = core_level * 2  # Assuming the reactor width is 200
	#core.position.x = 100 - core.size.x / 2  # Center the core
	
	if core_level < 40:
		core.color = Color(1, 0, 0)  # Red
	elif core_level > 60:
		core.color = Color(1, 0.5, 0)  # Orange
	else:
		core.color = Color(0, 1, 0)  # Green

func start_game():
	game_active = true
	core_level = randf_range(0, 100)
	update_core()
	#start_button.hide()
	status_label.text = "Stabilize the core!"
	game_timer.start()

func end_game(win):
	game_active = false
	game_timer.stop()
	status_label.text = "Core stabilized! You win!" if win else "Reactor meltdown! Game over!"
	#start_button.show()
	#start_button.text = "Play Again"

func _on_decrease_pressed():
	if game_active:
		core_level = max(0, core_level - 5)
		update_core()
		check_win_condition()

func _on_increase_pressed():
	if game_active:
		core_level = min(100, core_level + 5)
		update_core()
		check_win_condition()

func check_win_condition():
	if core_level >= 45 and core_level <= 55:
		end_game(true)

func _on_game_tick():
	core_level += (randf() - 0.5) * 5
	core_level = clamp(core_level, 0, 100)
	update_core()
	
	if core_level < 10 or core_level > 90:
		end_game(false)
