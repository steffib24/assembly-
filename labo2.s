.global main

main:
	//Lire a : Entier signe de 16 bits
	adr x0, fmtEntree
	adr x1, nombre
	bl scanf
	adr x19, nombre
	ldrsh w19,[x19]

	//Lire b : entier signe de 16 bits

	adr x0, fmtEntree
	adr x1, nombre
	bl scanf
	adr x20, nombre
	ldrsh w20,[x20]

	//Faire addition a + b sur 32 bits

	add w23, w20, w19
	b printSum

	//Faire addition a + b sur 16 bits --> dire s'il y a debordement

	seizeBit:
	
		mov w25, 32767
		mov w24, -32768

		add w23, w20, w19

		cmp w23, w25
		b.gt printDebordement
		//neg w25, w25
		cmp w23,w24
		b.le printDebordement
		b printPasDebordement
	//Faire multiplication de a x b sur 32 bits
	Mult:
		mov x24, 2	// diviseur
		mov x25, 0	// registre qui stocke temporairement a. On l'utilise pour rajouter les zeros necessaires
		mov x26, 0	// registre qui stocke le resultat de la multiplication.
		mov x27, 0	// compteur de loop : Le nombre de fois que l'on fait la boucle "loop".
		mov x28, 0 	// compteur de boucle a l'interieur de la boucle "loop"

		loop:
			/*
			Verifie si le premier bit a la droite (le plus faible) est egale a zero
			Si le bit est egal a zero, on va a l'etiquette prochainBit, sinon on continue
			*/
			tbz x20, 0, prochainBit

		bitEgalZero:
			// Rajoute a au registre x25 (soit le registre temporaire)
			add x25, x25, x19
			cmp x27, x28
			// Si la valeur dans x27 est egale a la valeur dans x28, aller a l'etiquette "continue". Sinon, continuer plus bas
			b.eq continue

			addZeros:
				//multiply d by 2 the number of required times to add as many zeros as we want
				//if we are on the first loop dont add zeros.
				add x25, x25, x25	// Multiplication de x25 par 2. Ceci rajoute un 0 dans la position la plus faible
				add x28, x28, 1		// Rajoute un au compteur de boucle
			 	cmp x28, x27
				// Si le nombre de boucle dans "addZeros" (x28) et le nombre de boucle
				// dans "loop" (x27) sont differents, aller a l'etiquette addZeros
				b.ne addZeros

		continue:
			// Transferer la valeur dans le registre temporaire vers le registre qui stockera le resultat de la multiplication
			add x26, x26, x25

		prochainBit:
			add x27, x27, 1 //Rajoute 1 au compteur de la boucle "loop"
			mov x28, 0		//Ramene le compteur de la boucle "addZeros" a 0
			mov x25, 0		// Ramene le registre temporaire a 0
			udiv x20, x20, x24 //Divise la valeur de b par 2. Ceci enleve le bit du poids le plus faible
			cmp x20, 0
			b.ne loop	//si b est different de zero, aller a l'etiquette loop
			b printMultiply	//aller a l'etiquette printMultiply pour imprimer le resultat de la multiplication

printSum:
	adr x0, fmtSortie
	mov w1, w23
	bl printf
	b seizeBit



printDebordement:
	adr x0, msgDebordement
	bl printf
	b Mult

printPasDebordement:
	adr x0, msgSansDebordement
	bl printf
	b Mult

printMultiply:
	adr x0, fmtSortie
	mov x1, x26
	bl printf

    mov     x0, 0
    bl      exit

.section ".bss"
nombre:		.skip	2
.section ".rodata"
fmtEntree:          .asciz  "%hd"
fmtSortie:          .asciz  "%d\n"
msgDebordement:     .asciz  "débordement\n"
msgSansDebordement: .asciz  "sans débordement\n"
