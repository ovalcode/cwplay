use16
org 0x7C00 ; boot sector address

        lgdt [GlobalDescriptorPointer] ; load the GDT  
        lidt [InterruptDescriptorPointer]
        mov eax,cr0 ; eax = machine status word (MSW)
        or al,1     ; set the protection enable bit of the MSW to 1
	;
        cli         ; disable interrupts
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
InterruptDescriptorTableEnd:

use32
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
      ;sti
      div cl
        mov al,70
mov bx,0x10
mov ds,bx
mov fs,bx
mov ebx,0xB8000 ; address of first char for VGA mode 3
mov [fs:ebx],al	; write char to display memory

;temp: jmp temp
	


test2: jmp test2

int0:
        mov al,67
mov bx,0x10
mov ds,bx
mov fs,bx
mov ebx,0xB8000 ; address of first char for VGA mode 3
mov [fs:ebx],al	; write char to display memory
intloop: jmp intloop

PadOutWithZeroesSectorOne:
	times ((0x200 - 2) - ($ - $$)) db 0x00


BootSectorSignature:
	dw 0xAA55

