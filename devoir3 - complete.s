.global main



main:

adr x28, acc
str xzr, [x28]
str xzr, [x28, 8]
adr x19, mem			//mem[0]
str xzr, [x19]			//mem[1]
str xzr, [x19, 8]		//mem[1]
str xzr, [x19, 16]		//mem[2]
str xzr, [x19, 24]		//mem[2]
str xzr, [x19, 32]		//mem[2]
str xzr, [x19, 40]		//mem[3]
str xzr, [x19, 48]		//mem[3]
str xzr, [x19, 56]

//affiche acc: avec les valeurs de x0
displayData:

	adr x0, fmtAcc
	ldr x1, [x28]
	ldr x2, [x28, 8]
	bl printf
	adr x0, fmtMem
	mov x1, 0
	ldr x2, [x19]
	ldr x3, [x19, 8]
	bl printf


	adr x0, fmtMem
	mov x1, 1
	ldr x2, [x19, 16]
	ldr x3, [x19, 24]
	bl printf


	adr x0, fmtMem
	mov x1, 2
	ldr x2, [x19, 32]
	ldr x3, [x19, 40]
	bl printf


	adr x0, fmtMem
	mov x1, 3
	ldr x2, [x19, 48]
	ldr x3, [x19, 56]
	bl printf





	//reader of inputs
	adr x0, fmtNum
	adr x1, nombre
	bl scanf
	ldr x20, nombre

	//switch case
	cmp x20, 0
	b.eq case0
	cmp x20, 1
	b.eq case1
	cmp x20, 2
	b.eq case2
	cmp x20, 3
	b.eq case3
	cmp x20, 4
	b.eq case4

//exit instruction
case5:
	mov 	x0, 0
	b		exit

//assign a value to accumulator
case0:

	adr  x0, fmtNum
	adr x1, nombre
	bl	scanf
	ldr x22, nombre

	str x22, [x28, 8]

	b displayData

//copy accumulator value in a cell
case1:
	adr x0, fmtNum
	adr x1, nombre
	bl scanf
	ldr x23, nombre

	ldr x26,[x28]
	ldr x21,[x28,8]

	cmp	x23,0
	b.eq	mem0
	cmp	x23,1
	b.eq	mem1
	cmp	x23,2
	b.eq	mem2
	cmp	x23,3
	b.eq	mem3
	//cleaning of registers
	//copy cells content in accumulator
case2:

	adr		x0, fmtNum
	adr 	x1, nombre
	bl 		scanf
    ldr		x23, nombre

	cmp	x23,0
	b.eq	Accum0
	cmp	x23,1
	b.eq	Accum1
	cmp	x23,2
	b.eq	Accum2
	cmp	x23,3
	b.eq	Accum3

Accum0:
	ldr x26, [x19]
	ldr x21, [x19,8]
	str	x26, [x28]
	str x21, [x28,8]
	b displayData
Accum1:
ldr x26, [x19,16]
ldr x21, [x19,24]
str	x26, [x28]
str x21, [x28,8]

	b displayData
Accum2:
ldr x26, [x19,32]
ldr x21, [x19,40]
str	x26, [x28]
str x21, [x28,8]
	b displayData
Accum3:
ldr x26, [x19,48]
ldr x21, [x19,56]
str	x26, [x28]
str x21, [x28,8]
	b displayData



//addition cellule + accumulateur
case3:

	adr		x0, fmtNum
	adr 	x1, nombre
	bl 		scanf
	ldr		x23, nombre

	cmp x23,0
	b.eq addim0
	cmp x23,1
	b.eq addim1
	cmp x23,2
	b.eq addim2
	cmp x23,3
	b.eq addim3

addim0:
	ldr x26,[x19]
	ldr x21,[x28]
	adds x21,x26,x21
	str x21, [x19]
	ldr x26, [x19,8]
	ldr x21,[x28,8]
	adc x21, x26,x21
	str x21,[x19,8]
	b displayData

addim1:
	ldr x26,[x19,16]
	ldr x21,[x28]
	adds x21,x26,x21
	str x21, [x19,16]
	ldr x26, [x19,24]
	ldr x21,[x28,8]
	adc x21, x26,x21
	str x21,[x19,24]
	b displayData
addim2:
	ldr x26,[x19,32]
	ldr x21,[x28]
	adds x21,x26,x21
	str x21, [x19]
	ldr x26, [x19,32]
	ldr x21,[x28,40]
	adc x21, x26,x21
	str x21,[x19,40]
	b displayData
addim3:
	ldr x26,[x19,48]
	ldr x21,[x28]
	adds x21,x26,x21
	str x21, [x19]
	ldr x26, [x19,48]
	ldr x21,[x28,56]
	adc x21, x26,x21
	str x21,[x19,56]
	b displayData

// soustraction of cellule minus acculator
case4:

	adr		x0, fmtNum
	adr 	x1, nombre
	bl 		scanf
	ldr		x23, nombre

	cmp x23,0
	b.eq subim0
	cmp x23,1
	b.eq subim1
	cmp x23,2
	b.eq subim2
	cmp x23,3
	b.eq subim3

subim0:
		ldr x26,[x19]
		ldr x21,[x28]
		subs x21,x26,x21
		str x21, [x19]
		ldr x26, [x19,8]
		ldr x21,[x28,8]
		sbc x21, x26,x21
		str x21,[x19,8]
		b displayData

subim1:
		ldr x26,[x19,16]
		ldr x21,[x28]
		subs x21,x26,x21
		str x21, [x19,16]
		ldr x26, [x19,24]
		ldr x21,[x28,8]
		sbc x21, x26,x21
		str x21,[x19,24]
		b displayData
subim2:
		ldr x26,[x19,32]
		ldr x21,[x28]
		subs x21,x26,x21
		str x21, [x19]
		ldr x26, [x19,32]
		ldr x21,[x28,40]
		sbc x21, x26,x21
		str x21,[x19,40]
		b displayData
subim3:
		ldr x26,[x19,48]
		ldr x21,[x28]
		subs x21,x26,x21
		str x21, [x19]
		ldr x26, [x19,48]
		ldr x21,[x28,56]
		sbc x21, x26,x21
		str x21,[x19,56]
		b displayData


	// cleaning of registres & display of data
mem0:
	str x26, [x19]
	str x21, [x19,8]
	b displayData
mem1:
	str x26, [x19,16]
	str x21, [x19,24]
	b displayData
mem2:
	str x26, [x19,32]
	str x21, [x19,40]
	b displayData
mem3:
	str x26, [x19,48]
	str x21, [x19,56]
		b displayData



.section ".rodata"
fmtNum: 		.asciz 	"%lu"
fmtAcc:         .asciz  "acc:    %016lX %016lX\n"
fmtMem:         .asciz  "mem[%lu]: %016lX %016lX\n"


.section ".bss"

				//.align 8
mem:			.skip 	64
acc:			.skip 	16
						.align 	8
nombre:			.skip 	8
/*
    autres données ici
                        */
