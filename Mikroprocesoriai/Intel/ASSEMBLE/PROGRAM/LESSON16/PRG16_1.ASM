;prg16_1.asm
.586P		;ࠧ�襭�� ������権 Pentium
.MODEL	large
include	mac.inc
;������� ��� ���ᠭ�� ���ਯ�஢ ᥣ���⮢
descr	STRUC
limit	dw	0
base_1	dw	0
base_2	db	0
attr	db	0
lim_atr	db	0
base_3	db	0
ENDS
;����� ���樠����樨 ���ਯ�஢
load_descr	MACRO	des,seg_addr,seg_size
 	mov	des.limit,seg_size
 	xor	eax,eax
 	mov	ax,seg_addr
 	shl	eax,4
 	mov	des.base_1,ax
 	rol	eax,16
 	mov	des.base_2,al
 	ENDM
atr	MACRO	descr,bit1,bit2,bit3
;����� �ᯮ�짮���� �᫮��� ��४⨢�
;��� �஢�ન ������ ��ࠬ��஢
	atr_&descr=constp or bit1 or bit2 or bit3
	ENDM
;������� ��� ���ᠭ�� �ᥢ�����ਯ�� gdtr
point	STRUC
lim	dw	0
adr	dd	0
	ENDS
;��ਡ��� ��� ���ᠭ�� ���ਯ�஢ ᥣ���⮢
;����ﭭ�� ���� ���� AR ��� ���
;ᥣ���⮢ - ���� 0, 4, 5, 6, 7
constp	equ	10010000b
;��� 1
code_r_n	equ	00010000b	;������ ᥣ����:
			;�⥭�� ����饭�;
code_r_y	equ	00000010b	;������ ᥣ����:
			;�⥭�� ࠧ�襭�
data_wm_n	equ	00000000b	;ᥣ���� ������:
			;����䨪��� ����饭�
data_wm_y	equ	00000010b	;ᥣ���� ������:
			;����䨪��� ࠧ�襭�;
;��� 2
code_n	equ	00000000b	;����� ᥣ���� ����
code_p	equ	00000100b	;���稭���� ᥣ���� ����
data_	equ	00000000b	;��� ᥣ���� ������
stack_	equ	00000000b	;��� ᥣ���� �⥪�
;��� 3
code_	equ	00001000b	;ᥣ���� ����
data_stk	equ	00000000b	;ᥣ���� ������ ��� �⥪�

stk	segment	stack 'stack' use16
	db	256 dup (0)
stk	ends
;⠡��� ��������� ���ਯ�஢
gdt_seg	segment	para public 'data' use16
gdt_0	descr	<0,0,0,0,0,0>	;������� �� �ᯮ������
	atr	gdt_gdt_8,data_wm_y,data_,data_stk
;���� ����뢠�� ᠬ� gdt
gdt_gdt_8	descr	<0,0,0,atr_gdt_gdt_8,0,0>
;�� �ᯮ��㥬
gdt_ldt_10	descr	<0,0,0,0,0,0>
	atr	gdt_ds_18,data_wm_y,data_,data_stk
;���ਯ�� ᥣ���� ������
gdt_ds_18	descr	<0,0,0,atr_gdt_ds_18,0,0>
	atr	gdt_vbf_20,data_wm_y,data_,data_stk
gdt_es_vbf_20	descr	<0,0,0,atr_gdt_vbf_20,0,0>	;���������
	atr	gdt_ss_28,data_wm_y,stack_,data_stk
	gdt_ss_28	descr	<0,0,0,atr_gdt_ss_28,0,0>	;ᥣ���� �⥪�
	atr	gdt_cs_30,code_r_y,code_n,code_
	gdt_cs_30	descr	<0,0,0,atr_gdt_cs_30,0,0>	;ᥣ���� ����
gdt_size=$-gdt_0-1	;ࠧ��� GDT ����� 1
GDT_SEG ENDS
;����� �ணࠬ��
data	segment	para public 'data' use16	;ᥣ���� ������
point_gdt	point	<gdt_size,0>
hello	db	"�뢮� ᮮ�饭�� � ���饭��� ०���"
hel_size=$-hello
tonelow	dw	2651	;������ �࠭�� ���砭�� 450 ��
cnt	db	0	;����稪 ��� ��室� �� �ணࠬ��
temp	dw	?	;������ �࠭�� ���砭��
data_size=$-point_gdt-1
data	ends
code	segment	byte public 'code' use16
;ᥣ���� ���� � 16-ࠧ�來� ०���� ����樨
assume	cs:code,ss:stk
main	proc
	mov	ax,stk
	mov	ss,ax
;������塞 ⠡���� ��������� ���ਯ�஢
assume	ds:gdt_seg
	mov	ax,gdt_seg
	mov	ds,ax
	load_descr	gdt_gdt_8,GDT_SEG,gdt_size
	load_descr	gdt_ds_18,DATA,data_size
	load_descr	gdt_es_vbf_20,0b800h,3999
	load_descr	gdt_ss_28,STK,255
	load_descr	gdt_cs_30,CODE,0ffffh	;code_size
assume	ds:data
	mov	ax,data
	mov	ds,ax
;����㦠�� gdtr
	xor	eax,eax
	mov	ax,gdt_seg
	shl	eax,4
	mov	point_gdt.adr,eax
	lgdt	point_gdt
;����頥� ���뢠���
	cli
	mov	al,80h
	out	70h,al
;��४��砥��� � ���饭�� ०��
	mov	eax,cr0
	or	al,1
	mov	cr0,eax
;����ࠨ���� ॣ�����
	db	0eah	;��設�� ��� ������� jmp
	dw	offset protect	;ᬥ饭�� ��⪨ ���室�
			;� ᥣ���� ������
	dw	30h	;ᥫ���� ᥣ���� ����
			;� ⠡��� GDT
protect:
;����㧨�� ᥫ����� ��� ��⠫��� ���ਯ�஢
	mov	ax,18h
	mov	ds,ax
	mov	ax,20h
	mov	es,ax
	mov	ax,28h
	mov	ss,ax
;ࠡ�⠥� � ���饭��� ०���:
;�뢮��� ��ப� � ���������
	mov	cx,hel_size	;����� ᮮ�饭��
	mov	si,offset hello	;���� ��ப� ᮮ�饭��
	mov	di,1640	;��砫�� ���� ��������� ��� �뢮��
	mov	ah,07h	;��ਡ�� �뢮����� ᨬ�����
outstrr:
	mov	al,[si]
	mov	es:[di],ax
	inc	si
	inc	di
	inc	di
	loop	outstrr
;����᪠�� �७�
go:
;����ᨬ ᫮�� ���ﭨ� 110110110b (0�6h):
;�롨ࠥ� ��ன ����� ���� 43h - �������
	mov	ax,0B06h
	out	43h,ax	;� ���� 43h
	in	al,61h	;����稬 ���祭�� ���� 61h � al
	or	al,3	;���樠�����㥬 ������� - ������ ⮪
	out	61h,al	;� ���� 61h
	mov	cx,2083	;������⢮ 蠣��
musicup:
;� ax ���祭�� ������ �࠭��� ����� 1193000/2651 = 450 ��,
;��� 1193000- ���� ��������
	mov	ax,tonelow
	out	42h,al	;al � ���� 42h
	mov	al,ah	;����� ����� al � ah
	out	42h,al	;���訩 ����ax (ah) � ���� 42h
	add	tonelow,1	;㢥��稢��� �����
	delay	1	;����প� �� 1 ���
	mov	dx,tonelow	; ⥪�饥 ���祭�� ����� � dx
	mov	temp,dx	;temp - ���孥� ���祭�� �����
	loop	musicup	;������� 横� ����襭��
	mov	cx,2083
musicdown:
	mov	ax,temp	;���孥� ���祭�� ����� � ax
	out	42h,al	;����訩 ����ax (al)� ���� 42h
	mov	al,ah	;����� ����� al � ah
	out	42h,al	;� ���� 42h 㦥 ���訩 ���� ax (ah)
	sub	temp,1	;㬥��蠥� ���祭�� �����
	delay	1	;����প� �� 1 ���
	loop	musicdown	;������� 横� ���������
nosound:
	in	al,61h	;����稬 ���祭�� ���� 61h � al
;᫮�� ���ﭨ� - �몫�祭�� �������� � ⠩���
	and	al,0FCh
	out	61h,al	;� ���� 61h
	mov	dx,2651	;��� ��᫥����� 横���
	mov	tonelow,dx
;㢥��稢��� ����稪 ��室�� - ������⢮ ���砭�� �७�
	inc	cnt
	cmp	cnt,5	;5 ࠧ
	jne	go	;�᫨ ��� - ��� �� ���� go
;�ନ஢���� ���ਯ�஢ ��� ॠ�쭮�� ०���
	assume	ds:gdt_seg
	mov	ax,8h
	mov	ds,ax
	mov	gdt_ds_18.limit,0ffffh
	mov	gdt_es_vbf_20.limit,0ffffh
	mov	gdt_ss_28.limit,0ffffh
	mov	gdt_cs_30.limit,0ffffh
assume	ds:data
;����㧪� ⥭���� ���ਯ�஢
	mov	ax,18h
	mov	ds,ax
	mov	ax,20h
	mov	es,ax
	mov	ax,28h
	mov	ss,ax
	db	0eah
	dw	offset jump
	dw	30h
jump:
	mov	eax,cr0
	and	al,0feh
	mov	cr0,eax
	db	0eah
	dw	offset r_mode
	dw	code
r_mode:
	mov	ax,data
	mov	ds,ax
	mov	ax,stk
	mov	ss,ax
;ࠧ�蠥� ���뢠���
	sti
	xor	al,al
	out	70h,al
;����砭�� ࠡ��� �ணࠬ�� (�⠭���⭮)
	mov	ax,4c00h
	int	21h
main	endp
code	ends
	end	main
