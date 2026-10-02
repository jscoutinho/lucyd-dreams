extends CanvasLayer

@onready var panel = $Panel
@onready var conteudo = $Panel/Conteudo
@onready var nome: Label = $Panel/Nome

signal finished

var index := 0
var active := false
var texts: Array = []

# Configuração do efeito de texto
var typing := false
var char_index := 0
var typing_speed := 0.03 # segundos entre cada caractere
var typing_timer := 0.0


func show_dialogue(dialogue: Array, sujeito: String):
	texts = dialogue
	index = 0
	active = true

	nome.text = sujeito
	show()

	var player = get_tree().current_scene.get_node("Lucy")
	player.go_to_dialogue_state()

	start_typing()


func _ready():
	hide()


func _process(delta):

	if !active:
		return

	# Efeito de texto aparecendo
	if typing:
		typing_timer -= delta

		if typing_timer <= 0:
			typing_timer = typing_speed

			char_index += 1
			conteudo.text = texts[index].substr(0, char_index)

			if char_index >= texts[index].length():
				typing = false

	# Apertou Z/Enter
	if Input.is_action_just_pressed("ui_accept"):

		# Se ainda está escrevendo, mostra a frase inteira
		if typing:
			typing = false
			conteudo.text = texts[index]
			return

		# Se terminou de escrever, passa para a próxima fala
		index += 1

		if index >= texts.size():
			hide()
			active = false

			var player = get_tree().current_scene.get_node("Lucy")
			player.exit_dialogue()

			finished.emit()

		else:
			start_typing()


func start_typing():
	char_index = 0
	typing_timer = typing_speed
	typing = true

	conteudo.text = ""
