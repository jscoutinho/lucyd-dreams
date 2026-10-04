extends Sprite2D

@export var speed := 150.0

func _process(delta):
	position.x -= speed * delta
