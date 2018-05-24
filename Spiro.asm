;*************
;* Spiro.asm *
;*************

org 0x100

start:
	mov	ax, 0x13
	int	0x10
	push	0xa000
	pop	es
	xor	ax, ax
	mov	dx, 0x3c8
	out	dx, al
	inc	dx

Spiro01:
	xchg	al, ah
	out	dx, al
	xchg	al, ah
	out	dx, al
	out	dx, al
	inc	ax
	inc	ax
	test	al, 0x40
	jz	Spiro01
	mov	si, 0x1d4
	mov	bp, 0x1fc

Spiro02:
	fninit
	fld	dword [bp]
	fldlg2
	fmul	st0, st0
	fmul	st0, st0
	xor	ebx, ebx
	xor	edx, edx
	fild	word [si]
	lodsw
	fild	word [si]
	lodsw
	mov	dx, ax
	fild	word [si]
	fsubp	st1, st0
	lodsw
	mov	bx, ax
	lodsw
	mov	cx, ax
	xor	ax, ax

Spiro03:
	pushad
	cmp	al, 0xb4
	ja	Spiro05

Spiro04:
	add	[bp + 0x4], ebx
	sub	[bp + 0x8], edx
	push	dx
	fild	dword [bp + 0x4]
	fmul	st0, st3
	fmul	st0, st3
	fsincos
	fmul	st0, st2
	fxch	st1
	fmul	st0, st2
	fild	dword [bp + 0x8]
	fmul	st0, st5
	fmul	st0, st5
	fsincos
	fmul	st0, st5
	fxch	st1
	fmul	st0, st5
	faddp	st2, st0
	faddp	st2, st0
	fistp	word [bp + 0xc]
	mov	ax, 0x140
	imul	word [bp + 0xc]
	fmul	st, st4
	fistp	word [bp + 0xc]
	mov	di, [bp + 0xc]
	add	di, ax
	mov	byte [es:di + 0x7da0], 0x1f
	pop	dx
	loop	Spiro04

Spiro05:
	mov	dx, 0x3da

Spiro06:
	in	al, dx
	test	al, 0x8
	jz	Spiro06
	in	al, 0x60
	dec	al
	jz	Spiro10
	popad
	xor	di, di

Spiro07:
	cmp	byte [es:di], 0x0
	jz	Spiro09
	test	cl, 0x1
	jz	Spiro08
	inc	byte [es:di]
	jmp	Spiro09

Spiro08:
	dec	byte [es:di]

Spiro09:
	inc	di
	jnz	Spiro07
	add	al, 0x2
	jnz	Spiro03
	mov	cx, 0x7d00
	rep	stosw
	cmp	si, 0x1fc
	jnz	Spiro02

Spiro10:
	mov	ax, 0x3
	int	0x10
	ret

  db 0x1b, 0x00, 0x4f, 0x00, 0x0d, 0x00, 0xd0, 0x07
  db 0x30, 0x00, 0x6c, 0x00, 0x48, 0x00, 0x53, 0x00
  db 0x1c, 0x00, 0x78, 0x00, 0x48, 0x00, 0x65, 0x00
  db 0x0f, 0x00, 0x64, 0x00, 0x28, 0x00, 0x90, 0x01
  db 0x1f, 0x00, 0x50, 0x00, 0x19, 0x00, 0x53, 0x03
  db 0x33, 0x33, 0x93, 0x3f
