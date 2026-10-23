
extends Control
@onready var vida_1: AnimatedSprite2D = $Vida1
@onready var vida_2: AnimatedSprite2D = $Vida2
@onready var vida_3: AnimatedSprite2D = $Vida3
@onready var vida_4: AnimatedSprite2D = $Vida4

func _ready() -> void:
	print("HUD iniciado")

	var jogador = get_tree().get_first_node_in_group("Player")

	if jogador == null:
		print("ERRO: jogador não encontrado")
		return

	var health = jogador.get_node_or_null("HealthComponent")

	if health == null:
		print("ERRO: HealthComponent não encontrado")
		return

	health.vida_alterada.connect(_on_vida_alterada)

	print("Sinal conectado!")

	atualizar_vida(health.vida_atual)


func _on_vida_alterada(
	vida_atual: int,
	vida_maxima: int
) -> void:
	atualizar_vida(vida_atual)


func atualizar_vida(vida_atual: int) -> void:
	print("HUD recebeu vida: ", vida_atual)
	if vida_atual == 3:
		vida_4.play("saindo");
	elif vida_atual == 2:
		vida_3.play("saindo");
	elif vida_atual == 1:
		vida_2.play("saindo");
	elif vida_atual == 0:
		vida_1.play("saindo")
