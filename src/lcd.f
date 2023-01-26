HEX

02 CONSTANT RETURN_HOME         \ Set cursor to original position
01 CONSTANT CLEAR               \ Clear lcd 

: OPEN_DOOR
    79 80 69 78 32 68 79 79 82 9
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
: INITIALIZE_LCD
    CONFIG_I2C_GPIO
    RETURN_HOME SEND_COMMAND
;

: SEND_WORD
    >R 
    BEGIN R> 1 - >R SEND_DATA UNTIL R@ 0 >
;