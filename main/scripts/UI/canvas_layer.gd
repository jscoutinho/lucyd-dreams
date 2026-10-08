extends CanvasLayer

@onready var panel = $Panel
@onready var conteudo = $Panel/Conteudo
@onready var nome: Label = $Panel/Nome

signal finished
signal line_started

var index := 0
var active := false
var texts: Array = []

# Conversa entre personagens
var conversation_active := false
var conversation_data: Array = []

# Texto atual sendo exibido
var current_text := ""

# Configuração do efeito de texto
var typing := false
var char_index := 0
var typing_speed := 0.03
var typing_timer := 0.0


func show_dialogue(dialogue: Array, sujeito: String):
	# Desativa qualquer conversa anterior
	conversation_active = false

	texts = dialogue
	index = 0
	active = true

	nome.text = sujeito
	show()

	var player = get_tree().current_scene.get_node("Lucy")
	player.go_to_dialogue_state()

	start_typing()


# NOVO:
# Usado para conversas entre dois ou mais personagens
func show_conversation(conversation: Array):
	conversation_data = conversation
	conversation_active = true

	index = 0
	active = true

	show()

	var player = get_tree().current_scene.get_node("Lucy")
	player.go_to_dialogue_state()

	start_conversation_line()


func _ready():
	hide()


func _process(delta):

	if not active:
		return

	# Efeito de texto aparecendo
	if typing:
		typing_timer -= delta

		if typing_timer <= 0:
			typing_timer = typing_speed

			char_index += 1
			conteudo.text = current_text.substr(0, char_index)

			if char_index >= current_text.length():
				typing = false

	# Apertou Z/Enter
	if Input.is_action_just_pressed("ui_accept"):

		# Se ainda está escrevendo, mostra a frase inteira
		if typing:
			typing = false
			conteudo.text = current_text
			return

		# Se estamos em uma conversa
		if conversation_active:
			next_conversation_line()
			return

		# Diálogo normal
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

	current_text = texts[index]
	conteudo.text = ""


# Começa a fala atual da conversa
func start_conversation_line():
	var fala = conversation_data[index]

	nome.text = fala["sujeito"]
	current_text = fala["texto"]

	char_index = 0
	typing_timer = typing_speed
	typing = true
	conteudo.text = ""

	line_started.emit(fala)


# Vai para a próxima fala da conversa
func next_conversation_line():
	index += 1

	# Terminou a conversa
	if index >= conversation_data.size():

		hide()
		active = false
		conversation_active = false

		var player = get_tree().current_scene.get_node("Lucy")
		player.exit_dialogue()

		finished.emit()

		return

	# Próximo personagem
	start_conversation_line()
