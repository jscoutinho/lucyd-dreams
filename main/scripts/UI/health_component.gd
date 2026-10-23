
extends Node

signal vida_alterada(vida_atual: int, vida_maxima: int)
signal morreu
signal dano_recebido

@export var vida_maxima: int = 4
@export var tempo_invulnerabilidade: float = 1.0

var vida_atual: int
var invulneravel: bool = false


func _ready() -> void:
	vida_atual = vida_maxima
	vida_alterada.emit(vida_atual, vida_maxima)


func receber_dano(quantidade: int = 1) -> void:
	if invulneravel or vida_atual <= 0 or quantidade <= 0:
		return

	invulneravel = true

	vida_atual = max(vida_atual - quantidade, 0)

	print("Vida atual: ", vida_atual)

	vida_alterada.emit(vida_atual, vida_maxima)
	dano_recebido.emit()

	if vida_atual <= 0:
		morreu.emit()
		return

	await get_tree().create_timer(tempo_invulnerabilidade).timeout

	invulneravel = false


func curar(quantidade: int = 1) -> void:
	if vida_atual <= 0 or quantidade <= 0:
		return

	vida_atual = min(vida_atual + quantidade, vida_maxima)
	vida_alterada.emit(vida_atual, vida_maxima)


func restaurar_vida() -> void:
	vida_atual = vida_maxima
	invulneravel = false
	vida_alterada.emit(vida_atual, vida_maxima)
