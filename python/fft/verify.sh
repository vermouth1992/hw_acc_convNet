#!/usr/bin/env bash
mv ../../app/fifo_model/input_buffer.txt ./
mv ../../app/fifo_model/output_buffer.txt ./
python verify_hardware.py -i input_buffer.txt -o output_buffer.txt
