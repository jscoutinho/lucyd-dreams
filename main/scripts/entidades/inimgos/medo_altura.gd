extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var vida_maxima: int = 3
var vida_atual: int

func _ready() -> void:
	vida_atual = vida_maxima


func receber_dano(quantidade: int = 1) -> void:
	if vida_atual <= 0:
		return

	vida_atual = max(vida_atual - quantidade, 0)

	print("Vida do monstro: ", vida_atual)
