;   DISASSEMBLERIS
;   KESTUTIS KERSIS
;   PROGRAMU SISTEMOS
;   2 GRUPE

.model large

skBufDydis EQU 50h
raBufDydis EQU 60d

.stack 100h
.data
    duom db 20 dup (?)
    rez  db 20 dup (?)
    skBuf db skBufDydis dup (?), "?"
    raBuf db raBufDydis dup (?), 13
    dFail dw ?
    rFail dw ? 
    
    
     
    help   db "Kestutis Kersis 1k. 2gr", 10, 13, "Programa disasembliuoja pasirinkta faila ir iraso rez. i kita faila", 10, 13, "teisingas formatas: disasm [duomenu failas] [rezultatu failas]", "$"   
    klaidosPranesimas db "KLAIDA!$"
    neaptazinta_kom_pranesimas db "NEATPAZINTA"
    adresas dw 100h 
    komandos_ilgis db 0    
    papilde_buf    dw 0
    pr_byte_ptr db 'byte ptr '
    pr_word_ptr db 'word ptr '
    prefix      db ? ;0-jei nera, 1-CS, 2-DS, 3-SS, 4-ES
    pref_cs     db 'CS:'
    pref_ds     db 'DS:'
    pref_ss     db 'SS:'
    pref_es     db 'ES:'
    
    formatai db 1, 1, 1, 1, 7, 7, 6, 6, 08, 09, 0Ah, 0Bh, 0Ch, 0Dh, 6, 6, 10, 11, 12, 13, 14, 15, 6, 6, 18, 19, 01Ah, 01Bh, 01Ch, 01Dh, 6, 6, 20, 21, 22, 23, 24, 25, 26, 27, 1, 1, 1, 1, 7, 7
			 db 02Eh, 02Fh, 30, 31, 32, 33, 34, 35, 36, 37, 1, 1, 1, 1, 7, 7, 03Eh, 03Fh, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 60
			 db 61, 62, 63, 64, 65, 66, 67, 68, 69, 06Ah, 06Bh, 06Ch, 06Dh, 06Eh, 06Fh, 13, 13, 13, 13, 13, 13, 13 
             db 13, 13, 13, 13, 13, 13, 13, 13, 13, 8, 8, 8, 8, 84, 85, 86, 87, 1, 1, 1, 1, 2, 2, 2, 9, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 10, 9Bh, 9Ch, 9Dh, 9Eh, 9Fh
			 db 3, 3, 3, 3, 0A4h, 0A5h, 0A6h, 0A7h, 0A8h, 0A9h, 0AAh, 0ABh, 0ACh, 0ADh, 0AEh, 0AFh, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0C0h, 0C1h, 12, 14, 0C4h, 0C5h, 8, 8, 0C8h, 0C9h, 12, 14, 0CCh, 15, 0CEh, 14, 0D0h, 0D1h 
			 db 0D2h, 0D3h, 0D4h, 0D5h, 0D6h, 0D7h, 0D8h, 0D9h, 0DAh, 0DBh, 0DCh, 0DDh, 0DEh, 0DFh, 0E0h, 0E1h, 13, 13, 0E4h, 0E5h, 0E6h, 0E7h, 11, 11, 10, 13, 0ECh, 0EDh, 0EEh, 0EFh, 0F0h, 0F1h, 0F2h, 0F3h, 0F4h, 0F5h, 9, 9, 0F8h, 0F9h, 0FAh, 0FBh, 0FCh, 0FDh, 9, 9
    
    ;--------------
    
    formatas        db ?
    pirmas_baitas   db ?
    bojb_baitas     db ?
    bovb_baitas     db ?
    ajb_baitas      db ?
    avb_baitas      db ?
    srjb_baitas     db ?
    srvb_baitas     db ? 
    w_bitas         db ?   ;0/1
    d_bitas         db ?   ;0/1
    mod_dalis       db ?   
    reg_dalis       db ?  
    rm_dalis        db ?   
    posl_jb         db ?
    posl_vb         db ?
    sr_dalis        db ?
    s_bitas         db ?
    
    
    ;---------------SPAUSDINAMU KOMANDU VARDAI
    k_INC   db 'INC '
    k_DEC   db 'DEC '
    k_PUSH  db 'PUSH '
    k_POP   db 'POP '
    k_INT   db 'INT '
    k_MOV   db 'MOV '
    k_CALL  db 'CALL '
    k_JMP   db 'JMP '
    k_ADD   db 'ADD '
    k_SUB   db 'SUB '
    k_CMP   db 'CMP '
    k_MUL   db 'MUL '
    k_DIV   db 'DIV ' 
    k_LOOP  db 'LOOP '
    k_JA    db 'JA '
    k_JAE   db 'JAE '
    k_JNAE  db 'JNAE '
    k_JNA   db 'JNA '
    k_JZ    db 'JZ '
    k_JNZ   db 'JNZ '
    k_JG    db 'JG '
    k_JGE   db 'JGE '
    k_JNGE  db 'JNGE '
    k_JNG   db 'JNG '
    k_JS    db 'JS '
    k_JNS   db 'JNS '
    k_JO    db 'JO '
    k_JNO   db 'JNO '
    k_JP    db 'JP '
    k_JNP   db 'JNP '
    k_JCXZ  db 'JCXZ '
    k_RET   db 'RET '
    k_RETF  db 'RETF '
    k_IRET  db 'IRET '
    
    

    ;---------------SPAUSDINAMU REGISTRU VARDAI 
    
    r_AX db 'ax'
    r_CX db 'cx'
    r_DX db 'dx'
    r_BX db 'bx'
    r_SP db 'sp'
    r_BP db 'bp'
    r_SI db 'si'
    r_DI db 'di'
    r_AL db 'al'
    r_BL db 'bl'
    r_CL db 'cl'
    r_DL db 'dl'
    r_AH db 'ah'
    r_BH db 'bh'
    r_CH db 'ch'
    r_DH db 'dh'
    r_CS db 'cs'
    r_DS db 'ds'
    r_ES db 'es'
    r_SS db 'ss'
    
    
.code
Pradzia:
    mov ax, @data
    mov ds, ax
    
    
     
     ;---------------------------	PARAMETRU PERSKAITYMAS
    mov	ch, 0			
	mov	cl, es:[0080h]		;programos paleidimo parametru simboliu skaicius rašomas ES 128-ame (80h) baite
	cmp	cx, 0			;jei paleidimo parametru nera,
	je	helpas			
	mov	bx, 0081h		
  Ieskok:
	cmp	es:[bx], '?/'		;atmintyje jaunesnysis baitas saugomas pirmiau,
					;todel pirmasis baitas irašomas i bl, o antrasis i bh.
					;taip '/?' virsta '?/'.
	je helpas			
	inc	bx			
	loop Ieskok			

	jmp	YraParametru			

	;spausdinu i ekrana pagalbos pranešima
   helpas:
	mov	ah, 09h		
	mov	dx, offset help
	int	21h		
	jmp pabaiga
	
YraParametru:
	
	mov bx, 0082h ; nuo cia prasideda pirmas parametras
	mov si, offset duom
	
	
	mov dh, 1 ; 
	mov cl, es:[0080h]
	
	;-------------  tarpu ignoravimas
	
	mov dl,es:[bx]
	cmp dl, 32
	je ieskomSpace
	
	jmp skaitomDuom
	
	ieskomSpace:
	inc bx
	mov dl, es:[bx]
	inc dh
	
	cmp dh,cl
	JGE helpas
	
	cmp dl, 32
	JE ieskomSpace
	
	;-------------  tarpu ignoravimas
	
	
	skaitomDuom:
	mov dl, es:[bx]
	cmp dl, 32
	je perskaiteDuom
	mov [si], dl
	inc si
	inc bx
	
	jmp skaitomDuom
	
	
	perskaiteDuom:
	
	
	mov byte ptr[si], 0  ;kad baigtu skaityti duom.txt faila 
	mov si, offset rez
	
	inc bx
	
	mov dl, es:[bx]
	cmp dl, 32
	JE ieskomSpaceT
	
	jmp skaitomRez
	
	ieskomSpaceT:
	inc bx
	mov dl,es:[bx]
	inc dh
	cmp dh,cl
	JGE helpas
	cmp dl, 32
	je ieskomSpaceT
	
	;-----------     tarpu ignoravimas
	
	
	skaitomRez:
	mov dl, es:[bx]
	cmp dl, 13
	je perskaitePar
	
	
	mov byte ptr[si], dl
	inc si
	inc bx
	
	jmp skaitomRez
	
	perskaitePar:
	inc si
    mov byte ptr [si], 0   
    
    
    ;duomenu failo atidarymas
    mov ah, 3Dh
    mov al, 0
    mov dx, offset duom
    int 21h
    jc klaidaAtidarantSkaitymui
    mov dFail, ax
    
    ;rezultato failo sukurimas ir atidarymas
    mov ah, 3Ch
    mov al, 0
    mov cx, 0
    mov dx, offset rez
    int 21h
    JC	klaidaAtidarantRasymui		;jei kuriant faila skaitymui ivyksta klaida, nustatomas carry flag
	MOV	rFail, ax			;atmintyje išsisaugom rezultato failo deskriptoriaus numeri
	
    ;---      
    
    mov si, 0
    mov di, offset raBuf
     
    call papildykBuf
    
    
loopas:
     
    
    mov di, offset raBuf
    
    
    call nunulink_kintamuosius
    call nunulink_ra_buf
    call print_address
    mov byte ptr [komandos_ilgis], 0
    mov byte ptr [prefix], 0
    call get_byte
    call check_prefix 
    mov byte ptr [pirmas_baitas], al
    call gaukInfo    
    call print_kodo_eilute
    call print_raBuf
       
    
    
    cmp si, papilde_buf
    jbe loopas 
    
    
    
    
    ;*****************************************************
    ;Rezultato failo uždarymas
    ;*****************************************************
      uzdarytiRasymui:
    	MOV	ah, 3Eh				;21h pertraukimo failo uždarymo funkcijos numeris
    	MOV	bx, rFail			;i bx irašom rezultato failo deskriptoriaus numeri
    	INT	21h				;failo uždarymas 
    	JC	klaidaUzdarantRasymui		;jei uždarant faila ivyksta klaida, nustatomas carry flag

    ;*****************************************************
    ;Duomenu failo uždarymas
    ;*****************************************************
      uzdarytiSkaitymui:
    	MOV	ah, 3Eh				;21h pertraukimo failo uždarymo funkcijos numeris
    	MOV	bx, dFail			;i bx irašom duomenu failo deskriptoriaus numeri
    	INT	21h				;failo uždarymas
    	JC	klaidaUzdarantSkaitymui		;jei uždarant faila ivyksta klaida, nustatomas carry flag
 
    
    pabaiga:
    mov ah, 4Ch
    mov al, 0
    int 21h
	
;---klaidos
klaidaAtidarantSkaitymui:
call isveskKlaida
jmp pabaiga
  
klaidaAtidarantRasymui:
call isveskKlaida
jmp pabaiga

klaidaUzdarantRasymui:
call isveskKlaida
jmp pabaiga

klaidaUzdarantSkaitymui:
call isveskKlaida
jmp pabaiga

isveskKlaida:
push ax
push dx

mov ah, 9
mov dx, offset klaidosPranesimas
int 21h

pop dx
pop ax

RET
;---klaidos  
 
 
 
surinkti_pirma:                        ;XXXX XXdw mod reg r/m [poslinkis]
    mov al, byte ptr [pirmas_baitas]
    call get_d
    mov al, byte ptr [pirmas_baitas]
    call get_w
    call get_byte
    mov bl, al
    call get_mod
    mov al, bl
    call get_reg
    mov al, bl
    call get_rm
    
    cmp mod_dalis, 11b
    je surinkti_pirma_pab
    cmp mod_dalis, 00b
    je surinkti_pirma_mod00
    
    call get_poslinkis
    jmp surinkti_pirma_pab
    
    surinkti_pirma_mod00:
      cmp rm_dalis, 110b
      jne surinkti_pirma_pab
      
      call get_poslinkis
     
    
    surinkti_pirma_pab:    
    RET
    
surinkti_antra:                        ;XXXX XXdX mod 0sr r/m [poslinkis]
    mov byte ptr [w_bitas], 1 
    mov al, byte ptr [pirmas_baitas]
    call get_d
    call get_byte
    mov bl, al
    call get_mod
    ;-gaunamas sr:
    mov al, bl
    call get_reg
    mov al, byte ptr [reg_dalis]
    and al, 00000011b
    mov byte ptr [sr_dalis], al
    ;-- 
    mov al, bl
    call get_rm
    
    cmp mod_dalis, 11b
    je surinkti_antra_pab
    cmp mod_dalis, 00b
    je surinkti_antra_mod00
    
    call get_poslinkis
    jmp surinkti_antra_pab
    
    surinkti_antra_mod00:
      cmp rm_dalis, 110b
      jne surinkti_antra_pab
      
      call get_poslinkis
     
    
    surinkti_antra_pab:    
    RET
    
    
 
    
  
surinkti_trecia:						;XXXX XXXw ajb avb
    mov al, byte ptr [pirmas_baitas]
    call get_w
    call get_byte
    mov byte ptr [ajb_baitas], al
    call get_byte
    mov byte ptr [avb_baitas], al
    
    RET

	
surinkti_ketvirta:                     ;XXXX wreg bojb [bovb]
    mov al, byte ptr [pirmas_baitas] 
    mov bl, al
    and al, 111b
    and bl, 1000b
    mov byte ptr [reg_dalis], al
    mov byte ptr [w_bitas], bl
    
    call get_byte
    mov byte ptr [bojb_baitas], al
    
    cmp w_bitas, 0    
    je surinkti_ketvirta_pab
    
    call get_byte
    mov byte ptr [bovb_baitas], al
    
    
    surinkti_ketvirta_pab:
    RET
    
surinkti_penkta:                       ;XXXX Xreg
    mov al, byte ptr [pirmas_baitas]
    and al, 00000111b
    mov byte ptr [reg_dalis], al
    RET
    
surinkti_sesta:                        ;XXXsr XXX
    mov al, byte ptr [pirmas_baitas]
    and al, 00011000b
    shr al, 3
    mov byte ptr [sr_dalis], al
    RET
    
 
surinkti_septinta:						;XXXX XXXw bojb [bovb]
    mov al, byte ptr [pirmas_baitas]
    call get_w
    
    cmp w_bitas, 0
    je surinkti_septinta_w0
    
    surinkti_septinta_w1:
      call get_byte
      mov byte ptr [bojb_baitas], al
      call get_byte
      mov byte ptr [bovb_baitas], al
      RET
    
    surinkti_septinta_w0:
      call get_byte
      mov byte ptr [bojb_baitas], al
      RET
      

surinkti_astunta:                      ;XXXX XX(s/X)w mod XXX r/m [poslinkis] bojb [bovb]
   cmp pirmas_baitas, 0C5h
   ja surinkti_astunta_movas_stotele
   
   surinkti_astunta_nemovas:
     mov al, byte ptr [pirmas_baitas]
     mov bl, al
     call get_d
     mov byte ptr [s_bitas], al
     mov al, bl
     call get_w
     
     call get_byte
     mov bl, al
     call get_mod
     mov al, bl
     call get_reg
     mov al, bl
     call get_rm
     
     cmp mod_dalis, 00b
     je surinkti_astunta_nemov_mod00
     cmp mod_dalis, 11b
     je sur_astunta_nemov_mod00_gryzimas
     
     call get_poslinkis
     
     sur_astunta_nemov_mod00_gryzimas: 
     
     
     call get_byte
     mov byte ptr [bojb_baitas], al
     
     
     cmp s_bitas, 0
     je surinkti_astunta_s0
     
     surinkti_astunta_s1:
       cmp w_bitas, 1
       je surinkti_astunta_s1_w1
       
       RET
       
       surinkti_astunta_s1_w1:
         and al, 10000000b
         shr al, 7
         cmp al, 1
         je praplesti_bo
         mov byte ptr [bovb_baitas], 00h
         RET      
      
         praplesti_bo:
           mov byte ptr [bovb_baitas], 0FFh
           RET
           
     surinkti_astunta_movas_stotele:
     jmp surinkti_astunta_movas
     
     
     surinkti_astunta_s0:
       cmp w_bitas, 1
       je surinkti_astunta_s0_w1
       
       RET
       
       surinkti_astunta_s0_w1:
         call get_byte
         mov byte ptr [bovb_baitas], al
         RET
         
    surinkti_astunta_nemov_mod00:
       cmp rm_dalis, 110b
       jne sur_astunta_nemov_mod00_gryzimas
  
       call get_poslinkis
  
       jmp sur_astunta_nemov_mod00_gryzimas
       

         
   
   
   surinkti_astunta_movas:
     mov al, byte ptr [pirmas_baitas]
     call get_w
     call get_byte
     mov bl, al
     call get_mod
     mov byte ptr [reg_dalis], 000b
     mov al, bl
     call get_rm

     cmp mod_dalis, 00b
     je surinkti_astunta_mov_mod00
     
     call get_poslinkis    ;mod negali buti 11 tai jei ne 0 tai 10 arba 01
     
     
     sur_astunta_mov_mod00_gryzimas:
     
     
     
     call get_byte
     mov byte ptr [bojb_baitas], al
     
     cmp w_bitas, 0
     je surinkti_astunta_movas_pab
     
     call get_byte
     mov byte ptr [bovb_baitas], al
     
     surinkti_astunta_movas_pab:
     RET
     
     surinkti_astunta_mov_mod00:
       cmp rm_dalis, 110b
       jne sur_astunta_mov_mod00_gryzimas
  
       call get_poslinkis
  
       jmp sur_astunta_mov_mod00_gryzimas

     
     
     
surinkti_devinta:                      ;XXXX XXX(w/X) mod XXX r/m [poslinkis]
    mov al, byte ptr [pirmas_baitas]
    call get_w
    call get_byte
    mov bl, al
    call get_mod
    mov al, bl
    call get_reg
    mov al, bl
    call get_rm
    
    cmp mod_dalis, 11b
    je surinkti_devinta_pab
    cmp mod_dalis, 00b
    je surinkti_devinta_mod00
    
    call get_poslinkis
    jmp surinkti_devinta_pab
    
    surinkti_devinta_mod00:
      cmp rm_dalis, 110b
      jne surinkti_devinta_pab
      
      call get_poslinkis
     
    
    surinkti_devinta_pab:    
    RET
    
          
      
      
    
surinkti_desimta:                      ;XXXX XXXX ajb avb srjb srvb 
    call get_byte
    mov  byte ptr [ajb_baitas], al
    call get_byte
    mov  byte ptr [avb_baitas], al
    call get_byte
    mov  byte ptr [srjb_baitas], al
    call get_byte
    mov  byte ptr [srvb_baitas], al
    
    RET
    
surinkti_vienuolikta:                 ;XXXX XXXX pjb pvb
    mov mod_dalis, 10b
    call get_poslinkis
    RET
    
surinkti_dvylikta:                     ;XXXX XXXX bojb bovb
    call get_byte
    mov byte ptr[bojb_baitas], al
    call get_byte
    mov byte ptr[bovb_baitas], al
    RET
    
surinkti_trylikta:						;XXXX XXXX poslinkis
    mov byte ptr [mod_dalis], 01b
    call get_poslinkis
    RET       
    

surinkti_int:
    call get_byte    
    mov byte ptr [bojb_baitas], al
    RET
    
    
print_1_format:
    cmp pirmas_baitas, 04h
    jb print_1_add
    cmp pirmas_baitas, 2Ch
    jb print_1_sub
    cmp pirmas_baitas, 3Ch
    jb print_1_cmp
    
    print_1_mov:
      call print_mov
      jmp print_1_sutvarkyta 
    
    print_1_cmp:
      call print_cmp
      jmp print_1_sutvarkyta
      
    print_1_sub:
      call print_sub
      jmp print_1_sutvarkyta  
    
    
    print_1_add:
      call print_add
      jmp print_1_sutvarkyta
      
      
    print_1_sutvarkyta:
      cmp d_bitas, 0
      je rm_then_reg
      
      reg_then_rm:
        call print_reg
        
        mov bl, ','
        call print_BL
        mov bl, 32
        call print_BL
        
        call print_rm 
        
        RET
      
      
      rm_then_reg:
        call print_rm
        
        mov bl, ','
        call print_BL
        mov bl, 32
        call print_BL
        
        call print_reg
                       
        RET
        
print_2_format:
    call print_mov
    
    
    cmp sr_dalis, 00b
    je print_2_es
    cmp sr_dalis, 01b
    je print_2_cs
    cmp sr_dalis, 10b
    je print_2_ss
    cmp sr_dalis, 11b
    je print_2_ds 
    
    print_2_sutvarkyta:
    push dx
    
    cmp d_bitas, 0
    je print_2_rm_then_sr
    
    
    print_2_sr_then_rm:
      pop dx
      mov cx, 2
      call kopink
      mov bl, ','
      call print_BL
      mov bl, 32
      call print_BL
      call print_rm
      
      RET    
    
    
    print_2_rm_then_sr:
      call print_rm
      mov bl, ','
      call print_BL
      mov bl, 32
      call print_BL
      pop dx
      mov cx, 2
      call kopink
      
      RET  
        
    
    
    print_2_es:
      mov dx, offset r_ES
      jmp print_2_sutvarkyta
    print_2_cs:
      mov dx, offset r_CS
      jmp print_2_sutvarkyta
    print_2_ds:
      mov dx, offset r_DS
      jmp print_2_sutvarkyta
    print_2_ss:
      mov dx, offset r_SS
      jmp print_2_sutvarkyta  
    
      
    
    
    
    
print_3_format:
    call print_mov
    
    cmp pirmas_baitas, 0A2h
    jb atm_to_akum
    
    akum_to_atm:
      mov bl, '['
      call print_BL
      mov ah, 0
      mov al, byte ptr [avb_baitas]
      call print_hex
      mov al, byte ptr [ajb_baitas]
      call print_hex
      mov bl, ']'
      call print_BL
      mov bl, ','
      call print_BL
      mov bl, 32
      call print_BL
      mov byte ptr [reg_dalis], 000b
      call print_reg
      
      RET    
    
    
    atm_to_akum:
      mov byte ptr [reg_dalis], 000b
      call print_reg
      mov bl, ','
      call print_BL
      mov bl, 32
      call print_BL
      mov bl, '['
      call print_BL
      mov ah, 0
      mov al, byte ptr [avb_baitas]
      call print_hex
      mov al, byte ptr [ajb_baitas]
      call print_hex
      mov bl, ']'
      call print_BL
      
      RET
    
    
    
print_4_format:
    call print_mov
    
    call print_reg
    mov bl, ','
    call print_bl
    mov bl, 32
    call print_bl
    mov ah, 0

    
    cmp w_bitas, 0
    je print_4_format_end
    
    mov al, bovb_baitas
    call print_hex    
    
    print_4_format_end:
    
    mov al, bojb_baitas
    call print_hex
    
    RET
    
print_5_format:
    cmp pirmas_baitas, 48h
    jb format_5_inc
    cmp pirmas_baitas, 50h
    jb format_5_dec
    cmp pirmas_baitas, 58h
    jb format_5_push
    
    
    format_5_pop:
    call print_pop
    jmp format_5_sutvarkyta
    
    
    format_5_dec:
    call print_dec
    jmp format_5_sutvarkyta
    
    
    format_5_inc:
    call print_inc
    jmp format_5_sutvarkyta
    
    
    format_5_push:
    call print_push
    jmp format_5_sutvarkyta
    
    
    format_5_sutvarkyta:
    mov w_bitas, 1
    call print_reg 
    RET
    
print_6_format:
    cmp pirmas_baitas, 06h
    je print_6_push
    cmp pirmas_baitas, 0Eh
    je print_6_push
    cmp pirmas_baitas, 16h
    je print_6_push
    cmp pirmas_baitas, 1Eh
    je print_6_push
    
    cmp pirmas_baitas, 07h
    je print_6_pop
    cmp pirmas_baitas, 07h
    je print_6_pop
    cmp pirmas_baitas, 07h
    je print_6_pop
    cmp pirmas_baitas, 07h
    je print_6_pop
                   
    print_6_pop:
      call print_pop
      jmp print_6_sutvarkyta
    
    
    print_6_push:
      call print_push
      jmp print_6_sutvarkyta
    
    print_6_sutvarkyta:
      
      cmp sr_dalis, 00b
      je print_6_es
      cmp sr_dalis, 01b
      je print_6_cs
      cmp sr_dalis, 10b
      je print_6_ss
      cmp sr_dalis, 11b
      je print_6_ds
      
      print_6_es:
        mov dx, offset r_ES
        mov cx, 2
        call kopink
        RET
      print_6_cs:
        mov dx, offset r_CS
        mov cx, 2
        call kopink
        RET
      print_6_ss:
        mov dx, offset r_SS
        mov cx, 2
        call kopink
        RET
      print_6_ds:
        mov dx, offset r_DS
        mov cx, 2
        call kopink
        RET   
    
    
      
    
print_7_format:
    cmp pirmas_baitas, 06h
    jb print_7_add
    cmp pirmas_baitas, 2Eh
    jb print_7_sub
    
    print_7_cmp:
      call print_cmp
      jmp print_7_sutvarkyta
    
    print_7_sub:
      call print_sub
      jmp print_7_sutvarkyta
    
    print_7_add:
      call print_add
      jmp print_7_sutvarkyta
      
    print_7_sutvarkyta:
      mov byte ptr [reg_dalis], 000b
      call print_reg
      mov bl, ','
      call print_BL
      mov bl, 32
      call print_BL
      
      cmp w_bitas, 0
      je print_7_w0
      
      print_7_w1:
        mov ah, 0
        mov al, byte ptr [bovb_baitas]
        call print_hex
        mov al, byte ptr [bojb_baitas]
        call print_hex
        RET
    
      
      print_7_w0:
        mov ah, 0
        mov al, byte ptr [bojb_baitas]
        call print_hex
        RET
    

print_8_format:
    cmp pirmas_baitas, 0C5h
    ja print_8_mov
    
    cmp reg_dalis, 000b
    je print_8_add
    
    cmp reg_dalis, 101b
    je print_8_sub
    
    print_8_cmp:       ;tai reg_dalis = 111b
      call print_cmp
      jmp print_8_sutvarkyta    
    print_8_sub:
      call print_sub
      jmp print_8_sutvarkyta
    print_8_add:
      call print_add
      jmp print_8_sutvarkyta
    print_8_mov:
      call print_mov
      jmp print_8_sutvarkyta
      
    print_8_sutvarkyta:
      call print_rm
      mov bl, ','
      call print_BL
      mov bl, 32
      call print_BL
      
      cmp w_bitas, 0
      je print_8_end
    
      mov al, bovb_baitas
      call print_hex    
    
      print_8_end:
    
      mov al, bojb_baitas
      call print_hex
    
      RET
      
      
      
print_9_format:
    cmp pirmas_baitas, 0FFh
    je print_9_push_inc_dec_call
    cmp pirmas_baitas, 0FEh
    je print_9_inc_dec_1byte
    cmp pirmas_baitas, 08Fh
    je print_9_pop
    cmp pirmas_baitas, 0F8h
    jb print_9_mul_div 
    
    print_9_sutvarkyta:
      call print_rm
      RET 
    
    
    print_9_push_inc_dec_call:
    cmp reg_dalis, 110b
    je print_9_push
    cmp reg_dalis, 000b
    je print_9_inc
    cmp reg_dalis, 001b
    je print_9_dec
    cmp reg_dalis, 010b
    je print_9_call
    cmp reg_dalis, 011b
    je print_9_call
    cmp reg_dalis, 100b
    je print_9_jmp
    cmp reg_dalis, 101b
    je print_9_jmp
    
    print_9_push:
      call print_push
      jmp print_9_sutvarkyta
    print_9_inc:
      call print_inc
      jmp print_9_sutvarkyta
    print_9_dec:
      call print_dec
      jmp print_9_sutvarkyta
    print_9_call:
      call print_call
      jmp print_9_sutvarkyta
    print_9_jmp:
      call print_jmp
      jmp print_9_sutvarkyta
      
    print_9_pop:
      call print_pop
      jmp print_9_sutvarkyta
      
    print_9_inc_dec_1byte:
      cmp reg_dalis, 000b
      je print_9_inc
      cmp reg_dalis, 001b
      je print_9_dec
    
    print_9_mul_div:
      cmp reg_dalis, 100b
      je print_9_mul
      cmp reg_dalis, 110b
      je print_9_div
      
      
    print_9_mul:
      call print_mul
      jmp print_9_sutvarkyta
      
    print_9_div:
      call print_div
      jmp print_9_sutvarkyta
    
    
    
    
print_10_format:
    cmp pirmas_baitas, 9Ah
    je desimte_callas
    
    call print_jmp
    jmp desimte_opk_sutvarkyta
    
    desimte_callas:
      call print_call
    
    desimte_opk_sutvarkyta:
      mov bl, '['
      call print_BL
      
      mov ah, 0
      mov al, byte ptr [avb_baitas]
      call print_hex
      mov al, byte ptr [ajb_baitas]
      call print_hex
      mov bl, ':'  
      call print_BL
      mov al, byte ptr [srvb_baitas]
      call print_hex
      mov al, byte ptr [srjb_baitas]
      call print_hex
      
      mov bl, ']'
      call print_BL
      RET
    

print_11_format:
    cmp pirmas_baitas, 0E8h
    je print_11_call 
    
    call print_jmp
    mov ah, byte ptr [posl_vb]
    mov al, byte ptr [posl_jb]
    mov bh, 0
    mov bl, byte ptr [komandos_ilgis]
    add ax, bx
    mov bx, word ptr [adresas]
    add ax, bx
    call print_hex
      
    RET
    
    
    print_11_call:
      call print_call
      mov ah, byte ptr [posl_vb]
      mov al, byte ptr [posl_jb]
      mov bh, 0
      mov bl, byte ptr [komandos_ilgis]
      add ax, bx
      mov bx, word ptr [adresas]
      add ax, bx
      call print_hex
      
      RET
      
print_12_format:
    cmp pirmas_baitas, 0C2h
    je print_12_ret
    
    call print_retf
    
    print_12_sutvarkyta:
    mov ah, 0
    mov al, byte ptr [bovb_baitas]
    call print_hex
    mov al, byte ptr [bojb_baitas]
    call print_hex
    
    RET
    
    
    print_12_ret:
      call print_ret
      jmp print_12_sutvarkyta
    

print_13_format:
    cmp pirmas_baitas, 0EBh
    je print_13_jmp
    cmp pirmas_baitas, 0E2h
    je print_13_loop
    
    cmp pirmas_baitas, 077h
     je print_13_ja
    
    cmp pirmas_baitas, 073h
     je print_13_jae
    
    cmp pirmas_baitas, 072h
     je print_13_jnae
    
    cmp pirmas_baitas, 076h
     je print_13_jna
    
    cmp pirmas_baitas, 074h
     je print_13_jz
    
    cmp pirmas_baitas, 075h
     je print_13_jnz
    
    cmp pirmas_baitas, 07Fh
     je print_13_jg
    
    jmp print_13_part2
    
    
    print_13_jmp:
      mov dx, offset k_JMP
      mov cx, 4
      jmp print_13_sutvarkyta
      
    print_13_loop:
      mov dx, offset k_LOOP
      mov cx, 5
      jmp print_13_sutvarkyta
      
    
    print_13_ja:
      mov dx, offset k_JA
      mov cx, 3
      jmp print_13_sutvarkyta
    
    print_13_jae:
      mov dx, offset k_JAE
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jnae:
      mov dx, offset k_JNAE
      mov cx, 5
      jmp print_13_sutvarkyta
    
    print_13_jna:
      mov dx, offset k_JNA
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jz:
      mov dx, offset k_JZ
      mov cx, 3
      jmp print_13_sutvarkyta
    
    print_13_jnz:
      mov dx, offset k_JNZ
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jg:
      mov dx, offset k_JG
      mov cx, 3
      jmp print_13_sutvarkyta
    
    ;----  
    print_13_part2:
    cmp pirmas_baitas, 07Dh
     je print_13_jge
    
    cmp pirmas_baitas, 07Ch
     je print_13_jnge
    
    cmp pirmas_baitas, 07Eh
     je print_13_jng
    
    cmp pirmas_baitas, 078h
     je print_13_js
    
    cmp pirmas_baitas, 079h
     je print_13_jns
    
    cmp pirmas_baitas, 070h
     je print_13_jo
    
    cmp pirmas_baitas, 071h
     je print_13_jno
    
    cmp pirmas_baitas, 07Ah
     je print_13_jp
    
    cmp pirmas_baitas, 07Bh
     je print_13_jnp
    
    cmp pirmas_baitas, 0E3h
     je print_13_jcxz  
    
    ;----
    print_13_jge:
      mov dx, offset k_JGE
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jnge:
      mov dx, offset k_JNGE
      mov cx, 5
      jmp print_13_sutvarkyta
    
    print_13_jng:
      mov dx, offset k_JNG
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_js:
      mov dx, offset k_JS
      mov cx, 3
      jmp print_13_sutvarkyta
    
    print_13_jns:
      mov dx, offset k_JNS
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jo:
      mov dx, offset k_JO
      mov cx, 3
      jmp print_13_sutvarkyta
    
    print_13_jno:
      mov dx, offset k_JNO
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jp:
      mov dx, offset k_JP
      mov cx, 3
      jmp print_13_sutvarkyta
    
    print_13_jnp:
      mov dx, offset k_JNP
      mov cx, 4
      jmp print_13_sutvarkyta
    
    print_13_jcxz:
      mov dx, offset k_JCXZ
      mov cx, 5
      jmp print_13_sutvarkyta
    
    
    
    print_13_sutvarkyta:
      call kopink
      
      mov ax, word ptr [adresas]
      mov bh, 0
      mov bl, byte ptr [komandos_ilgis]
      add ax, bx
 
      mov bh, byte ptr [posl_vb]
      mov bl, byte ptr [posl_jb]
      add ax, bx
      
      
      call print_hex
      
      RET
      
      
print_14_format:
    cmp pirmas_baitas, 0C3h
    je print_ret
    cmp pirmas_baitas, 0CBh
    je print_retf
    cmp pirmas_baitas, 0CFh
    je print_iret    
    
    
    
    print_ret:
      mov dx, offset k_RET
      mov cx, 4
      call kopink
      RET
      
    print_retf:
      mov dx, offset k_RETF
      mov cx, 5
      call kopink
      RET
      
    print_iret:
      mov dx, offset k_IRET
      mov cx, 5
      call kopink
      RET
      
print_int:
    mov dx, offset k_INT
    mov cx, 4
    call kopink
    mov ah, 0
    mov al, byte ptr [bojb_baitas]
    call print_hex
    RET 


    
    
    
gaukInfo:
	push bx
	push si
	
	mov ah, 0
	mov si, ax
	mov bx, 0                                     ;gaunamas formatas
	mov bl, byte ptr [formatai+si]
	mov formatas, bl
	
	pop si
	pop bx
	
	
	            
	cmp formatas, 1
	je kviesk_surinkti_pirma
	cmp formatas, 2
	je kviesk_surinkti_antra
	cmp formatas, 3
	je kviesk_surinkti_trecia
	cmp formatas, 4
	je kviesk_surinkti_ketvirta 
	cmp formatas, 5
	je kviesk_surinkti_penkta
	cmp formatas, 6
	je kviesk_surinkti_sesta
	cmp formatas, 7
	je kviesk_surinkti_septinta
	cmp formatas, 8
	je kviesk_surinkti_astunta
	cmp formatas, 9
	je kviesk_surinkti_devinta
	cmp formatas, 10
	je kviesk_surinkti_desimta
	cmp formatas, 11
	je kviesk_surinkti_vienuolikta
	cmp formatas, 12
	je kviesk_surinkti_dvylikta
	cmp formatas, 13
	je kviesk_surinkti_trylikta
	cmp formatas, 15
	je kviesk_surinkti_int
	               
	               
	mov formatas, 0
	
	
	RET
	
	
	kviesk_surinkti_pirma:
	  call surinkti_pirma
	  RET
	  
	kviesk_surinkti_antra:
	  call surinkti_antra
	  RET
	
	kviesk_surinkti_trecia:
	  call surinkti_trecia
	  RET
	
	
	kviesk_surinkti_ketvirta:
	  call surinkti_ketvirta
	  RET 
	
	kviesk_surinkti_penkta:
	  call surinkti_penkta
	  RET
	
	kviesk_surinkti_sesta:
	  call surinkti_sesta
	  RET
	  
	kviesk_surinkti_septinta:
	  call surinkti_septinta
	  RET
	  
	kviesk_surinkti_astunta:
	  call surinkti_astunta
	  RET
	  
	kviesk_surinkti_devinta:
	  call surinkti_devinta
	  RET
	  
	kviesk_surinkti_desimta:
	  call surinkti_desimta
	  RET
	  
	kviesk_surinkti_vienuolikta:
	  call surinkti_vienuolikta
	  RET
	  
	kviesk_surinkti_dvylikta:
	  call surinkti_dvylikta
	  RET
	  
	kviesk_surinkti_trylikta:
	  call surinkti_trylikta
	  RET 
	  
	kviesk_surinkti_int:
	  call surinkti_int
	  RET
	  
get_d: ;gauna d is al
    and al, 00000010b
    shr al, 1
    mov byte ptr [d_bitas], al
    RET
    
get_w: ;gauna w is al
    and al, 00000001b
    mov byte ptr [w_bitas], al
    RET
                                
get_mod: ;gauna mod is al
    and al, 11000000b
    shr al, 6    
    mov byte ptr [mod_dalis], al
    RET
    
get_reg: ;gauna reg is al
    and al, 00111000b
    shr al, 3    
    mov byte ptr [reg_dalis], al
    RET    

get_rm: ;gauna rm is al
    and al, 00000111b    
    mov byte ptr [rm_dalis], al
    RET
        
    
get_poslinkis:
    cmp mod_dalis, 01b
    je getposl_1b
    
    getposl_2b:
      call get_byte
      mov byte ptr [posl_jb], al
      call get_byte
      mov byte ptr [posl_vb], al
      RET
    
    
    getposl_1b:
      call get_byte
      mov byte ptr [posl_jb], al
      and al, 10000000b
      shr al, 7
      cmp al, 1
      je praplesti_posl
      mov byte ptr [posl_vb], 00h
      RET
      
      
      praplesti_posl:
        mov byte ptr [posl_vb], 0FFh
        RET    
    
    
get_byte:                         ;paima baita is buferio i AL
    inc byte ptr [komandos_ilgis]  
    mov al, 0
    cmp si, skBufDydis
    jge papildykBufjumpas
    
    papildytasBuf:
      mov al, byte ptr [skBuf+si]
      inc si
      
      mov ah, 0
      call print_hex
      
    RET   
    
    papildykBufjumpas:
      call papildykBuf
      jmp papildytasBuf 
      
      
      
      
      
print_kodo_eilute:
    call print_tabs
    
    cmp formatas, 1
    je print_1_format_kviesk
	cmp formatas, 2
	je print_2_format_kviesk
	cmp formatas, 3         
	je print_3_format_kviesk
	cmp formatas, 4
	je print_4_format_kviesk
	cmp formatas, 5         
	je print_5_format_kviesk
	cmp formatas, 6         
	je print_6_format_kviesk
	cmp formatas, 7         
	je print_7_format_kviesk
	cmp formatas, 8         
	je print_8_format_kviesk
	cmp formatas, 9         
	je print_9_format_kviesk
	cmp formatas, 10
	je print_10_format_kviesk
	cmp formatas, 11        
	je print_11_format_kviesk
	cmp formatas, 12        
	je print_12_format_kviesk
	cmp formatas, 13
	je print_13_format_kviesk
	cmp formatas, 14
	je print_14_format_kviesk
	cmp formatas, 15
	je print_int_kviesk
	
	jmp kviesk_kom_neatpazinta
	
	print_kodo_eilute_pab:
	
	RET
	
	print_1_format_kviesk:
	  call print_1_format
	  jmp print_kodo_eilute_pab
	  
	print_2_format_kviesk:
	  call print_2_format
	  jmp print_kodo_eilute_pab
	
	print_3_format_kviesk:
	  call print_3_format
	  jmp print_kodo_eilute_pab
	  
	print_4_format_kviesk:
	  call print_4_format
	  jmp print_kodo_eilute_pab
	  
	print_5_format_kviesk:
	  call print_5_format
	  jmp print_kodo_eilute_pab
	  
	print_6_format_kviesk:
	  call print_6_format
	  jmp print_kodo_eilute_pab
	  
	print_7_format_kviesk:
	  call print_7_format
	  jmp print_kodo_eilute_pab
	  
	print_8_format_kviesk:
	  call print_8_format
	  jmp print_kodo_eilute_pab
	  
	print_9_format_kviesk:
	  call print_9_format
	  jmp print_kodo_eilute_pab
	  
	print_10_format_kviesk:
	  call print_10_format
	  jmp print_kodo_eilute_pab
	  
	print_11_format_kviesk:
	  call print_11_format
	  jmp print_kodo_eilute_pab
	
	print_12_format_kviesk:
	  call print_12_format
	  jmp print_kodo_eilute_pab
	  
	print_13_format_kviesk:
	  call print_13_format
	  jmp print_kodo_eilute_pab
	  
	print_14_format_kviesk:
	  call print_14_format
	  jmp print_kodo_eilute_pab
	  
	print_int_kviesk:      
	  call print_int
	  jmp print_kodo_eilute_pab
	  
	kviesk_kom_neatpazinta:	  
	  call print_kom_neatpazinta
	  jmp print_kodo_eilute_pab
	
	      
      
print_kom_neatpazinta:
    mov dx, offset neaptazinta_kom_pranesimas
    mov cx, 11
    call kopink
    RET 
    
    
    
    
print_BL:
    mov byte ptr [di], bl
    inc di
    RET 
    
print_tabs:
    cmp komandos_ilgis, 3
    ja print_tabs_setcx
    mov bl, 9
    mov cx, 3
    print_tabs_loop:
      call print_BL    
    loop print_tabs_loop
    RET
    
    print_tabs_setcx:
    mov bl, 9
    mov cx, 2
    jmp print_tabs_loop
    
 
;PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX    

print_hex:         ;iraso i rasymo buferi hex skaiciu esanti AX arba AL ir prideda kur reikia 0
    PUSH	ax
    push    bx
	PUSH	cx
	PUSH	dx
	
	;---
	cmp ah, 0
	jne kviesk_ah_ne_nulis
	
	cmp al, 16
	jb kviesk_sutvarkyti_0_al
	
	
	nuliai_sutvarkyti:
	
	MOV	cx, 16		;kadangi naudojam dešimtaine sistema, tai dalinsim iš 10
	 
	mov bx, "$$"
	PUSH	bx		;kad spausdindami skaitmenis iš steko, galetume rasti pabaiga
    Dalink:
	MOV	dx, 0		;tiesiog išvalom registra, nes jis dalyvaus dalyboje
	DIV	cx		;{DX,AX}:10 = AX(liek DX)
	PUSH	dx		;idedam skaitmeni i steka; deja, negalime ideti 1 baito
	CMP	ax, 0		;ar dar neperskaiteme viso skaiciaus?
	JA	Dalink		;jei ne, skaitom toliau 
	
	pr_hex_loop:
	pop dx
	cmp dx, "$$"
	je print_hex_end
	cmp dx, 0Ah
	jge keisti_hex
	 
	add dl, '0'	
	jmp pr_hex_loop_end
	
	keisti_hex:
	add dl, 37h
	
	pr_hex_loop_end:
	
	mov byte ptr [di], dl
	inc di
	
	loop pr_hex_loop

    print_hex_end:
	POP	dx
	POP	cx
	pop bx
	POP	ax
	RET	
	
	;---
	kviesk_ah_ne_nulis:
	call jei_reikia_darasyti_nuli_ah
	jmp nuliai_sutvarkyti
	
	kviesk_sutvarkyti_0_al:
	call sutvarkyti_0_al
	jmp nuliai_sutvarkyti
	
sutvarkyti_0_al:
    mov bl, '0'
    call print_BL
    RET
	
	
jei_reikia_darasyti_nuli_ah:
    cmp ah, 16d
    jb darasyti_nuli_ah
    RET    
    
    darasyti_nuli_ah:
    mov bl, '0'
    call print_BL
    RET 
    
nunulink_kintamuosius:
    mov byte ptr [posl_vb], 0
    mov byte ptr [posl_jb], 0
    mov byte ptr [bovb_baitas], 0
    mov byte ptr [bojb_baitas], 0
    RET
    
;PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX_PRINTHEX
	
	
print_address:
    mov ax, word ptr adresas
    mov bl, byte ptr komandos_ilgis
    mov bh, 0
    add ax, bx
    mov word ptr adresas, ax    
    call print_hex
    mov bl, 3Ah ;dvitaskis
    call print_BL
    mov bl, 9
    call print_BL
   
    
    RET
	
	
	
print_raBuf:       
    mov cx, 61d
    mov bx, rFail
    call RasykBuf
    RET
    
    
    
	

kopink:;kopina i rasymo buferi cx baitu is dx offset
    push si 
    
    kop_loopas:
    mov si, dx
       
    mov al, byte ptr [si]
    
    mov byte ptr [di], al
    inc dx
    inc di
    loop kop_loopas
    
    pop si
    
    RET
    
check_prefix:
    cmp al, 26h
    je prefix_es
    cmp al, 2Eh
    je prefix_cs
    cmp al, 36h
    je prefix_ss
    cmp al, 3Eh
    je prefix_ds
    
    
    RET
    
    
    
    prefix_es:
      mov byte ptr [prefix], 4
      call get_byte
      RET
    prefix_ds:
      mov byte ptr [prefix], 2
      call get_byte
      RET
    prefix_cs:
      mov byte ptr [prefix], 1    
      call get_byte
      RET
    prefix_ss:
      mov byte ptr [prefix], 3      
      call get_byte
      RET    
	 
;----------------------------------------------------    
    
 	  
 	  
	;*****************************************************
;Procedura nuskaitanti informacija iš failo
;*****************************************************
PROC SkaitykBuf
;i BX paduodamas failo deskriptoriaus numeris   
    push dx 
    
    mov si, 0
    
	
	MOV	ah, 3Fh			;21h pertraukimo duomenu nuskaitymo funkcijos numeris
	MOV	cx, 50h		;cx - kiek baitu reikia nuskaityti iš failo
	MOV	dx, offset skBuf	;vieta, i kuria irašoma nuskaityta informacija
	INT	21h 		;skaitymas iš failo
	JC	klaidaSkaitant		;jei skaitant iš failo ivyksta klaida, nustatomas carry flag

  SkaitykBufPabaiga:
    pop dx
	RET

  klaidaSkaitant:
	call isveskKlaida
	MOV ax, 0			;Pažymime registre ax, kad nebuvo nuskaityta ne vieno simbolio
	JMP	SkaitykBufPabaiga
SkaitykBuf ENDP

papildykBuf:
    mov bx, dFail
    mov si, 0 
    CALL SkaitykBuf
    mov word ptr [papilde_buf], ax  
RET


;*****************************************************
;Procedura, irašanti buferi i faila
;*****************************************************
RasykBuf:
;i BX paduodamas failo deskriptoriaus numeris
;i CX - kiek baitu irašyti
;i AX bus gražinta, kiek baitu buvo irašyta
	PUSH	dx
	
	MOV	ah, 40h			;21h pertraukimo duomenu irašymo funkcijos numeris
	MOV	dx, offset raBuf	;vieta, iš kurios rašom i faila
	INT	21h			;rašymas i faila
	JC	klaidaRasant		;jei rašant i faila ivyksta klaida, nustatomas carry flag
	CMP	cx, ax			;jei cx nelygus ax, vadinasi buvo irašyta tik dalis informacijos
	JNE	dalinisIrasymas

  RasykBufPabaiga:
	POP	dx
	RET

  dalinisIrasymas:
	call isveskKlaida
	JMP	RasykBufPabaiga
  klaidaRasant:
	call isveskKlaida
	MOV	ax, 0			;Pažymime registre ax, kad nebuvo irašytas ne vienas simbolis
	JMP	RasykBufPabaiga	

    
nunulink_ra_buf:
    push si       
    
    mov si, offset raBuf
    mov cx, 60d
    nunulink_loop:
    mov byte ptr [si], 32d
    inc si
    loop nunulink_loop 
    
    pop si
    RET
    
print_reg:
    mov cx, 2
    
    cmp w_bitas, 0
    je print_w_0
    
    ;--
    
    print_w_1:
    cmp reg_dalis, 000b 
    je w1_reg_000
    
    cmp reg_dalis, 001b
    je w1_reg_001
    
    cmp reg_dalis, 010b
    je w1_reg_010
    
    cmp reg_dalis, 011b
    je w1_reg_011
    
    cmp reg_dalis, 100b
    je w1_reg_100
    
    cmp reg_dalis, 101b
    je w1_reg_101
    
    cmp reg_dalis, 110b
    je w1_reg_110
    
    cmp reg_dalis, 111b
    je w1_reg_111
    
    
    call isveskKlaida    
    
    ;--    
    
    w1_reg_000:
    mov dx, offset r_AX
    call kopink
    RET
    
    w1_reg_001:
    mov dx, offset r_CX
    call kopink
    RET
    
    w1_reg_010:
    mov dx, offset r_DX
    call kopink
    RET
    
    w1_reg_011:
    mov dx, offset r_BX
    call kopink
    RET
    
    w1_reg_100:
    mov dx, offset r_SP
    call kopink
    RET
    
    w1_reg_101:
    mov dx, offset r_BP
    call kopink
    RET
    
    w1_reg_110:
    mov dx, offset r_SI
    call kopink
    RET
    
    w1_reg_111:
    mov dx, offset r_DI
    call kopink
    RET
    
    
    ;--
    
    print_w_0:
    cmp reg_dalis, 000b 
    je w0_reg_000
    
    cmp reg_dalis, 001b
    je w0_reg_001
    
    cmp reg_dalis, 010b
    je w0_reg_010
    
    cmp reg_dalis, 011b
    je w0_reg_011
    
    cmp reg_dalis, 100b
    je w0_reg_100
    
    cmp reg_dalis, 101b
    je w0_reg_101
    
    cmp reg_dalis, 110b
    je w0_reg_110
    
    cmp reg_dalis, 111b
    je w0_reg_111
                 
    
    call isveskKlaida
    
    
    ;--
    
    w0_reg_000:
    mov dx, offset r_AL
    call kopink
    RET
    
    w0_reg_001:
    mov dx, offset r_CL
    call kopink
    RET
    
    w0_reg_010:
    mov dx, offset r_DL
    call kopink
    RET
    
    w0_reg_011:
    mov dx, offset r_BL
    call kopink
    RET
    
    w0_reg_100:
    mov dx, offset r_AH
    call kopink
    RET
    
    w0_reg_101:
    mov dx, offset r_CH
    call kopink
    RET
    
    w0_reg_110:
    mov dx, offset r_DH
    call kopink
    RET
    
    w0_reg_111:
    mov dx, offset r_BH
    call kopink
    RET
    
    
;-- 

print_byte_ptr:
  mov dx, offset pr_byte_ptr
  mov cx, 9
  call kopink
  jmp print_rm_sutvarkyta
  
print_word_ptr:
  mov dx, offset pr_word_ptr
  mov cx, 9
  call kopink
  jmp print_rm_sutvarkyta

print_prefix:
  cmp prefix, 1
  je print_prefix_cs
  cmp prefix, 2
  je print_prefix_ds
  cmp prefix, 3
  je print_prefix_ss
  cmp prefix, 4
  je print_prefix_es
  
  
  print_prefix_cs:
    mov dx, offset pref_cs
    mov cx, 3
    call kopink
    jmp print_rm_prefix_set
    
  print_prefix_ds:
    mov dx, offset pref_ds
    mov cx, 3
    call kopink
    jmp print_rm_prefix_set
    
  print_prefix_ss:
    mov dx, offset pref_ss
    mov cx, 3
    call kopink
    jmp print_rm_prefix_set
    
  print_prefix_es:
    mov dx, offset pref_es
    mov cx, 3
    call kopink
    jmp print_rm_prefix_set
    
  
  

print_rm:
    cmp mod_dalis, 11b
    je print_rm_mod11_stotele
    cmp mod_dalis, 00b
    je print_rm_mod_ne11
    
    
    print_rm_mod_ne11:
    
    
        cmp w_bitas, 0
        je print_byte_ptr
        jmp print_word_ptr
        
        print_rm_sutvarkyta:
        
        
        cmp prefix, 0
        jne print_prefix
        
        print_rm_prefix_set:
        
        mov bl, '['
        call print_BL 
        
        mov al, byte ptr [reg_dalis]
        mov ah, 0
        push ax
        
        mov al, byte ptr [w_bitas]
        push ax
        
        mov byte ptr [w_bitas], 1 ;rme dirbama su zodiniais reg kai mod ne 11
    
    
        cmp rm_dalis, 000b 
        je modne11_rm_000
        
        cmp rm_dalis, 001b
        je modne11_rm_001
        
        cmp rm_dalis, 010b
        je modne11_rm_010
        
        cmp rm_dalis, 011b
        je modne11_rm_011
        
        cmp rm_dalis, 100b
        je modne11_rm_100_stotele
        
        cmp rm_dalis, 101b
        je modne11_rm_101_stotele
        
        cmp rm_dalis, 110b
        je modne11_rm_110_stotele
        
        cmp rm_dalis, 111b
        je modne11_rm_111_stotele
        
        
        call isveskKlaida    
        
        ;--

		print_rm_mod11_stotele:
		  jmp print_rm_mod11
        
        modne11_rm_000:
          mov byte ptr [reg_dalis], 011b
          call print_reg
          mov bl, '+'
          call print_BL
          mov byte ptr [reg_dalis], 110b
          call print_reg  
        jmp print_rm_modne11_pab
        
        modne11_rm_001:
          mov byte ptr [reg_dalis], 011b
          call print_reg
          mov bl, '+'
          call print_BL
          mov byte ptr [reg_dalis], 111b
          call print_reg
        jmp print_rm_modne11_pab
		
		modne11_rm_110_stotele:
		  jmp modne11_rm_110
		
		modne11_rm_111_stotele:
		  jmp modne11_rm_111
		  
		modne11_rm_100_stotele:
		  jmp modne11_rm_100
		
		modne11_rm_101_stotele:
		  jmp modne11_rm_101
        
        modne11_rm_010:
          mov byte ptr [reg_dalis], 101b
          call print_reg
          mov bl, '+'
          call print_BL
          mov byte ptr [reg_dalis], 110b
          call print_reg
        jmp print_rm_modne11_pab
		
        
        modne11_rm_011:
          mov byte ptr [reg_dalis], 101b
          call print_reg
          mov bl, '+'
          call print_BL
          mov byte ptr [reg_dalis], 111b
          call print_reg
        jmp print_rm_modne11_pab
        
        modne11_rm_100:
          mov byte ptr [reg_dalis], 110b
          call print_reg
        jmp print_rm_modne11_pab
        
        modne11_rm_101:
          mov byte ptr [reg_dalis], 111b
          call print_reg
        jmp print_rm_modne11_pab
        
        modne11_rm_110:                    ;isskirtinis atvejis
          cmp mod_dalis, 00b
          je rm_110_mod00
          
          mov byte ptr [reg_dalis], 101b
          call print_reg
          jmp print_rm_modne11_pab
          
          rm_110_mod00:
          mov al, byte ptr [posl_vb]
          call print_hex
          mov al, byte ptr [posl_jb]
          call print_hex
        jmp print_rm_modne11_pab 
        
        modne11_rm_111:
          mov byte ptr [reg_dalis], 011b
          call print_reg
        jmp print_rm_modne11_pab
        
        
        print_rm_modne11_pab:
        
        cmp mod_dalis, 00b
        jne darasyti_posl
        
        rm_modne11_pab_gryzimas:
        
        
        mov bl, ']'
        call print_BL
        
        pop ax
        mov byte ptr [w_bitas], al
        
        pop ax
        mov byte ptr [reg_dalis], al
        
        RET
        
        darasyti_posl:
          mov bl, '+'
          call print_BL
          mov al, byte ptr [posl_vb]
          call print_hex
          mov al, byte ptr [posl_jb]
          call print_hex
          jmp rm_modne11_pab_gryzimas
           
      
    
    
    print_rm_mod11:
      mov bl, byte ptr [reg_dalis]
      mov al, byte ptr [rm_dalis]
      mov byte ptr [reg_dalis], al
      call print_reg
      mov byte ptr [reg_dalis], bl
    
      RET
      
          
    
    print_inc:
      mov dx, offset k_INC
      mov cx, 4
      call kopink
      RET
    
    print_dec:
      mov dx, offset k_DEC
      mov cx, 4
      call kopink
      RET
    
    print_push:
      mov dx, offset k_PUSH
      mov cx, 5
      call kopink
      RET
    print_pop:
      mov dx, offset k_POP
      mov cx, 4
      call kopink
      RET
      
    print_mov:
      mov dx, offset k_MOV
      mov cx, 4
      call kopink
      RET
      
    print_call:
      mov dx, offset k_CALL
      mov cx, 5
      call kopink
      RET
      
    print_jmp:
      mov dx, offset k_JMP
      mov cx, 4
      call kopink
      RET
      
    print_add:
      mov dx, offset k_ADD
      mov cx, 4
      call kopink
      RET
      
    print_sub:
      mov dx, offset k_SUB
      mov cx, 4
      call kopink
      RET
      
    print_cmp:
      mov dx, offset k_CMP
      mov cx, 4
      call kopink
      RET
                 
    print_mul:
      mov dx, offset k_MUL
      mov cx, 4
      call kopink
      RET
          
    print_div:
      mov dx, offset k_DIV
      mov cx, 4
      call kopink
      RET
      
    
    
    
    
END Pradzia
 	  
 

