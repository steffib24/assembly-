.include "macros.s"
.global  main

main:                           // main()
    // Lire mots w0 et w1       // {
    //             à déchiffrer //
    adr     x0, fmtEntree       //
    adr     x1, temp            //
    bl      scanf               //   scanf("%X", &temp)
    ldr     w19, temp           //   w0 = temp
                                //
    adr     x0, fmtEntree       //
    adr     x1, temp            //
    bl      scanf               //   scanf("%X", &temp)
    ldr     w20, temp           //   w1 = temp
                                //
    // Déchiffrer w0 et w1      //
    mov     w0, w19             //
    mov     w1, w20             //
    ldr     w2, k0              //
    ldr     w3, k1              //
    ldr     w4, k2              //
    ldr     w5, k3              //
    bl      dechiffrer          //   w0, w1 = dechiffrer(w0, w1, w2, w3, w4, w5)
                                //
    // Afficher message secret  //
    mov     w19, w0             //
    mov     w20, w1             //
                                //
    adr     x0, fmtSortie       //
    mov     w1, w19             //
    mov     w2, w20             //
    bl      printf              //   printf("%c %c\n", w0, w1)
                                //
    // Quitter programme        //
    mov     x0, 0               //
    bl      exit                //   return 0
                                // }
/*******************************************************************************
  Procédure de déchiffrement de l'algorithme TEA
  Entrées: - mots w0 et w1 à déchiffrer (32 bits chacun)
           - clés w2, w3, w4 et w5      (32 bits chacune)
  Sortie: mots w0 et w1 déchiffrés
*******************************************************************************/
dechiffrer:
	SAVE
	mov w6, 1							// i = 1

boucle_dechiffrer: 	 					//tant que i <= 32
	cmp w6, 32
	b.hi fin_boucle_dechiffrer

	bl decode							//wo, w1 <- decode (wo, w1, w2, w3, w4, w5)
	mov w21, w0
	mov w22, w1
	add w6, w6, 1						//i++
	b boucle_dechiffrer

fin_boucle_dechiffrer:
	mov w0, w21							//retourner w0, w1
	mov w1, w22
	RESTORE
	ret

decode:
	SAVE

	//donnees reutilisés
	ldr w7, delta						// delta
	mov w8, 33							// 33
	sub w23, w8, w6 					// 33 - i
	mul w23, w23, w7					// (33 - i) * delta

	//first half of diagram
	lsl w24, w0, 4						// w0 decalage de 4 bits vers la gauche
	add w24, w24, w4					// add w4
	add w27, w0, w23					// w0 + ((33 - i) * delta)
	lsr w25, w0, 5						// w0 decalage de 5 bits vers la gauche
	add w25, w25, w5					// add w5
	eor w24, w24, w27					// ou exclusif
	eor w24, w24, w25					// ou exclusif
	sub w24, w1, w24					// W1 - W24

	//second half of diagram
	lsl w26, w24, 4						// decalage 4 bits vers la gauche
	add w26, w26, w2					// add w2
	add w27, w24, w23					// add 	(33 - i) * delta
	lsr w28, w24, 5						// decalage 5 bits vers la gauche
	add w28, w28, w3					// add w3
	eor w9, w26, w27					// ou exclusif
	eor w9, w9, w28					// ou exclusif
	sub w25, w0, w9					// W0 - W29

	//return w0' et w1'
	mov w0, w25
	mov w1, w24

RESTORE
	ret

.section ".rodata"
k0:         .word   0xABCDEF01
k1:         .word   0x11111111
k2:         .word   0x12345678
k3:         .word   0x90000000
delta:      .word   0x9E3779B9

fmtEntree:  .asciz  "%X"
fmtSortie:  .asciz  "%c %c\n"

.section ".data"
            .align  4
temp:       .skip   4
