\ The red LED is connected to GPIO 26
\ Read FSEL26 at address GPFSEL2 address = 0xFE200008
\ Set FSEL26 to output (bit 20:18 to 001); mask 0000 0000 0000 0100 0000 0000 0000 0000 -> 0x0004000
\ To turn on the LED set GPSET0 bit 26 to 1 0000 0100 0000 0000 0000 0000 0000 0000  -> 0x04000000   GPSET0 address = 0xFE20001C
\ To turn off the LED set GPCLR0 bit 26 to 1 0000 0100 0000 0000 0000 0000 0000 0000 -> 0x04000000   GPCLR0 address = 0xFE200028

HEX
FE200008 @ .
original_value OR mask FE200008 !  \ Set to Output
04000000 FE20001C !  \ Set High
04000000 FE200028 !  \ Set Low

\ The green LED is connected to GPIO 16
\ Read FSEL16 at address GPFSEL1 address = 0xFE200004
\ Set FSEL16 to output (bit 20:18 to 001); mask 0000 0000 0000 0100 0000 0000 0000 0000 -> 0x00040000
\ To turn on the LED set GPSET0 bit 16 to 1  0000 0000 0000 0001 0000 0000 0000 0000    -> 0x00010000   GPSET0 address = 0xFE20001C
\ To turn off the LED set GPCLR0 bit 16 to 1 0000 0100 0000 0001 0000 0000 0000 0000    -> 0x00010000   GPCLR0 address = 0xFE200028

HEX
FE200004 @ .                         \ Get original value
original_value OR mask FE200004 !    \ Set to Output
00010000 FE20001C !                  \ Set High
00010000 FE200028 !                  \ Set Low

\ The Buzzer is connected to GPIO 6
\ Read FSEL6 at address GPFSEL0 address = 0xFE200000
\ Set FSEL6 to output (bit 20:18 to 001); mask 0000 0000 0000 0100 0000 0000 0000 0000 -> 0x00040000
\ To turn on the Buzzer set GPSET0 bit 6 to 1  0000 0000 0000 0000 0000 0000 0100 0000 -> 0x00000040   GPSET0 address = 0xFE20001C
\ To turn off the Buzzer set GPCLR0 bit 6 to 1 0000 0100 0000 0000 0000 0000 0100 0000 -> 0x00000040   GPCLR0 address = 0xFE200028

HEX
FE200000 @ .                        \ Get original value
original_value OR mask FE200000 !   \ Set to Output
00000040 FE20001C !                 \ Set High
00000040 FE200028 !                 \ Set Low

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
