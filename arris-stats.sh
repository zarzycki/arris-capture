#!/bin/sh
# Script by graysky
# https://github.com/graysky2/bin/blob/master/arris_signals
#

# PREFACE
# This very trivial script will log the downstream/upstream power levels
# as well as the respective SNR from your Arris TM822 and related modem
# to individual csv values suitable for graphing in dygraphs[1].
#
# Use it to monitor power levels, frequencies, and SNR values over time to aid
# in troubleshooting connectivity with your ISP. The script is easily called
# from a cronjob at some appropriate interval (hourly for example).
#
# It is recommended that users simply call the script via a cronjob at the
# desired interval. Perhaps twice per hour is enough resolution.
#
# Note that the crude grep/awk/sed lines work fine on an Arris TM822G running
# Firmware            : TS070659C_050313_MODEL_7_8_SIP_PC20
# Firmware build time : Fri May 3 11:18:59 EDT 2013

# INSTALLATION
# 1. Place the script 'capture_arris_for_dygraphs.sh' in a directory of your
#    choosing and make it executable. Edit it to defining the correct path
#    for storage of the log files which need to be web-exposed for dygraph
#    to work properly.
#
# 2. Place 'dygraph-combined.js' and 'index.html' into the web-exposed dir you
#    defined in step #1.

# REFERENCES
# 1. https://github.com/danvk/dygraphs

###############               Configuration            #####################
# TEMP is the full path to the temp file wget will grab from your modem.
#      it is recommended to use something in tmpfs like /tmp for example.
TEMP=/Users/colin/Software/arris-capture/tmp/snapshot.html

# LOGPATH is the full path to the log file you will keep.
LOGPATH=/Users/colin/Software/arris-capture/tmp/arris

# If you want to log all html snapshots set KEEPTHEM to any value
# Be sure that you have sufficient storage for this as files are around 5 Kb
# and can add up over time!
KEEPTHEM=yes

###############       Do not edit below this line         ##################
###############    Unless you know what you're doing      ##################

fail() {
	echo "$RUNDATE Modem is unreachable" >> "$LOGPATH/arris_errors.txt"
	exit 1
}

RUNDATE=$(date "+%F %T")
[[ ! -d "$LOGPATH" ]] && echo "You defined an invalid LOGPATH!" && exit 1

# remove old dump file to avoid duplicate entries
[[ -f "$TEMP" ]] && rm -f "$TEMP"

# try to get stats 6 times waiting 10 sec per time
wget -q -T 10 -t 6 http://192.168.100.1/RgConnect.asp -O $TEMP || fail

if [[ -n "$KEEPTHEM" ]]; then
	SAVE="$LOGPATH/snapshots"
	CAPDATE=$(date "+%Y%m%d_%H%M%S")
	[[ ! -d "$SAVE" ]] && mkdir "$SAVE"
	[[ -f "$TEMP" ]] && cp "$TEMP" "$SAVE/$CAPDATE.html"
fi

# find downstream frequencies
DF1=$(grep -a '<tr><td>1</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF2=$(grep -a '<tr><td>2</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF3=$(grep -a '<tr><td>3</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF4=$(grep -a '<tr><td>4</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF5=$(grep -a '<tr><td>5</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF6=$(grep -a '<tr><td>6</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF7=$(grep -a '<tr><td>7</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF8=$(grep -a '<tr><td>8</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF9=$(grep -a '<tr><td>9</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF10=$(grep -a '<tr><td>10</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF11=$(grep -a '<tr><td>11</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF12=$(grep -a '<tr><td>12</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF13=$(grep -a '<tr><td>13</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF14=$(grep -a '<tr><td>14</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF15=$(grep -a '<tr><td>15</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')
DF16=$(grep -a '<tr><td>16</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $6 }' | sed 's| Hz.*||')

# downstream power
DP1=$(grep -a '<tr><td>1</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP2=$(grep -a '<tr><td>2</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP3=$(grep -a '<tr><td>3</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP4=$(grep -a '<tr><td>4</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP5=$(grep -a '<tr><td>5</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP6=$(grep -a '<tr><td>6</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP7=$(grep -a '<tr><td>7</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP8=$(grep -a '<tr><td>8</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP9=$(grep -a '<tr><td>9</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP10=$(grep -a '<tr><td>10</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP11=$(grep -a '<tr><td>11</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP12=$(grep -a '<tr><td>12</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP13=$(grep -a '<tr><td>13</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP14=$(grep -a '<tr><td>14</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP15=$(grep -a '<tr><td>15</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')
DP16=$(grep -a '<tr><td>16</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| dBmV.*||')

# downstream snr
DS1=$(grep -a '<tr><td>1</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS2=$(grep -a '<tr><td>2</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS3=$(grep -a '<tr><td>3</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS4=$(grep -a '<tr><td>4</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS5=$(grep -a '<tr><td>5</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS6=$(grep -a '<tr><td>6</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS7=$(grep -a '<tr><td>7</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS8=$(grep -a '<tr><td>8</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS9=$(grep -a '<tr><td>9</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS10=$(grep -a '<tr><td>10</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS11=$(grep -a '<tr><td>11</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS12=$(grep -a '<tr><td>12</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS13=$(grep -a '<tr><td>13</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS14=$(grep -a '<tr><td>14</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS15=$(grep -a '<tr><td>15</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')
DS16=$(grep -a '<tr><td>16</td><td>Locked</td><td>QAM256</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dB.*||')


# find upstream frequencies
# note my modem does not show a value for Upstream 2
# so use a different strategy

UF1=$(grep -a '<tr><td>1</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| Hz.*||')
UF2=$(grep -a '<tr><td>2</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| Hz.*||')
UF3=$(grep -a '<tr><td>3</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| Hz.*||')
UF4=$(grep -a '<tr><td>4</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $7 }' | sed 's| Hz.*||')

# upstream power
UP1=$(grep -a '<tr><td>1</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dBmV.*||')
UP2=$(grep -a '<tr><td>2</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dBmV.*||')
UP3=$(grep -a '<tr><td>3</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dBmV.*||')
UP4=$(grep -a '<tr><td>4</td><td>Locked</td><td>ATDMA</td>' $TEMP | awk -F'<td>' '{ print $8 }' | sed 's| dBmV.*||')

# force a 0 value when undefined due to poor connectivity
[[ "$DF1" = "----</td>" ]] && DF1=0
[[ "$DF2" = "----</td>" ]] && DF2=0
[[ "$DF3" = "----</td>" ]] && DF3=0
[[ "$DF4" = "----</td>" ]] && DF4=0
[[ "$DF5" = "----</td>" ]] && DF5=0
[[ "$DF6" = "----</td>" ]] && DF6=0
[[ "$DF7" = "----</td>" ]] && DF7=0
[[ "$DF8" = "----</td>" ]] && DF8=0
[[ "$DF9" = "----</td>" ]] && DF9=0
[[ "$DF10" = "----</td>" ]] && DF10=0
[[ "$DF11" = "----</td>" ]] && DF11=0
[[ "$DF12" = "----</td>" ]] && DF12=0
[[ "$DF13" = "----</td>" ]] && DF13=0
[[ "$DF14" = "----</td>" ]] && DF14=0
[[ "$DF15" = "----</td>" ]] && DF15=0
[[ "$DF16" = "----</td>" ]] && DF16=0

[[ "$DP1" = "----</td>" ]] && DP1=0
[[ "$DP2" = "----</td>" ]] && DP2=0
[[ "$DP3" = "----</td>" ]] && DP3=0
[[ "$DP4" = "----</td>" ]] && DP4=0
[[ "$DP5" = "----</td>" ]] && DP5=0
[[ "$DP6" = "----</td>" ]] && DP6=0
[[ "$DP7" = "----</td>" ]] && DP7=0
[[ "$DP8" = "----</td>" ]] && DP8=0
[[ "$DP9" = "----</td>" ]] && DP9=0
[[ "$DP10" = "----</td>" ]] && DP10=0
[[ "$DP11" = "----</td>" ]] && DP11=0
[[ "$DP12" = "----</td>" ]] && DP12=0
[[ "$DP13" = "----</td>" ]] && DP13=0
[[ "$DP14" = "----</td>" ]] && DP14=0
[[ "$DP15" = "----</td>" ]] && DP15=0
[[ "$DP16" = "----</td>" ]] && DP16=0

[[ "$DS1" = "----</td>" ]] && DS1=0
[[ "$DS2" = "----</td>" ]] && DS2=0
[[ "$DS3" = "----</td>" ]] && DS3=0
[[ "$DS4" = "----</td>" ]] && DS4=0
[[ "$DS5" = "----</td>" ]] && DS5=0
[[ "$DS6" = "----</td>" ]] && DS6=0
[[ "$DS7" = "----</td>" ]] && DS7=0
[[ "$DS8" = "----</td>" ]] && DS8=0
[[ "$DS9" = "----</td>" ]] && DS9=0
[[ "$DS10" = "----</td>" ]] && DS10=0
[[ "$DS11" = "----</td>" ]] && DS11=0
[[ "$DS12" = "----</td>" ]] && DS12=0
[[ "$DS13" = "----</td>" ]] && DS13=0
[[ "$DS14" = "----</td>" ]] && DS14=0
[[ "$DS15" = "----</td>" ]] && DS15=0
[[ "$DS16" = "----</td>" ]] && DS16=0

[[ "$UF1" = "----</td>" ]] && UF1=0
[[ "$UF2" = "----</td>" ]] && UF2=0
[[ "$UF3" = "----</td>" ]] && UF3=0
[[ "$UF4" = "----</td>" ]] && UF4=0
[[ -z "$UF1" ]] && UF1=0
[[ -z "$UF2" ]] && UF2=0
[[ -z "$UF3" ]] && UF3=0
[[ -z "$UF4" ]] && UF4=0

[[ "$UP1" = "----</td>" ]] && UP1=0
[[ "$UP2" = "----</td>" ]] && UP2=0
[[ "$UP3" = "----</td>" ]] && UP3=0
[[ "$UP4" = "----</td>" ]] && UP4=0
[[ -z "$UP1" ]] && UP1=0
[[ -z "$UP2" ]] && UP2=0
[[ -z "$UP3" ]] && UP3=0
[[ -z "$UP4" ]] && UP4=0

# The individual log files
DLOGFREQ="$LOGPATH/downstream-freq.csv"
DLOGPOWER="$LOGPATH/downstream-power.csv"
DLOGSNR="$LOGPATH/downstream-SNR.csv"
ULOGFREQ="$LOGPATH/upstream-freq.csv"
ULOGPOWER="$LOGPATH/upstream-power.csv"

# downstream frequency log
[[ ! -f $DLOGFREQ ]] && echo "DTS,Downstream 1,Downstream 2,Downstream 3,Downstream 4,Downstream 5,Downstream 6,Downstream 7,Downstream 8,Downstream 9,Downstream 10,Downstream 11,Downstream 12,Downstream 13,Downstream 14,Downstream 15,Downstream 16" > $DLOGFREQ
echo "$RUNDATE,${DF1/ *},${DF2/ *},${DF3/ *},${DF4/ *},${DF5/ *},${DF6/ *},${DF7/ *},${DF8/ *},${DF9/ *},${DF10/ *},${DF11/ *},${DF12/ *},${DF13/ *},${DF14/ *},${DF15/ *},${DF16/ *}" >> $DLOGFREQ

# downstream power log
[[ ! -f $DLOGPOWER ]] && echo "DTS,Downstream 1,Downstream 2,Downstream 3,Downstream 4,Downstream 5,Downstream 6,Downstream 7,Downstream 8,Downstream 9,Downstream 10,Downstream 11,Downstream 12,Downstream 13,Downstream 14,Downstream 15,Downstream 16" > $DLOGPOWER
echo "$RUNDATE,$DP1,$DP2,$DP3,$DP4,$DP5,$DP6,$DP7,$DP8,$DP9,$DP10,$DP11,$DP12,$DP13,$DP14,$DP15,$DP16" >> $DLOGPOWER

# downstream SNR log
[[ ! -f $DLOGSNR ]] && echo "DTS,Downstream 1,Downstream 2,Downstream 3,Downstream 4,Downstream 5,Downstream 6,Downstream 7,Downstream 8,Downstream 9,Downstream 10,Downstream 11,Downstream 12,Downstream 13,Downstream 14,Downstream 15,Downstream 16" > $DLOGSNR
echo "$RUNDATE,$DS1,$DS2,$DS3,$DS4,$DS5,$DS6,$DS7,$DS8,$DS9,$DS10,$DS11,$DS12,$DS13,$DS14,$DS15,$DS16" >> $DLOGSNR

# upstream freq log
[[ ! -f $ULOGFREQ ]] && echo "DTS,Upstream 1,Upstream 2,Upstream 3,Upstream 4" > $ULOGFREQ
echo "$RUNDATE,${UF1/ *},${UF2/ *},${UF3/ *},${UF4/ *}" >> $ULOGFREQ

# upstream power log
[[ ! -f $ULOGPOWER ]] && echo "DTS,Upstream 1,Upstream 2,Upstream 3,Upstream 4" > $ULOGPOWER
echo "$RUNDATE,$UP1,$UP2,$UP3,$UP4" >> $ULOGPOWER
