;---------Prg_7_2.asm---------------
masm
model small
.data
str_1 db '��ᥬ���� - ������ �� ��������'
str_2 db 50 dup (' ')
full_pnt dd str_1
.code
start:
	mov	ax,@data	;��뢠�� ॣ���� ds � ᥣ���⮬
	mov	ds,ax	;������ �१ ॣ���� ax
	xor	ax,ax	;��頥� ax
	lea	si,str_1
	lea	di,str_2
	les	bx,full_pnt	;����� 㪠��⥫� �� str1 � ���� es:bx
	mov	cx,19	;������⢮ ����७�� 横�� � cx
m1:
	mov	al,[si]
	mov	[di],al
	inc	si
	inc	di
;横� �� ���� m1 �� ����뫪� ��� ᨬ�����
loop	cx
	exit:
	mov	ax,4c00h	;�⠭����� ��室
	int	21h
end start

