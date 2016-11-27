use16
org 0x7C00 ; boot sector address

        mov ah,0
        mov dl,0
        int 0x13
        
        mov ah,2
        mov al,16
        mov dl,0
        mov ch,0
        mov dh,0
        mov cl,2
      
        mov bx, InterruptDescriptorPointer
        int 0x13

        lgdt [GlobalDescriptorPointer] ; load the GDT  
        lidt [InterruptDescriptorPointer]
	;
        cli         ; disable interrupts

        mov al, 0x11
	out 0x20, al; 1 
	
        out 0xa0, al; 2

        mov al, 0x20
        out 0x21, al; 3

        mov al, 0x28
        out 0xa1, al;4
			
        mov al, 0x04
        out 0x21, al;5
			
        mov al, 0x02
        out 0xa1, al;6

        mov al, 0x01
        out 0x21, al; 7		
			
        mov al, 0x01
        out 0xa1, al; 8
			
        mov al, 0x0
        out 0x21, al; 9
			
        mov al, 0x0
        out 0xa1, al; 10
			
        mov eax,cr0 ; eax = machine status word (MSW)
        or al,1     ; set the protection enable bit of the MSW to 1
        ;and eax, 0xfffbffff
        mov cr0,eax ; start protected mode
	;
        ;mov bx,0x08 ; the size of a GDT descriptor is 8 bytes
        ;mov fs,bx   ; fs = the 2nd GDT descriptor, a 4 GB data seg
	;
	; write a status message
	;
	

        jmp 0x8:test


GlobalDescriptorPointer:
  dw GlobalDescriptorTableEnd - GlobalDescriptorTable - 1
  dw GlobalDescriptorTable
  db 0, 0
GlobalDescriptorPointerEnd:

GlobalDescriptorTable:   

	; the global descriptor table is the heart of protected mode
	; entries are used to map virtual to physical memory
	; among other things
	;
	; each descriptor contains 8 bytes, "organized" as follows:
	;
	; |----------------------2 bytes--------------------|
	;
	; +-------------------------------------------------+
	; | segment address 24-31  | flags #2  | len 16-19  | +6
	; +-------------------------------------------------+
	; | flags #1               | segment address 16-23  | +4
	; +-------------------------------------------------+
	; | segment address bits 0-15                       | +2
	; +-------------------------------------------------+
	; | segment length bits 0-15                        | +0
	; +-------------------------------------------------+

	; the high-order bit of flags #2 controls "granularity"
	; setting it to 1 multiplies the segment length by 4096

	;======================================================

	; create two descriptors:
	; one for the GDT itself, plus a 4 gibabyte data segment

	dw 0 
	; segment address bits 0-15, 16-23
	dw 0 
	db 0	
	; flags 1, segment length 16-19 + flags 2
	db 0, 0
	; segment address bits 24-31
	db 0 

	; a code segment based at address 0, 4 gibabytes long
	; 
        dw 0xFFFF 	; segment length 0-15
	db 0, 0, 0 	; segment address 0-15, 16-23
	db 0x9E 	; flags 1
	db 0xCF 	; flags 2, segment length 16-19
	db 0		; segment address 24-31

	;
	; a data segment based at address 0, 4 gibabytes long
	; 
        dw 0xFFFF 	; segment length 0-15
	db 0, 0, 0 	; segment address 0-15, 16-23
	db 0x92 	; flags 1
	db 0xCF 	; flags 2, segment length 16-19
	db 0		; segment address 24-31
	;

GlobalDescriptorTableEnd:




PadOutWithZeroesSectorOne:
	times ((0x200 - 2) - ($ - $$)) db 0x00


BootSectorSignature:
	dw 0xAA55

InterruptDescriptorPointer:
  dw InterruptDescriptorTableEnd - InterruptDescriptorTable - 1
  dw InterruptDescriptorTable
  db 0, 0

InterruptDescriptorPointerEnd:


InterruptDescriptorTable:
  dw int0
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int1
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int2
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int3
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int4
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int5
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int6
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int7
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int8
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int9
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int10
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int11
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int12
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int13
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int14
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int15
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int16
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int17
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int18
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int19
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int20
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int21
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int22
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int23
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int24
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int25
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int26
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int27
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int28
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int29
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int30
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int31
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int32
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int33
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int34
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int35
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int36
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int37
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int38
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int39
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int40
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int41
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int42
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int43
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int44
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int45
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int46
  dw 8
  db 0
  db 0x8e
  dw 0

  dw int47
  dw 8
  db 0
  db 0x8e
  dw 0



InterruptDescriptorTableEnd:

use32

int0:
        cli
        mov al,0
        jmp proc
int1:
        cli
        mov al,1
        jmp proc

int2:
        cli
        mov al,2
        jmp proc

int3:
        cli
        mov al,3
        jmp proc

int4:
        cli
        mov al,4
        jmp proc

int5:
        cli
        mov al,5
        jmp proc

int6:
        cli
        mov al,6
        jmp proc

int7:
        cli
        mov al,7
        jmp proc

int8:
        cli
        mov al,8
        jmp proc

int9:
        cli
        mov al,9
        jmp proc

int10:
        cli
        mov al,10
        jmp proc

int11:
        cli
        mov al,11
        jmp proc

int12:
        cli
        mov al,12
        jmp proc

int13:
        cli
        mov al,13
        jmp proc

int14:
        cli
        mov al,14
        jmp proc

int15:
        cli
        mov al,15
        jmp proc

int16:
        cli
        mov al,16
        jmp proc

int17:
        cli
        mov al,17
        jmp proc

int18:
        cli
        mov al,18
        jmp proc

int19:
        cli
        mov al,19
        jmp proc

int20:
        cli
        mov al,20
        jmp proc

int21:
        cli
        mov al,21
        jmp proc

int22:
        cli
        mov al,22
        jmp proc

int23:
        cli
        mov al,23
        jmp proc

int24:
        cli
        mov al,24
        jmp proc

int25:
        cli
        mov al,25
        jmp proc

int26:
        cli
        mov al,26
        jmp proc

int27:
        cli
        mov al,27
        jmp proc

int28:
        cli
        mov al,28
        jmp proc

int29:
        cli
        mov al,29
        jmp proc

int30:
        cli
        mov al,30
        jmp proc

int31:
        cli
        mov al,31
        jmp proc

int32:
        cli

        mov al, 0x20
        out 0xa0, al  

        mov al, 0x20
        out 0x20, al  

        ;add esp, 8       

mov bx,0x10
mov ds,bx
mov fs,bx

mov ebx,0xB8002 ; address of first char for VGA mode 3
mov al, 65
mov [fs:ebx],al	; write char to display memory

mov ebx,0xB8004 ; address of first char for VGA mode 3
mov al, 'P' 
mov [fs:ebx],al	; write char to display memory

mov ebx,0xB8006 ; address of first char for VGA mode 3
mov al, 'p'
mov [fs:ebx],al	; write char to display memory

        iret

        ;mov al,32
        ;jmp proc

int33:
        cli
        mov al,33
        jmp proc

int34:
        cli
        mov al,34
        jmp proc

int35:
        cli
        mov al,35
        jmp proc

int36:
        cli
        mov al,36
        jmp proc

int37:
        cli
        mov al,37
        jmp proc

int38:
        cli
        mov al,38
        jmp proc

int39:
        cli
        mov al,39
        jmp proc

int40:
        cli
        mov al,40
        jmp proc

int41:
        cli
        mov al,41
        jmp proc

int42:
        cli
        mov al,42
        jmp proc

int43:
        cli
        mov al,43
        jmp proc

int44:
        cli
        mov al,44
        jmp proc

int45:
        cli
        mov al,45
        jmp proc

int46:
        cli
        mov al,46
        jmp proc

int47:
        cli
        ;mov al,47
        mov al, 0x20
        out 0xa0, al  

        mov al, 0x20
        out 0x20, al  

        ;add esp, 8       
        iret
        ;jmp proc



test: nop
      nop
      nop
      nop
      nop
      nop
      nop
      nop
      mov al , 10
      mov cl, 4
    mov bx,0x10
mov ds,bx
mov fs,bx
mov ss, bx

;mov ebx,0xB8000 ; address of first char for VGA mode 3
;mov al, 65
;mov [fs:ebx],al	; write char to display memory

      sti
      ;div cl
       ; mov al,48
;mov bx,0x10
;mov ds,bx
;mov fs,bx
;mov ebx,0xB8000 ; address of first char for VGA mode 3
;mov [fs:ebx],al	; write char to display memory

;temp: jmp temp
	


test2: jmp test2



proc:
mov bx,0x10
mov ds,bx
mov fs,bx

mov ebx,0xB8002 ; address of first char for VGA mode 3
add al, 65
mov [fs:ebx],al	; write char to display memory

mov ebx,0xB8004 ; address of first char for VGA mode 3
mov al, 'P' 
mov [fs:ebx],al	; write char to display memory

mov ebx,0xB8006 ; address of first char for VGA mode 3
mov al, 'p'
mov [fs:ebx],al	; write char to display memory



intloop: jmp intloop


