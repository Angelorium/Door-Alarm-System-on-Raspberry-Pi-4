HEX

1A CONSTANT RED_LED                     \ the red LED is connected to GPIO 26
10 CONSTANT GREEN_LED                   \ the green LED is connected to GPIO 16
6 CONSTANT BUZZER                       \ The Buzzer is connected to GPIO 6
19 CONSTANT BUTTON                      \ The Button is connected to GPIO 25
1B CONSTANT HALL_SENSOR                 \ The Hall sensor is connected to GPIO 27


\ Initializes peripherals 
: INITIALIZE_PERIPHERALS ( -- )
    RED_LED OUTPUT SET_GPFSEL            \ Sets gpfsel 26 to output 
    GREEN_LED OUTPUT SET_GPFSEL          \ Sets gpfsel 16 to output 
    BUZZER OUTPUT SET_GPFSEL             \ Sets gpfsel 6 to output 
    BUTTON INPUT SET_GPFSEL              \ Sets gpfsel 25 to input 
    HALL_SENSOR INPUT SET_GPFSEL         \ Sets gpfsel 27 to input 
;

\ Returns the status of the button (1 or 0)
: BUTTON_STATUS ( -- button_status)
    BUTTON READ 
;

\ Returns the status of the hall sensor (1 or 0)
: HALL_SENSOR_STATUS  ( -- hall_sensor_status)
    HALL_SENSOR READ
;

\ Returns the status of the buzzer (1 or 0)
: BUZZER_STATUS ( -- buzzer_status )
    BUZZER READ
;