HEX

02 CONSTANT FUNCTION_SET        \ Sets 4 bit mode
01 CONSTANT CLEAR               \ Clear lcd 

: DOOR ( -- reversed_ascii_code length)
    20 52 4F 4F 44 5 
;

: CLOSED ( -- reversed_ascii_code length)
    20 44 45 53 4F 4C 43 7
;

: OPEN ( -- reversed_ascii_code length)
    20 4E 45 50 4F 5
;

\ Sends a nibble to lcd 
: SEND_NIBBLE ( LSB settings -- )
    SWAP 4 LSHIFT OR
    SEND
    1000 DELAY
;

\ Sends command to lcd 
\ It is necessary to send: D7, D6, D5, D4, Backlight, Enable, Read (1)/Write (0), Register Select (1-data 0-instruction)
\ C = 1100, 8 = 1000
\ 4 MSB|C 
\ 4 MSB|8
\ 4 LSB|C
\ 4 LBS|8
: SEND_COMMAND ( command -- )
    DUP MSB SWAP LSB SWAP DUP              \ ( LSB MSB MSB )
    0C SEND_NIBBLE 
    08 SEND_NIBBLE 
    DUP 
    0C SEND_NIBBLE
    08 SEND_NIBBLE
;

\ Sends data to lcd 
\ It is necessary to send: D7, D6, D5, D4, Backlight, Enable, Read (1)/Write (0), Register Select (1-data 0-instruction)
\ D = 1101, 9 = 1001
\ 4 MSB|D
\ 4 MSB|9
\ 4 LSB|D
\ 4 LBS|9
: SEND_DATA ( data -- ) 
    DUP MSB SWAP LSB SWAP DUP              \ ( LSB MSB MSB )
    0D SEND_NIBBLE  
    09 SEND_NIBBLE 
    DUP 
    0D SEND_NIBBLE
    09 SEND_NIBBLE 
;

\ Initializes lcd 
: INITIALIZE_LCD ( -- )
    CONFIG_I2C_GPIO
    FUNCTION_SET SEND_COMMAND
;

\ Send a word to lcd
: SEND_WORD ( reversed_ascii_code length --)
    >R 
    BEGIN R> 1 - >R SEND_DATA R@ 0 = UNTIL 
    R> DROP
;
