extends Node

var greseli = 0

var intrebari = [
	{
		"q": "SD: Care este complexitatea timpului pentru construirea unui Max-Heap dintr-un array nesortat (Build-Heap)?",
		"a": ["O(n log n)", "O(n)", "O(log n)", "O(n^2)"],
		"corect": 1 
	},
	{
		"q": "Math. Speciale: Care este reziduul funcției f(z) = 1/(z^2 + 1) în polul z = i?",
		"a": ["1 / 2i", "-1 / 2i", "0", "2i"],
		"corect": 0
	},
	{
		"q": "Metode Numerice: Care este ordinul de convergență al metodei Newton-Raphson pentru o rădăcină simplă?",
		"a": ["Liniar (1)", "Pătratic (2)", "Cubic (3)", "Exponențial"],
		"corect": 1
	},
	{
		"q": "Disp. Electronice: Ce fenomen apare într-un tranzistor BJT din cauza modulării lățimii bazei?",
		"a": ["Efectul Zener", "Efectul Hall", "Efectul Early", "Efectul Miller"],
		"corect": 2
	},
	{
		"q": "Analogică: Conform criteriului Barkhausen, care este defazajul total necesar pe buclă pentru oscilație?",
		"a": ["90 grade", "180 grade", "0 sau 360 grade", "45 grade"],
		"corect": 2
	},
	{
		"q": "Digitală: Ce apare la ieșirea unui circuit combinațional când intrările se schimbă și cauzează un glitch temporar?",
		"a": ["Hazard (Alea)", "Metastabilitate", "Jitter", "Crosstalk"],
		"corect": 0
	},
	{
		"q": "Programare C: Ce va afișa: int x=10; int *p=&x; printf('%d', *p++); ?",
		"a": ["11", "10", "Adresa lui x", "Eroare de compilare"],
		"corect": 1
	},
	{
		"q": "Semnale: Unde trebuie să se afle polii funcției de transfer H(z) pentru ca un sistem LTI cauzal să fie stabil?",
		"a": ["În afara cercului unitate", "Pe axa imaginară", "În semiplanul stâng", "În interiorul cercului unitate"],
		"corect": 3
	},
	{
		"q": "Math (Alg. Liniară): Care sunt valorile proprii (eigenvalues) posibile pentru o matrice idempotentă (A^2 = A)?",
		"a": ["Doar 0", "Doar 1", "0 și 1", "-1 și 1"],
		"corect": 2
	},
	{
		"q": "Analogică: Ce reprezintă CMRR (Raportul de rejecție pe mod comun) la un Amplificator Operațional?",
		"a": ["Ad / Ac", "Ac / Ad", "Vout / Vin", "Zin / Zout"],
		"corect": 0
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
