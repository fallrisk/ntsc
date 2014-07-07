import sys
import subprocess as sub
from time import sleep
 
# command line arguments are:
# first is the arduino IDE installation dir
# second is the arduino board type
# third is the .hex file
# fourth is the upload port
# fifth *** only used if Leonardo; omit otherwise *** serial port used to put leonardo into bootloader mode 
 
arduinoPath = sys.argv[1]
boardType = sys.argv[2]
hexFile = sys.argv[3]
port2 = sys.argv[4]
 
if(boardType == 'leonardo'):
   import serial
   port = sys.argv[len(sys.argv)-1]
 
avrconf = arduinoPath + '/hardware/tools/avr/etc/avrdude.conf'
avrdude = arduinoPath + '/hardware/tools/avr/bin/avrdude'
avrsize = arduinoPath + '/hardware/tools/avr/bin/avr-size'
 
boardsFile = open(arduinoPath + '/hardware/arduino/boards.txt',
   'rb').readlines()
 
boardSettings = {}
 
for line in boardsFile:
    if(line.startswith(boardType)):
          # strip board name, period and \n
        setting = line.replace(boardType + '.', '', 1).strip()
        [key, sign, val] = setting.rpartition('=')
        boardSettings[key] = val
 
    # check program size against maximum size
p = sub.Popen([avrsize,hexFile], stdout=sub.PIPE, stderr=sub.PIPE)#, shell=True)
output, errors = p.communicate()
if errors != "":
    print 'avr-size error: ' + errors + '\n'
    exit
 
    print ('Progam size: ' + output.split()[7] +
    ' bytes out of max ' + boardSettings['upload.maximum_size'] + '\n')
 
programCommand = [avrdude,
    '-C'+avrconf,
    '-F' ,
    '-p'+boardSettings['build.mcu'] ,
    '-c'+ boardSettings['upload.protocol'] ,
    '-b' + boardSettings['upload.speed'] ,
    '-P'+port2,
    '-Uflash:w:'+hexFile+':i']
 
    # open and close serial port at 1200 baud. This resets the Arduino Leonardo
if(boardType == 'leonardo'):
    ser = serial.Serial(port, 1200)
    ser.close()
    sleep(4)  # give the bootloader time to start up
 
p = sub.Popen(programCommand, stdout=sub.PIPE, stderr=sub.PIPE)#, shell=True)
output, errors = p.communicate()
# avrdude only uses stderr, append it
print errors
var = raw_input('Strike enter key.')