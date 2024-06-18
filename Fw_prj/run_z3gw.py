import subprocess
import os
import time
import serial
import sys
import re
from datetime import datetime

# Global variables
log_file = "/home/pi/documents/Python/Fw_prj/log.txt" 
log_out = "/home/pi/documents/Python/Fw_prj/log_z3gw.txt"
MAX_LOG_SIZE_BYTES = 1024 
last_written_content = None
first = True # assume button unused, first run will exe some command t

# iniit serial
def init_serial(port):
    global ser
    try:
        ser = serial.Serial(port, 115200)
    except Exception as e:
        print(f"Failed to initialize serial port {port}: {str(e)}")
        sys.exit(1)
        
# first init for z3gw
def create_zigbee_network(serial_port):
    init_serial(serial_port)
    execute_command(f"/home/pi/Z3gateway_2 -p {serial_port} -b 115200")
    
    
# open command for static node id
def open_network():
    cmds =[
        "network leave"
        "plugin network-creator start 1",
        "plugin network-creator-security open-network"
    ]
    for cmd in cmds:
        print(f"Executing custom command: {cmd}")
        subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
    
# open network command each clicked button
def  button_clicked():
    global first
    if first :
        first = False
        return True
    else:
        return False
    return True
       
# exe command and process data        
def execute_command(cmd) -> str:
    try:
        print(f"Executing command: {cmd}")
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        log_output = []
        while True:
            output = process.stdout.readline()
            if output == b'' and process.poll() is not None:
                break
            if output:
                decoded_output = output.decode('utf-8').strip()
                log_output.append(decoded_output)                          
                # Recieve data
                if decoded_output.startswith('T'):                    
                    extract_payload(decoded_output)
                # if button_clicked():
                #     open_network()
                # #print(f"Command output: {decoded_output}")
                write_to_file(log_out,decoded_output)    
                
        err = process.stderr.read().decode('utf-8').strip()
        if err:
            print(f"Error executing command: {cmd} - {err}")
        return '\n'.join(log_output).strip()
    except Exception as err:
        print(f"Execute command error: {str(err)}")
        return str(err)
# process data payload
def extract_payload(output):
    payload_pattern = r'payload\[(.*?)\]'
    match_payload = re.search(payload_pattern, output)
    if match_payload:
        payload_hex = match_payload.group(1)
        payload_int_list = [int(x, 16) for x in payload_hex.split()]
        if len(payload_int_list) >= 7:  
            source_high_byte = payload_int_list[0]
            source_low_byte = payload_int_list[1]
            source_node_id = (source_high_byte << 8) + source_low_byte
            temperature = payload_int_list[2]
            humidity = payload_int_list[3]
            smoke = payload_int_list[4]
            fire = payload_int_list[5]
            alarm_bell = payload_int_list[6]  
            print(f"Node ID: {source_node_id}, Temperature: {temperature}, Humidity: {humidity}, Smoke: {smoke}, Fire: {fire}, Alarm Bell: {alarm_bell}")  
            write_to_file(log_file, f"Node ID: {source_node_id}, Temperature: {temperature}, Humidity: {humidity}, Smoke: {smoke}, Fire: {fire}, Alarm Bell: {alarm_bell}") 
            return {
                "Node ID": source_node_id,
                "Temperature": temperature,
                "Humidity": humidity,
                "Smoke": smoke,
                "Fire": fire,
                "Alarm Bell": alarm_bell 
            }
# write log
def write_to_file(file_name, content):
    global last_written_content
    try:
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(file_name, 'a') as f:
            f.write(f"{current_time} - {content}\n")
        # print(f"Write to file {file_name} successful: {content}")
        last_written_content = content
    except Exception as e:
        print(f"Write file {file_name} error: {str(e)}")
        



# delete old log
def check_and_delete_old_logs(file_name, max_size_bytes):
    try:
        if os.path.getsize(file_name) > max_size_bytes:
            with open(file_name, 'r') as f:
                lines = f.readlines()
            with open(file_name, 'w') as f:
                f.writelines(lines[-100:])  # Keep the latest 100 records
            print(f"Deleted old log records, keeping the latest 100 records.")
    except Exception as e:
        print(f"Error checking and deleting old logs: {str(e)}")


# main
def main(serial_port):
    create_zigbee_network(serial_port)
    serial_log, network_status = read_serial_data()
    print("Network Status:", network_status)
    
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please provide the serial port")
        sys.exit(1)
    serial_port = sys.argv[1]
    check_and_delete_old_logs(log_file, MAX_LOG_SIZE_BYTES)
    main(serial_port)