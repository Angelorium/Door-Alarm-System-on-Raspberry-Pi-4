HEX

FE200000 CONSTANT PERI_BASE    \ Base addresso of peripherals
1 CONSTANT OUTPUT   
0 CONSTANT INPUT 

\ Returns the GPFSEL address of the specified fsel number
: FSEL>ADDRESS ( fsel_number -- gpfsel_register_address ) 
    10 / 4 * PERI_BASE + 
;

\ Returns the GPFSEL value of the specified fsel number
: FSEL>VALUE ( fsel_number -- gpfsel_resoger_address )
    FSEL>ADDRESS @
;


\ Create bit mask to safely modify GPIO registers value
: MASK ( fsel_number value -- bit_mask)  
    SWAP 10 MOD 3 * LSHIFT
; 

\ Returns the new_value setting to 0 the specified bit in mask
: BIC ( value mask - new_value)
    INVERT AND
;

\ Create bit mask to use bic (bit clear)
: BIC_MASK ( fsel_number -- bic_mask )
    111 MASK 
;
 
\ Set GPFSEL register to the specified value
: SET_GPFSEL ( fsel_number value -- )   
    OVER                                  \ ( fsel_number value fsel_number ) 
    BIC_MASK                              \ ( fsel_number value bic_mask ) 
    ROT DUP ROT                           \ ( bic_mask fsel_number fsel_number value )
    MASK                                  \ ( bic_mask fsel_number bit_mask ) 
    SWAP                                  \ ( bic_mask bit_mask fsel_number ) 
    DUP                                   \ ( bic_mask bit_mask fsel_number fsel_number )
    FSEL>VALUE                            \ ( bic_mask bit_mask fsel_number original_value )
    ROT                                   \ ( bit_mask fsel_number original_value bic_mask )
    BIC                                   \ ( bit_mask fsel_number bic_value ) 
    ROT                                   \ ( fsel_number bic_value bit_mask )
    OR                                    \ ( fsel_number new_value )
    SWAP                                  \ ( new_value fsel_number )
    FSEL>ADDRESS                          \ ( new_value fsel_address )
    !      
;

\ Set GPIO register 
: SET_GPSET ( gpio_pin -- )
    dup 32 < IF 1 SWAP LSHIFT 1C PERI_BASE + !                    \ gpio_pin < 32
    ELSE DUP 31 > IF 1 SWAP 32 MOD LSHIFT 20 PERI_BASE + !        \ gpio_pin > 31
    THEN THEN 
;

\ Clear GPIO register 
: SET_GPCLR ( gpio_pin -- )
    dup 32 < IF 1 SWAP LSHIFT 28 PERI_BASE + !                    \ gpio_pin < 32
    ELSE DUP 31 > IF 1 SWAP 2C MOD LSHIFT 20 PERI_BASE + !        \ gpio_pin > 31
    THEN THEN 
;