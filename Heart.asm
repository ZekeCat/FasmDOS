;*************
;* Heart.asm *
;*************

org 0x100

start:
	mov	al, 0x13
	int	0x10
	push	0xa000
	pop	es

Heart01:
	inc	bp
	mov	ch, 0xff

Heart02:
	mov	ax, di
	xor	dx, dx
	mov	bx, 0x140
	div	bx
	sub	ax, 0x78
	sub	dx, 0xa0
	jg	Heart03
	neg	dx

Heart03:
	mov	bx, ax
	imul	bx, bx
	add	ax, dx
	imul	ax
	add	bx, ax
	jz	Heart04
	xor	dx, dx
	mov	eax, 0x927c0
	div	ebx

Heart04:
	add	ax, bp
	shr	ax, 0x2
	and	al, 0x3f
	add	al, 0x20
	stosb
	loop	Heart02
	in	al, 0x60
	cmp	al, 0x1
	jnz	Heart01
	mov	ax, 0x3
	int	0x10
	ret
