HEX

FE200000 CONSTANT PERI_BASE    \ Base addresso of peripherals
1 CONSTANT OUTPUT   
0 CONSTANT INPUT 

\ Returns the GPFSEL address of the specified fsel number
: FSEL>ADDRESS ( fsel_number -- gpfsel_register_address ) 
    10 / 4 * PERI_BASE + 
;

\ Create bit mask to safely modify GPIO registers value
: MASK ( fsel_number value -- bit_mask)  
    SWAP 10 mod 3 * lshift
; 

\ 26 OUTPUT SET_GPFSEL     
\ Set GPIO register to the specified value
: SET_GPFSEL ( fsel_number value -- )   
      \ create bit mask
      \ read register value
      \ make new register value using bitwise or  
      \ update register value
;