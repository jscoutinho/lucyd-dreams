extends Node

@onready var player_a: AudioStreamPlayer = $MusicPlayerA
@onready var player_b: AudioStreamPlayer = $"MusicPlayerB"

var tocando_a := true
var tween_atual: Tween

func parar():
	player_a.stop()
	player_b.stop()


func _ready() -> void:
	player_a.volume_db = -10
	player_b.volume_db = -10


func tocar_musica(nova_musica: AudioStream, volume: float = -10) -> void:

	var atual: AudioStreamPlayer
	var proximo: AudioStreamPlayer

	if tocando_a:
		atual = player_a
		proximo = player_b
	else:
		atual = player_b
		proximo = player_a

	if tween_atual:
		tween_atual.kill()

	proximo.stream = nova_musica
	proximo.volume_db = -40
	proximo.play()

	tween_atual = create_tween()
	tween_atual.set_parallel(true)

	tween_atual.tween_property(
		atual,
		"volume_db",
		-40,
		2.0
	)

	tween_atual.tween_property(
		proximo,
		"volume_db",
		volume,
		2.0
	)

	await tween_atual.finished

	atual.stop()
	atual.volume_db = -10

	tocando_a = !tocando_a
