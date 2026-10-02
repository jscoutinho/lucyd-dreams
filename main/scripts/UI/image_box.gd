extends CanvasLayer

@onready var panel = $Panel
@onready var conteudo = $Panel/Conteudo
@onready var nome: Label = $Panel/Nome
@onready var imagem: TextureRect = $TextureRect

signal finished

var index := 0
var active := false
var texts: Array = []

# Texto aparecendo progressivamente
var typing := false
var char_index := 0
var typing_speed := 0.03
var typing_timer := 0.0


func show_dialogue(dialogue: Array, sujeito: String, caminho: String):
	texts = dialogue
	index = 0
	active = true

	nome.text = sujeito
	imagem.texture = load(caminho)

	show()

	var player = get_tree().get_first_node_in_group("Player")
	player.go_to_dialogue_state()

	start_typing()


func _ready():
	hide()


func _process(delta):

	if !active:
		return

	# ==========================================
	# EFEITO DE TEXTO
	# ==========================================

	if typing:
		typing_timer -= delta

		if typing_timer <= 0:
			typing_timer = typing_speed

			char_index += 1

			conteudo.text = texts[index].substr(0, char_index)

			# Terminou de escrever
			if char_index >= texts[index].length():
				typing = false


	# ==========================================
	# BOTÃO DE AVANÇAR
	# ==========================================

	if Input.is_action_just_pressed("ui_accept"):

		# Se o texto ainda está aparecendo,
		# mostra tudo imediatamente.
		if typing:
			typing = false
			conteudo.text = texts[index]
			return

		# Texto terminou → próxima fala
		index += 1

		if index >= texts.size():

			hide()
			active = false

			var player = get_tree().get_first_node_in_group("Player")
			player.exit_dialogue()

			finished.emit()

		else:
			start_typing()


func start_typing():

	char_index = 0
	typing_timer = typing_speed
	typing = true

	conteudo.text = ""
