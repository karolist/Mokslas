;prg14_20.asm
MASM
MODEL small,C		;������ ����� � ⨯ ����
STACK	256
.code
main:
asmproc	proc	c near ch:BYTE,x:WORD,y:WORD,kol:WORD
PUBLIC _asmproc	;ᨬ��� ����ન����� ��易⥫��
	mov	dh,y	;y-���न��� ᨬ���� � dh
	mov	dl,x	;x-���न��� ᨬ���� � dl
	mov	ah,02h	;����� �㦡� BIOS
	int	10h	;�맮� ���뢠��� BIOS
	mov	ah,09h	;����� �㦡� BIOS
	mov	cx,kol	;kol - ������⢮ "�뢮���" � cx
	mov	bl,07h	;��᪠ �뢮�� � bl
	xor	bh,bh
	mov	al,ch	;ch - ᨬ��� � al
	int	10h	;�맮� ���뢠��� BIOS
	ret		;������ �� ��楤���
asmproc	endp
end	main

