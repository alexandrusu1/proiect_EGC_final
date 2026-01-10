extends Area3D

@export var id_intrebare = 0 # Aici scrii 0, 1, 2 in Inspector pentru fiecare foaie

# Calea asta trebuie sa fie CORECTA. 
# Presupunem ca pui UI-ul in Main -> CanvasLayer.
@onready var ui = get_node("/root/Main/CanvasLayer2/ExamUI")

var jucator_in_zona = false

func _ready():
	body_entered.connect(_on_intra)
	body_exited.connect(_on_iese)

func _on_intra(body):
	if body.name == "Player":
		jucator_in_zona = true

func _on_iese(body):
	if body.name == "Player":
		jucator_in_zona = false

func _input(event):
	# Folosim Input.is_action_just_pressed daca ai setat "interact" in Input Map
	# Daca nu, foloseste: Input.is_key_pressed(KEY_E)
	if jucator_in_zona and Input.is_action_just_pressed("interact"):
		if ui:
			ui.deschide(id_intrebare, self)
		else:
			print("NU GASESC UI-ul! Verifica calea din script.")
