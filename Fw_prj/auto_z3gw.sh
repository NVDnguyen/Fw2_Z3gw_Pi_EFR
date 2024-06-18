#!/bin/sh -e
echo "Running Z3gateway" 
# Run z3gw from virtual environment
/home/pi/documents/Python/myenv/bin/python /home/pi/documents/Python/Fw_prj/run_z3gw.py /dev/ttyACM0 
echo "Done"
exit 0
