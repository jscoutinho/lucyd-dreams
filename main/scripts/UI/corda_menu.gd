
extends Sprite2D

@export var intensidade: float = 2.5
@export var duracao: float = 0.035
@export var vibracoes: int = 3

var posicao_original: Vector2
var tween_vibracao: Tween


func _ready() -> void:
	posicao_original = position


func vibrar() -> void:
	if tween_vibracao and tween_vibracao.is_running():
		tween_vibracao.kill()

	position = posicao_original

	tween_vibracao = create_tween()

	for i in range(vibracoes):
		tween_vibracao.tween_property(
			self,
			"position:y",
			posicao_original.y - intensidade,
			duracao
		)

		tween_vibracao.tween_property(
			self,
			"position:y",
			posicao_original.y + intensidade,
			duracao
		)

	tween_vibracao.tween_property(
		self,
		"position",
		posicao_original,
		duracao
	)
