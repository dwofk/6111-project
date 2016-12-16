#!/bin/bash

echo "Connecting..."
python uart_rx.py

gcc -o bin2bmp bin2bmp.c
echo "Creating bitmap..."
./bin2bmp

