extends Node

var greseli = 0

var intrebari = [
	{
		"q": "SD: Ce structură de date funcționează pe principiul LIFO (Last In, First Out)?",
		"a": ["Coada (Queue)", "Stiva (Stack)", "Vectorul", "Arborele"],
		"corect": 1 
	},
	{
		"q": "Programare C: Care este specificatorul de format folosit pentru afișarea unui număr întreg (int)?",
		"a": ["%f", "%c", "%d", "%s"],
		"corect": 2
	},
	{
		"q": "Digitală: Care este rezultatul operației logice AND între 1 și 0?",
		"a": ["1", "0", "Nu se poate determina", "High Impedance"],
		"corect": 1
	},
	{
		"q": "Disp. Electronice: Care este funcția principală a unei diode redresoare?",
		"a": ["Amplifică semnalul", "Permite curentul într-un singur sens", "Stochează energie", "Scade tensiunea la 0"],
		"corect": 1
	},
	{
		"q": "Analogică: Care este unitatea de măsură pentru Rezistența electrică?",
		"a": ["Volt (V)", "Amper (A)", "Ohm (Ω)", "Watt (W)"],
		"corect": 2
	},
	{
		"q": "Arhitectura Calc: Ce înseamnă RAM?",
		"a": ["Read Access Memory", "Random Access Memory", "Run All Memory", "Real Action Memory"],
		"corect": 1
	},
	{
		"q": "Metode Numerice: Care este baza sistemului de numerație binar?",
		"a": ["10", "16", "2", "8"],
		"corect": 2
	},
	{
		"q": "Semnale: În ce se măsoară frecvența unui semnal?",
		"a": ["Secunde", "Hertz (Hz)", "Metri", "Decibeli"],
		"corect": 1
	},
	{
		"q": "Math (Alg. Liniară): Care este determinantul unei matrici unitate (identitate)?",
		"a": ["0", "1", "-1", "Infinit"],
		"corect": 1
	},
	{
		"q": "Calculatoare: Câți biți are un Byte (Octet)?",
		"a": ["4 biți", "8 biți", "16 biți", "32 biți"],
		"corect": 1
	}
]

func verifica_raspuns(id_intrebare, index_raspuns_ales):
	var raspuns_corect = intrebari[id_intrebare]["corect"]
	
	if index_raspuns_ales == raspuns_corect:
		print("Corect!")
		return true
	else:
		greseli += 1
		print("Gresit! Total greseli: ", greseli)
		check_game_over()
		return false

func check_game_over():
	if greseli >= 3:
		print("Ai pierdut! Restart.")
		greseli = 0
		get_tree().reload_current_scene()
