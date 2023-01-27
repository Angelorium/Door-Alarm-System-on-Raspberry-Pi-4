HEX

1A CONSTANT RED_LED                     \ the red LED is connected to GPIO 26
10 CONSTANT GREEN_LED                   \ the green LED is connected to GPIO 16
6 CONSTANT BUZZER                       \ The Buzzer is connected to GPIO 6
19 CONSTANT BUTTON                      \ The Button is connected to GPIO 25
1B CONSTANT HALL_SENSOR                 \ The Hall sensor is connected to GPIO 27


: INITIALIZE_PERIPHERALS
    RED_LED OUTPUT SET_GPFSEL            \ Sets gpfsel 26 to output 
    GREEN_LED OUTPUT SET_GPFSEL          \ Sets gpfsel 16 to output 
    BUZZER OUTPUT SET_GPFSEL             \ Sets gpfsel 6 to output 
    BUTTON INPUT SET_GPFSEL              \ Sets gpfsel 25 to input 
    HALL_SENSOR INPUT SET_GPFSEL         \ Sets gpfsel 27 to input 
;


\ The Button is connected to GPIO 25
\ Read FSEL25 at address GPFSEL2 address = 0xFE200008
\ Set FSEL6 to output (bit 17:15 to 000); mask 0000 0000 0000 0000 0000 0000 0000 0000 -> 0x00000000
\ Read GPLEV0 at address GPLEV0 address = 0xFE200034

HEX
FE200008 @ .                             \ Get original value
original_value AND NOT mask FE200008 !   \ Set to Output
FE200034 @ .                             \ Read pins status

\ The Hall sensor is connected to GPIO 27
\ Read FSEL27 at address GPFSEL2 address = 0xFE200008
\ Set FSEL27 to output (bit 23:21 to 000); mask 0000 0000 0000 0000 0000 0000 0000 0000 -> 0x00000000
\ Read GPLEV0 at address GPLEV0 address = 0xFE200034

HEX
FE200008 @ .                             \ Get original value
original_value AND NOT mask FE200008 !   \ Set to Output
FE200034 @ .                             \ Read pins status
