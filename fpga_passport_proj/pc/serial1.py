import serial
import sys
import glob

def serial_ports():
    if sys.platform.startswith('win'):
        ports = ['COM%s' % (i + 1) for i in list(range(256))]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this excludes your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.*')
    else:
        raise EnvironmentError('Unsupported platform')
    print(ports)
    result = []
    return ports
#-------------------

ports = serial_ports() #generate list of currently connected serial ports 
print (ports)
print("Might need to change the number in code based on what gets printed out")
ser = ports[1]
s = serial.Serial(ser)
print(s)


#f = open('./test.bit','rb')
#command=b"\x39"
f=open('londond_hex.txt','r')
for byteinline in f:
    command = byteinline 
    command=bytearray.fromhex(command)
    s.write(command)

s.close()
    



