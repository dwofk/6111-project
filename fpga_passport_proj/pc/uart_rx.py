#!/usr/bin/python

# 6.111 Final Project - FPGA Passport
# Diana Wofk | MIT 6.111 | Fall 2016

import serial, time
from Queue import *

# Description: serial RX & write to output file
# Input: 640x400x3 bytes, corresponding to 24-bit RGB 640x400 image
# Output: binary file storing the received RGB values


# PARAMETERS
ser = serial.Serial()
#ser.port = "/dev/ttyUSB0"
#ser.port = "/dev/ttyUSB7"
#ser.port = "/dev/ttyS2"
#ser.port = "/dev/cu.usbserial-A104VDBZ"
ser.port = "/dev/cu.usbserial-AL01OV74"
ser.baudrate = 115200                       
ser.bytesize = serial.EIGHTBITS             #number of bits per bytes
ser.parity = serial.PARITY_NONE             #set parity check: no parity
ser.stopbits = serial.STOPBITS_TWO          #number of stop bits
ser.timeout = None                          #block read
#ser.timeout = 3                            #non-block read
#ser.timeout = 2                            #timeout block read
ser.xonxoff = False                         #disable software flow control
ser.rtscts = False                          #disable hardware (RTS/CTS) flow control
ser.dsrdtr = False                          #disable hardware (DSR/DTR) flow control
ser.writeTimeout = 2                        #timeout for write

#    possible timeout values:
#    1. None: wait forever, block call
#    2. 0: non-blocking mode, return immediately
#    3. x, x is bigger than 0, float allowed, timeout block call


byte_fifo = Queue(maxsize=0)

try: 
    ser.open()
except Exception, e:
    print "Error opening serial port: " + str(e)
    exit()

if ser.isOpen():

    print("Ready to receive data...")
    byte_counter = 0

    # enqueue 640x400x3 bytes into fifo
    while byte_counter < 768000:
       byte = ser.read()
       byte_fifo.put(byte)
       byte_counter = byte_counter + 1
       print(byte_counter)

    # dequeue from fifo and write to output file
    f_out = open('data.bin', 'wb')
    while not byte_fifo.empty():
        f_out.write(byte_fifo.get())
    f_out.close()
    exit()

else:
    print "ERROR: cannot open serial port"
