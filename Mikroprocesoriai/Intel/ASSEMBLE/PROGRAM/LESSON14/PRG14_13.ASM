;prg14_13.asm
;��楤�� �� ��ᥬ����, ������ ��뢠��
;�ணࠬ�� �� Pascal.
;��� �뢮�� �� ��࠭ �ᯮ������� �㦡� BIOS:
;02h - ����樮��஢���� �����.
;09h - �뢮� ᨬ���� �������� ������⢮ ࠧ.
MASM
MODEL	small
STACK	256
.code
asmproc	proc	near
PUBLIC	asmproc	;������ ��� ������
	push	bp	;�஫��
	mov	bp,sp
	mov	dh,[bp+6]	;����� ��ப� ��� �뢮��
			;ᨬ���� y - � dh
	mov	dl,[bp+8]	;����� �⮫�� ��� �뢮��
			;ᨬ���� x - � dl
	mov	ah,02h	;����� �㦡� BIOS
	int	10h	;�맮� ���뢠��� BIOS
;�맮� �㭪樨 09h ���뢠��� BIOS 10h:
;�뢮� ᨬ���� �� al �� ��࠭
	mov	ah,09h	;����� �㦡� BIOS
	mov	al,[bp+10]	;ᨬ��� ch � al
	mov	bl,07h	;��ਡ�� ᨬ���� - � bl
	xor	bh,bh
	mov	cx,[bp+4]	;������⢮ "�뢮���"
			;ᨬ���� - � cx
	int	10h	;�맮� ���뢠��� BIOS
	pop	bp	;����⠭������� bp
;���⪠ �⥪� � ������ �� ��楤���
	ret	8
asmproc	endp	;����� ��楤���
end

