extends AudioStreamPlayer

class_name MusicManager

func _ready() -> void:
	fadeInAudio()
	pass

func fadeInAudio() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -8.0, 5)
	pass
