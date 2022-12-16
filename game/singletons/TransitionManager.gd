extends CanvasLayer

onready var color = $ColorRect
onready var tween : Tween = $Tween

func transition_to(path : String):
	tween.interpolate_property(color, "color:a", 0, 1, 0.1)
	tween.interpolate_property(color, "color:a", 1, 0, 0.1, 0, 2, 0.15)
	tween.start()
	yield(tween, "tween_completed")
	# Special case(s)
	match path:
		"quit":
			get_tree().quit()
		_:
			get_tree().change_scene(path)
