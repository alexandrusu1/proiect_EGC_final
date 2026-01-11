extends Node

var greseli = 0
var joc_finalizat = false
var corecte = 0

var intrebari = [
	{"q": "SD: Ce structură de date funcționează pe principiul LIFO (Last In, First Out)?", "a": ["Coada (Queue)", "Stiva (Stack)", "Vectorul", "Arborele"], "corect": 1},
	{"q": "Programare C: Care este specificatorul de format folosit pentru afișarea unui număr întreg (int)?", "a": ["%f", "%c", "%d", "%s"], "corect": 2},
	{"q": "Digitală: Care este rezultatul operației logice AND între 1 și 0?", "a": ["1", "0", "Nu se poate determina", "High Impedance"], "corect": 1},
	{"q": "Disp. Electronice: Care este funcția principală a unei diode redresoare?", "a": ["Amplifică semnalul", "Permite curentul într-un singur sens", "Stochează energie", "Scade tensiunea la 0"], "corect": 1},
	{"q": "Analogică: Care este unitatea de măsură pentru Rezistența electrică?", "a": ["Volt (V)", "Amper (A)", "Ohm (Ω)", "Watt (W)"], "corect": 2},
	{"q": "Arhitectura Calc: Ce înseamnă RAM?", "a": ["Read Access Memory", "Random Access Memory", "Run All Memory", "Real Action Memory"], "corect": 1},
	{"q": "Metode Numerice: Care este baza sistemului de numerație binar?", "a": ["10", "16", "2", "8"], "corect": 2},
	{"q": "Semnale: În ce se măsoară frecvența unui semnal?", "a": ["Secunde", "Hertz (Hz)", "Metri", "Decibeli"], "corect": 1},
	{"q": "Math (Alg. Liniară): Care este determinantul unei matrici unitate (identitate)?", "a": ["0", "1", "-1", "Infinit"], "corect": 1},
	{"q": "Calculatoare: Câți biți are un Byte (Octet)?", "a": ["4 biți", "8 biți", "16 biți", "32 biți"], "corect": 1}
]
func verifica_raspuns(id_intrebare, index_raspuns_ales):
	if joc_finalizat: return false
	var raspuns_corect = intrebari[id_intrebare]["corect"]
	
	if index_raspuns_ales == raspuns_corect:
		corecte += 1
		if corecte >= 10:
			afiseaza_ecran_final("EcranCastig")
		return true
	else:
		greseli += 1
		if greseli >= 5:
			afiseaza_ecran_final("EcranPicat")
		return false


func este_game_over():
	return greseli >= 5 or corecte >= 10

func afiseaza_ecran_final(nume_nod):
	if joc_finalizat: return
	joc_finalizat = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var ecran = get_tree().current_scene.find_child(nume_nod, true, false)
	if ecran:
		ecran.visible = true
	
	var sunet_nume = "SunetCastig" if nume_nod == "EcranCastig" else "SunetEsec"
	var sunet = get_tree().current_scene.find_child(sunet_nume, true, false)
	if sunet: sunet.play()
	
	await get_tree().create_timer(5.0).timeout
	restart_joc()

func restart_joc():
	greseli = 0
	corecte = 0
	joc_finalizat = false
	get_tree().reload_current_scene()
