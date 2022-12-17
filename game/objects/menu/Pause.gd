extends CanvasLayer

const OPTIONS = preload("res://objects/menu/Options.tscn")
var option = null

onready var tween = $Tween
onready var bg = $ColorRect2
onready var menu = $ColorRect

onready var resume = $ColorRect/CenterContainer/VBoxContainer/Resume
onready var options = $ColorRect/CenterContainer/VBoxContainer/Options
onready var quit = $ColorRect/CenterContainer/VBoxContainer/Quit

func _ready():
	get_tree().paused = true
	tween.interpolate_property(bg, "color:a", 0, 0.5, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(bg, "rect_position:x", 0, 235, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(bg, "rect_size:x", 640, 405, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(menu, "color:a", 0, 1.0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(menu, "rect_position:x", -235, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()


func _on_Resume_mouse_entered():
	resume.text = "* Resume"

func _on_Resume_mouse_exited():
	resume.text = "Resume"

func _on_Options_mouse_entered():
	options.text = "* Options"

func _on_Options_mouse_exited():
	options.text = "Options"

func _on_Quit_mouse_entered():
	quit.text = "* Quit"

func _on_Quit_mouse_exited():
	quit.text = "Quit"

func unpause():
	if tween.is_active(): return
	if option != null:
		option.queue_free()
		option = null
	tween.interpolate_property(bg, "color:a", 0.5, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(bg, "rect_position:x", 235, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(bg, "rect_size:x", 405, 640, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(menu, "color:a", 1.0, 0.0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(menu, "rect_position:x", 0, -235, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	get_tree().paused = false
	queue_free()

func _on_Resume_gui_input(event):
	if event is InputEventMouseButton:
		if !event.pressed: unpause()

func _input(event):
	if event.is_action_pressed("pause"): unpause()

func _on_Options_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed: return
		if option == null:
			option = OPTIONS.instance()
			option.rect_position.x = 235
			add_child(option)
		else:
			option.queue_free()
			option = null

func _on_Quit_gui_input(event):
	if event is InputEventMouseButton:
		if tween.is_active(): return
		TransitionManager.transition_to("res://scenes/LevelSelect.tscn")
		get_tree().paused = false
		queue_free()
