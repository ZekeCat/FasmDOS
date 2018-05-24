;**************
;* Amoeba.asm *
;**************

org 0x100

start:
	mov	bp, Buf

	mov	al, 13h      ; graphics mode 320x200  256 colors
	int	10h

Main:
	push	cs
	pop	es
	mov	di, bp
	mov	cx, 64000
	xor	ax, ax
	rep	stosb	     ; clear frame buffer

	push	0a000h	 
	pop	es

	fld	[f]	     ; phase of the angle (initial value) 
	fadd	[f_inc]
	fst	[f]
	fstp	[z]	   

	mov	cx, 350      ; num of spiral points (balls) 

spiral:
	mov	[k], cx
	fld	[f]	     ; f
	fsub	[z]	     ; f-z
	fsub	[z]	     ; f-2*z
	fsincos 	     ; cos(f-2*z) sin(f-2*z)
	fstp	[tmp]	     ; sin(f-2*z)
	fld	[z]	     ; z sin(f-2*z)
	fsub	[z_inc]
	fst	[z]	     ; actual angle for the spiral shape 
	fimul	[Six]	     ; 6*z sin(f-2*z)
	fsincos 	     ; cos(6*z) sin(6*z) sin(f-2*z)
	fimul	[Twenty]     ; 20*cos(6*z) sin(6*z) sin(f-2*z)
	fild	[k]	     ; k cos(6*z) sin(6*z) sin(f-2*z)
	fidiv	[Six]	     ; k/6 cos(6*z) sin(6*z) sin(f-2*z)
	fsubp		     ; k/6-cos(6*z)  sin(6*z) sin(f-2*z)
	fmul	[tmp]	     ; (k/6-cos(6*z))*cos(f-2*z) sin(6*z) sin(f-2*z)
	fiadd	[YC]	     ; yc+(k/6-cos(6*z))*cos(f-2*z) sin(6*z) sin(f-2*z)
	fistp	[Y]	     ; sin(6*z) sin(f-2*z) 

	fimul	[Twenty]     ; 20*sin(6*z) sin(f-2*z)
	fild	[k]	     ; k 20*sin(6*z) sin(f-2*z)
	fidiv	[Three]      ; k/3 20*sin(6*z) sin(f-2*z)
	fsubp		     ; k3-20*sin(6*z) sin(f-2*z)
	fmulp		     ; (k3-20*sin(6*z))*sin(f-2*z)
	fiadd	[XC]	     ; xc+(k3-20*sin(6*z))*sin(f-2*z)
	fistp	[X]

	mov	di, [Y]      ; calculate position of the ball in frame buffer
	imul	di, 320
	add	di, [X]
	add	di, bp
	mov	si, Ball
       
	mov	dh, 5	     ; copy ball-image to the frame buffer  

Row:
	mov	dl, 5

Col:
	lodsb
	or	al, al
	jz	Black
	mov	[di], al

Black:	    
	inc	di
	dec	dl
	jnz	Col
	add	di, 315
	dec	dh
	jnz	Row
       
	dec	cx	     ; to next spiral point
	jnz	spiral

	mov	dx, 3dah     ; sync

retrace:
	in	al, dx
	test	al, 8
	jz	retrace

	xor	di, di	     ; copy frame buffer to screen
	mov	si, bp
	mov	cx, 64000
	rep	movsb

	in	al, 60h      ; check for esc key
	dec	al
	jne	Main 

	mov	ax, 3	     ; text mode
	int	10h

	ret		     ; and back to (D)OS

Ball	db  0, 1, 1, 1, 0    ; image of the ball - it uses standart colors
	db  1,15, 9, 9, 1    ; of the palette after initializing mode 13h
	db  1, 9, 9, 1, 1
	db  1, 9, 1, 0, 1
	db  0, 1, 1, 1, 0

 XC	dw 160		     ; X - center 
 YC	dw 100		     ; Y - center
 Twenty dw 20		     ; 
 Six	dw 6		     ;	constants
 Three	dw 3		     ;
 f_inc	dd 3ca3d70ah	     ; phase increment step
 z_inc	dd 3d9eb852h	     ; angle increment step
 f	dd 0		     ; phase
 z	dd ?		     ; angle
 tmp	dd ?		     ; temporary
 k	dw ?		     ; spiral radius
 X	dw ?		     ; ball X - coordinate 
 Y	dw ?		     ; ball Y - coordinate 

Buf:			     ; Frame Buffer
