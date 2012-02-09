;pril_8.asm
;������������ ������ �o �����������: 
;1-���������� ����� ������;
;2-����� ������;
;3-�������� ������.
.386
MASM
MODEL	use16 small	;������ ������
STACK	256	;������ �����
include	mac.inc	;����������� ����� � ���������

worker	struc	;������������ ����������
nam	db	30 dup (' ')	;�������, ���, ��������
sex	db	' '	;���
position	db	30 dup (' ')	;���������
age	db	2 dup (' ')	;�������
standing	db	2 dup (' ')	;����
salary	db	4 dup (' ')	;����� � ������
birthdate	db	8 dup (' ')	;���� ��������
worker	ends

.data
N=5			;����������� ���� ������
;������ ��������
StrWork	worker	<>	;������� ��������� ��� ��������� ������������� �����������	
sotr	worker N DUP (<>)	;������ ��������

mes1	db	10,13,10,13,'*************************************'
	db	10,13,'*������������ ������ �� �����������:*'
	db	10,13,'*������ ������:                     *'
	db	10,13,'*1-����������;                      *'
 	db	10,13,'*2-�����;                           *'
 	db	10,13,'*3-��������;                        *'
	db	10,13,'*0-�����.                           *'
	db	10,13,'*************************************'
	db	10,13,'������� ����� : ','$'


mname	db	10,13,10,13,'������� ��� (�� ����� 30 ��������) - $'
msex	db	10,13,'������� ��� (''�'' ��� ''�'') - $'
mposition	db	10,13,'������� ��������� (�� ����� 30 ��������) - $'
mage	db	10,13,'������� ������� (�� ����� 2 ��������) - $'
mstanding	db	10,13,'������� ���� ������ (�� ����� 2 ��������) - $'
msalary	db	10,13,'������� ����� (�� ����� 4 ��������) - $'
mbirthdate	db	10,13,'������� ���� ��������� (��.��.��) - $'

findname	db	10,13,10,13,'������� ��� ��� ������ - $'
mes2	db	10,13,10,13,'��� - '
mname1	db	30 dup (' ')
	db	10,13,'��� - '
msex1	db	' '
	db	10,13,'��������� - '
mposition1	db	30 dup (' ')
	db	10,13,'������� - '
mage1	db	2 dup (' ')
	db	10,13,'���� - '
mstanding1	db	2 dup (' ')
	db	10,13,'����� - '
msalary1	db	4 dup (' ')
	db	10,13,'���� �������� - '
mbirthdate1	db	8 dup (' '),'$'

mes3	db	10,13,10,13,'������ ������� �������!','$'
Err1	db	10,13,10,13,'��� ����� � ���� ������.','$'
Err2	db	10,13,10,13,'����� ������ ��� � ���� ������! ��������� ������.','$'
Thanks	db	10,13,10,13,'������� �� ��������! ������� � �������� ����������!','$'
Flag	db	0	;���� ��� ������������� � ��������� delete

.code
	assume	ds:@data,es:@data
main:		;������ ���������
	mov	ax,@data
	mov	ds,ax	
	xor	ax,ax
	push	ds
	pop	es
;����� ������ ������:
go:
	OutStr	mes1	;����� ������ mes1 �� �����
	GetChar		;���� � ����������� ������ ������
	cmp	al,31h
	je	insert
	cmp	al,32h
	je	search
	cmp	al,33h
	je	delete
	cmp	al,30h
	je	exit
	jmp	go

Insert	proc
;���������� ����� ������
;��������� ������� ���������
	OutStr	mname	
	GetStr	StrWork.nam,30
	OutStr	msex	
	GetStr	StrWork.sex,1
	OutStr	mposition	
	GetStr	StrWork.position,30
	OutStr	mage	
	GetStr	StrWork.age,2
	OutStr	mstanding	
	GetStr	StrWork.standing,2
	OutStr	msalary	
	GetStr	StrWork.salary,4
	OutStr	mbirthdate	
	GetStr	StrWork.birthdate,8
;����� ���������� �������� � ������� �������� (� ��� ��� ���� ������):
	lea	di,sotr
	mov	cx,N
cyc1:
	cmp	[di].sex,' '	;����� ������ ��������� ������ �� ������� ���� sex
	je	m1
	add	di,type	worker
	loop	cyc1
	OutStr	Err1
	jmp	go
;�������� StrWork � ��������� ������ ���� ������
m1:			
	lea	si,StrWork	;������ - ds:si
;				;���� - es:di (��� ���������)
	mov	cx,type worker
rep	movsb
;����������� � ������ �� �������� ���� ���������:
	jmp	go
Insert	endp

search	proc	near
;��������a ������ ������ � ������� � ������ �� ����� �� �����������
	OutStr	findname
	GetStr	StrWork.nam,30
	push	ds
	pop	es	
	lea	bx,sotr
	mov	cx,N
cyc2:	
	push	cx
	mov	cx,30
	mov	di,bx	
	lea	si,StrWork
repe	cmpsb		;����� ������ ����� ��������� �������
	jcxz	m2	;���� ������� ���������, �� ������� �� m2
	add	bx,type	worker
	pop	cx
	loop	cyc2
	OutStr	Err2
	jmp	go
m2:
	pop	cx	;������ �� ����� cx
	cmp	Flag,0
	je	m22
	ret
m22:
;������� �� ����� ���������� ��������� ������, �� ����� � bx	
	mov_string	mname1,[bx].nam,30
	mov_string	msex1,[bx].sex,1
	mov_string	mposition1,[bx].position,30
	mov_string	mage1,[bx].age,2
	mov_string	mstanding1,[bx].standing,2
	mov_string	msalary1,[bx].salary,4
	mov_string	mbirthdate1,[bx].birthdate,8
	OutStr	mes2
	jmp	go
search	endp	

delete	proc
;�������� - ������� ����� ��������� ��������� 
;������� ������ ������ ��� �������� ������, ��� �����
;�������� ���������� ��� ��������� search.
	mov	Flag,1	;������� �� ��������� ������������� ���� search
	call	search
	mov	Flag,0	;������� Flag
;����� ��������� ������ � bx
;������� ���� ������, ��� ���� ���������� ������������ null_string
	null_string	[bx].nam,30
	null_string	[bx].sex,1
	null_string	[bx].position,30
	null_string	[bx].age,2
	null_string	[bx].standing,2
	null_string	[bx].salary,4
	null_string	[bx].birthdate,8
	OutStr	mes3
	jmp	go
delete	endp

exit:
	OutStr	Thanks
	_Exit	;����������� �����;
end	main		;����� ���������;
