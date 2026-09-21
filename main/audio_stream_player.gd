extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db = -10
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
