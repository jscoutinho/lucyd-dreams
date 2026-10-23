
extends Control

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

	$Vida1.visible = vida_atual >= 1
	$Vida2.visible = vida_atual >= 2
	$Vida3.visible = vida_atual >= 3
	$Vida4.visible = vida_atual >= 4
