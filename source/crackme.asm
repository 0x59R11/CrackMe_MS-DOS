.model small
.stack 100h
.data
	titlemsg db "Enter serial number: $"
	correctmsg db "The serial number is correct. You have successfully logged in!$"
	incorrectmsg db "Invalid serial number.$"
	
	correctserialnum db 0C9h, 0CEh, 0DAh, 0C1h, 0C3h, 0C9h
.data?
	inputserialnum db 80h, ?, 80h dup(?)
.code
	START:
		mov BX, @data
		mov DS, BX
		
		mov AH, 9h
		mov DX, offset titlemsg
		int 21h
		
		mov AH, 0Ah
		mov DX, offset inputserialnum
		int 21h
		
		mov BX, DX
		mov AH, 0h
		mov AL, byte ptr [BX + 1]
		add BX, AX
		mov word ptr [BX + 3], 240Ah

		mov AH, 09h
		add DX, 2h
		int 21h


		mov SI, offset correctserialnum
		mov DI, offset inputserialnum + 2
		
		mov AL, byte ptr [DI]
		mov BH, 0h
		mov BL, byte ptr [DI - 1]	
		add AL, byte ptr [DI + BX - 1]
		add AL, BL
		
		mov BX, 0h
		
		loop1:
			cmp BX, 6h
			jge correctserial
			
			mov CL, byte ptr [DI + BX]
			xor CL, AL
			cmp CL, byte ptr [SI + BX]
			jne invalidserial
			inc BX
			jmp loop1
			
		invalidserial:
			mov DX, offset incorrectmsg
			jmp endofprogram
		
		correctserial:
			mov DX, offset correctmsg
			
		endofprogram:
			mov AH, 9h
			int 21h
		
		mov AX, 4C00h
		int 21h
end START