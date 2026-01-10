extends Area3D

# Aceasta variabila o setezi din Inspector (0, 1, 2 etc.)
@export var id_intrebare = 0 

# Daca in stanga in lista nodul se numeste "ExamUI"
@onready var exam_ui = get_node("/root/Main/HUD/ExamUI")

# SAU, daca in lista apare cu litere mici "exam_ui", scrie asa:
# @onready var exam_ui = get_node("/root/Main/HUD/exam_ui")

var jucator_in_zona = false

func _ready():
	# Conectam semnalele exact ca la jurnal
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		jucator_in_zona = true
		print("Jucator langa foaie!") # Debugging

func _on_body_exited(body):
	if body.name == "Player":
		jucator_in_zona = false

func _input(event):
	# Folosim "interact" exact ca la Jurnal
	if jucator_in_zona and Input.is_action_just_pressed("interact"):
		print("Am apasat E!")
		
		if exam_ui:
			# Daca meniul nu e deja deschis, il deschidem
			if exam_ui.visible == false:
				exam_ui.arata_intrebare(id_intrebare, self)
		else:
			print("EROARE: Nu gasesc ExamUI! Verifica calea din script.")
