;prg14_22.asm
MASM
MODEL	small,c
.stack	100h
.code
	public	sum_asm
sum_asm	proc	c near adr_mas:word,len_mas:word
	mov	ax,0
	mov	cx,len_mas	;����� ���ᨢ� - � cx
	mov	si,adr_mas	;���� ���ᨢ� - � si
	add	ax,[si]	;᫮����� �������� � ����⮬ ���ᨢ�
	add	si,2	;���ᮢ��� ᫥���騩 ����� ���ᨢ�
	loop	cycl
	ret	;������ �� �㭪樨, १���� - � ax
sum_asm	endp
end

