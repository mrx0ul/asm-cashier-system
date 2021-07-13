.model small

.stack 100h

.data
;=================================================
msg_welcome db "Welcome to TP050639 Cafeteria",13,10,'$'

msg_menu    db "Please select a choice:",13,10
            db "1. Add Order",13,10
            db "2. Clear Screen",13,10
            db "3. Print Total Price",13,10
            db "4. Check Stock",13,10
            db "5. Clear Total Price",13,10
            db "0. Exit",13,10
            db "Your Choice: $"         
     
msg_wrong   db 10,"Please enter correct choice",13,10,10,'$'

msg_add     db 10,"Item Added Successfully, Going Back to Main Menu",13,10,'$'

msg_ct      db 10,"Cleared Total. Reset back to 0.",13,10,10,'$'

menu        db 10,10,"Food Menu",13,10
            db "1. Fish & Chips (RM 10)",13,10
            db "2. Maggi Goreng (RM 3)",13,10
            db "3. Nasi Goreng (RM 5)",13,10
            db "4. Nasi Lemak (RM 3)",13,10,10
            db "Beverages Menu",13,10
            db "5. Mineral Water (RM 1)",13,10
            db "6. Iced Tea (RM 2)",13,10
            db "7. Nescafe (RM 2)",13,10
            db "8. Milo Dinosaur (RM 4)",13,10
            db "0. Back to Main menu",13,10
            db "Add Item No: ",'$' 

msg_stkfood1    db  "Fish & Chips   : $"
msg_stkfood2    db  "Maggi Goreng   : $"
msg_stkfood3    db  "Nasi Goreng    : $"
msg_stkfood4    db  "Nasi Lemak     : $"
msg_stkdrink1   db  "Mineral Water  : $"
msg_stkdrink2   db  "Iced Tea       : $"
msg_stkdrink3   db  "Nescafe        : $"
msg_stkdrink4   db  "Milo Dinosaur  : $"
            
stk_food1   dw 32h   ;32h = 50d 
stk_food2   dw 32h   ;32h = 50d
stk_food3   dw 32h   ;32h = 50d
stk_food4   dw 32h   ;32h = 50d
stk_drink1  dw 32h   ;32h = 50d
stk_drink2  dw 32h   ;32h = 50d
stk_drink3  dw 32h   ;32h = 50d
stk_drink4  dw 32h   ;32h = 50d

msg_prc     db "Your total price is: RM $"
total_prc   dw 0

.code
;=======================================================MAIN FUNCTION===========================================================
main proc

;INITIALIZE DATA SEGMENT.
    mov  ax, @data
    mov  ds, ax

    call clear_screen
    lea  dx,msg_welcome
    mov  ah,9h
    int  21h
    call main_menu    

;WAIT FOR ANY KEY.    
    mov  ah, 7
    int  21h

;FINISH PROGRAM.
    mov  ax, 4c00h
    int  21h

main endp
;==================================================================================================================

;=======================================================MAIN MENU FUNCTION===========================================================
main_menu proc
    lea  dx,msg_menu
    mov  ah,9h
    int  21h
  
    mov ah,1h               ; read key from user ex. ascii 1
    int 21h
    xor ah,ah               ; empty ah
  
    sub al,30h              ; subtract 30h to get exact value from ascii ex. 1 in ascii is 31h, 31h-30h=1h
    shl al,1                ; multiply number by 2 to get to the case 0000 0010
    cmp al,0Ah              ; compare for validity
    jg  check               ; jump if al,greater than 8  
    mov bx,ax               ; move value of ax to bx for offset
    jmp cs:jmptable [bx]    ; jumptable
    
    jmptable dw option0,option1,option2,option3,option4,option5    ;cases
    
    
check:
    lea dx,msg_wrong        ; display wrong choice
    mov ah,9h           
    int 21h
    mov dl,10               ; move to new line
    mov ah,2h
    int 21h
    jmp main_menu           ; loop again to get correct choice 

option0:
    mov ah,4Ch
    int 21h
    
option1:                    ; Option 1 - Show Menu
    call add_food
    
option2:                    ; Option 2 - Show Item Cart
    call clear_screen
    
    mov dl,10               ; move to new line
    mov ah,2h
    int 21h
    
    jmp main_menu
    
option3:                    ; Option 3 - Print Total 
    call print_price
    
option4:
    call print_stock
    
option5:
    call clear_total

    ret
    
main_menu endp
;=======================================================CLEAR SCREEN FUNCTION================================================================
clear_screen proc
    mov  ah,0
    mov  al,3
    int  10h
    ret
clear_screen endp
;============================================================================================================================================
;=======================================================ADD ITEM TO ORDER FUNCTION===========================================================
add_food proc
    lea dx,menu
    mov ah,9h
    int 21h
    
    mov ah,1     ; read key from user
    int 21h
    mov ah,0     ; empty ah
    
    sub al,30h   ; subtract 30h to get exact value from ascii
    shl al,1               ; multiply number by 2 to get to the case
    cmp al,10h              ; compare for validity
    jg  check_showmenu     ; jump if al,greater than 16    
    mov bx,ax              ; move value of ax to bx for offset
    jmp cs:jmpfood [bx]    ; jumptable
    
    jmpfood dw back,food1,food2,food3,food4,drink1,drink2,drink3,drink4    ;cases

check_showmenu:
    lea dx,msg_wrong        ; display wrong choice
    mov ah,9h           
    int 21h
    mov dl,10               ; move to new line
    mov ah,2h
    int 21h
    jmp add_food           ; loop again to get correct choice 
    
back:
    jmp  endfood
    
food1:
    add total_prc,0Ah
    sub stk_food1,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood

food2:
    add total_prc,3
    sub stk_food2,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood    

food3:
    add total_prc,5
    sub stk_food3,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood    

food4:
    add total_prc,3
    sub stk_food4,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood

drink1:
    add total_prc,1
    sub stk_drink1,1    
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood
    
drink2:
    add total_prc,2
    sub stk_drink2,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood    

drink3:
    add  total_prc,2
    sub stk_drink3,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
    
    jmp  endfood
   
drink4:
    add total_prc,4
    sub stk_drink4,1
    
    lea  dx,msg_add
    mov  ah,9h
    int  21h
 
    jmp  endfood  

endfood:    
    mov  dl,10               ; move to new line
    mov  ah,2h
    int  21h
    
    call main_menu
    
add_food endp
;============================================================================================================================================
;=======================================================PRINT TOTAL PRICE FUNCTION===========================================================
print_price proc
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
  
    lea  dx,msg_prc             ; Your Total Price is ...
    mov  ah,9h
    int  21h
    
    cmp  total_prc,9h
    jle  one_digit
    jg   two_digits

one_digit:
    mov  bx,total_prc
    add  bl,30h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    jmp  end_print
    
two_digits:
    mov  cx,1   
    mov  ax,total_prc           ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    jmp  end_print

end_print:    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
    call  main_menu
    
print_price endp
;============================================================================================================================================
;====================================================================PRINT STOCK FUNCTION====================================================
print_stock proc
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkfood1:    
    lea  dx,msg_stkfood1
    mov  ah,9
    int  21h
    
    mov  bx,stk_food1
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkfood2:
    lea  dx,msg_stkfood2
    mov  ah,9
    int  21h
    
    mov  bx,stk_food2
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkfood3:
    lea  dx,msg_stkfood3
    mov  ah,9
    int  21h
    
    mov  bx,stk_food3
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkfood4:
    lea  dx,msg_stkfood4
    mov  ah,9
    int  21h
    
    mov  bx,stk_food4
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkdrink1:
    lea  dx,msg_stkdrink1
    mov  ah,9
    int  21h
    
    mov  bx,stk_drink1
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkdrink2:
    lea  dx,msg_stkdrink2
    mov  ah,9
    int  21h
    
    mov  bx,stk_drink2
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkdrink3:
    lea  dx,msg_stkdrink3
    mov  ah,9
    int  21h
    
    mov  bx,stk_drink3
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
stkdrink4:
    lea  dx,msg_stkdrink4
    mov  ah,9
    int  21h
    
    mov  bx,stk_drink4
    mov  cx,1   
    mov  ax,bx                  ; mov the final price to ax
    mul  cx
    aam                         ; adjust after multiply
    add  ax,03030h              ; add value of ax with 30h
    mov  bx,ax
 
    mov  ah,2h
    mov  dl,bh
    int  21h
    
    mov  ah,2h
    mov  dl,bl
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
    mov  dl,10                  ; move to new line
    mov  ah,2h
    int  21h
    
    jmp  main_menu
    
print_stock endp
;==========================================================================================================================================================
;=======================================================CLEAR TOTAL FUNCTION===============================================================
clear_total proc
    mov  total_prc,0
    
    lea  dx,msg_ct
    mov  ah,9
    int  21h
    
    call main_menu
clear_total endp
;============================================================================================================================================
end main
;============================================================================================================================================
;=======================================================REFERENCES===========================================================
;SWITCH CASE LOGIC
;http://innocentboysf09.blogspot.com/2013/06/switch-case-implementaion-in-assembly.html                                                                            