#!/bin/bash

cd src/
cat se-ans.f utils.f i2c.f lcd.f peripherals.f main.f |
awk -F"\\" '{print $1}' |  				             
awk -F"[^A-Z]+[()][^A-Z]+" '{print $1 $    3}' | 	 
awk '{ printf "%s ", $0 }' |                         
sed 's/\;/\;\n/g' |                                 
sed '/^[[:space:]]*$/d' |				             
sed -e 's/\t/ /g' | tr -s ' ' > merged_src.f  	 
