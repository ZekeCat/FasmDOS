;***********
;* Oko.asm *
;***********

org 0x100

start:
	mov	al, 0x13
	int	0x10
Oko01:
	mov	dx, 0x3c8
	mov	al, cl
	out	dx, al
	inc	dx
	test	al, 0x80
	jns	Oko02
	salc

Oko02:
	out	dx, al
	sub	al, cl
	out	dx, al
	out	dx, al
	inc	bx
	loop	Oko01
	push	0xa000
	pop	es
	fld	dword [bx + 0x7d]
	fldz

Oko03:
	fadd	st0, st1
	xor	di, di
	mov	cx, 0xff9c

Oko04:
	mov	ax, 0xff60

Oko05:
	push	ax
	push	cx
	mov	si, sp
	fild	word [si + 0x2]
	fmul	st0, st2
	fild	word [si]
	fmul	st0, st3
	fld	st0
	fcos
	fmul	st0, st2
	fld	st2
	fadd	st0, st4
	fsin
	fmul	st0, st2
	faddp	st1, st0
	fld	st0
	fcos
	fxch	st3
	fmul	st0, st0
	fldpi
	fmul	st1, st0
	fmul	st0, st3
	fmulp	st3, st0
	faddp	st1, st0
	faddp	st1, st0
	fsin
	fmulp	st1, st0
	fimul	word [bx + 0x7b]
	fistp	word [si]
	pop	ax
	stosb
	pop	ax
	inc	ax
	cmp	ax, 0xa0
	jnz	Oko05
	inc	cx
	cmp	cx, 0x64
	jnz	Oko04
	in	al, 60h
	dec	ax
	jnz	Oko03
	ret

;17a
	db 0x3f, 0x00, 0x0a, 0xd7, 0xa3, 0x3c
