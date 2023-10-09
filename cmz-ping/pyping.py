import csv
import ipaddress
import os
import subprocess
import sys

DOMAIN = "www.comcast.com"

RUNDATE = subprocess.getoutput("date \"+%F %T\"")

print("Pinging %s ..." % DOMAIN, file=sys.stderr)
command = "ping -q -t 810 %s" % DOMAIN
output = subprocess.getoutput(command)
for row in output.split('\n'):
  if '=' in row:
    timings = row.split('=')[1]
    timings = timings.strip().split(' ')[0]
    time0 = timings.strip().split('/')[0]
    time1 = timings.strip().split('/')[1]
    time2 = timings.strip().split('/')[2]
    time3 = timings.strip().split('/')[3]
    print(time0)
  if 'packet' in row:
    transmit, receive, loss = row.split(',')
    transmit=transmit.strip().split(' ')[0]
    receive=receive.strip().split(' ')[0]
    loss=loss.strip().split(' ')[0]
    loss=loss.replace("%", "")
    print(transmit)
    print(receive)
    print(loss)

thisFile='/Users/colin/Software/arris-capture/tmp/arris/ping_packetloss.csv' 
if not os.path.isfile(thisFile):
  existflag=False
else:
  existflag=True

with open(thisFile, 'a', newline='') as f:
  writer = csv.writer(f)
  if not existflag:
    writer.writerow(("DTS", "% success"))
    
  if loss:
    writer.writerow((str(RUNDATE),loss))
  else:
    # If we reach this point the ping command output
    # was not in the expected output format
    writer.writerow((str(RUNDATE), ""))

###################################################################################

thisFile='/Users/colin/Software/arris-capture/tmp/arris/ping_timings.csv' 
if not os.path.isfile(thisFile):
  existflag=False
else:
  existflag=True
  
with open(thisFile, 'a', newline='') as f:
  writer = csv.writer(f)
  if not existflag:
    writer.writerow(("DTS", "min","avg","max"))
  
  if timings:
    writer.writerow((str(RUNDATE),time0,time1,time2))
  else:
    writer.writerow((str(RUNDATE), ""))
