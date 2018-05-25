;*************
;* Green.asm *
;*************

org 0x100

start:
	mov	al, 0x13
	int	0x10
	push	0xa000
	pop	es
	push	0x40
	pop	fs
	mov	di, 0x1928
	mov	ax, 0xa002

Green01:
	mov	cx, 0x100
	rep	stosb
	add	di, 0x40
	dec	ah
	jnz	Green01
	xor	dx, dx

Green02:
	push	dx
	and	dx, 0xf000
	mov	di, dx
	shr	dx, 0x2
	add	di, dx
	pop	dx
	mov	al, dh
	shl	al, 0x4
	add	di, ax
	add	di, 0x1928
	xor	ax, ax
	mov	dl, 0x10

Green03:
	mov	bx, GreenData
	mov	ah, 0x4

Green04:
	mov	cl, dl

Green05:
	stosb
	add	di, [bx]
	loop	Green05
	inc	bx
	inc	bx
	dec	ah
	jnz	Green04
	push	dx
	mov	bx, 0x6c
	mov	dh, [fs:bx]

Green06:
	mov	dl, [fs:bx]
	cmp	dl, dh
	jz	Green06
	pop	dx
	add	di, 0x141
	sub	dl, 0x2
	jnz	Green03
	stosb
	in	al, 0x60
	dec	al
	jz	Green08
	inc	dh
	cmp	dh, 0xa0
	jb	Green02
	mov	ah, 0x9
	mov	dx, strMessage
	int	0x21
	mov	si, 0x7993
	xor	di, di
	std

Green07:
	lods	byte [es:si]
	add	[es:di + 0x140], al
	stosb
	stosb
	or	di, di
	jnz	Green07

Green08:
	xor	ax, ax
	int	0x16
	mov	ax, 0x3
	int	0x10
	ret

strMessage db 'during', 0xd, 0xa
	   db 'watching', 0xd, 0xa
	   db 'this', 0xd, 0xa
	   db 'intro,', 0xd, 0xa
	   db '75 acres', 0xd, 0xa
	   db 'of', 0xd, 0xa
	   db 'rain', 0xd, 0xa
	   db 'forrests', 0xd, 0xa
	   db 'have', 0xd, 0xa
	   db 'been', 0xd, 0xa
	   db 'destroyed', '$'

GreenData  db 0x00, 0x00, 0x3f, 0x01, 0xfe, 0xff, 0xbf, 0xfe
