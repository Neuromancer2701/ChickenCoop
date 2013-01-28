import serial
import os
from ftplib import FTP
from time import sleep

url = "www.openrover.com"
login = "YOUR_USER_NAME"
password = "PASSWORD"
directory = "openrover/chickencoop"

data_file = 'data.json'

ser = serial.Serial()
ser.baudrate = 9600
ser.port = 3
ser.open()

print ser.portstr
sftp = FTP(url,login,password) # Connect
sftp.cwd(directory)


while 1:
    line = ser.readline()
    print line
    data = open(data_file, 'w')
    data.write(line)
    data.close()

    upload = open(data_file,'rb') # file to send
    sftp.storbinary('STOR ' + data_file, upload) # Send the file
    upload.close()
    sleep(3)


sftp.quit()
ser.close()             # close port
