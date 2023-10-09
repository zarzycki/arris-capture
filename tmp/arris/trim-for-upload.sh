#!/bin/bash

NUMENTRIES=960

mkdir -p for-upload
tail -${NUMENTRIES} downstream-freq.csv > for-upload/downstream-freq.csv
tail -${NUMENTRIES} downstream-SNR.csv > for-upload/downstream-SNR.csv
tail -${NUMENTRIES} downstream-power.csv > for-upload/downstream-power.csv
tail -${NUMENTRIES} ping_packetloss.csv > for-upload/ping_packetloss.csv
tail -${NUMENTRIES} ping_timings.csv > for-upload/ping_timings.csv
tail -${NUMENTRIES} upstream-freq.csv > for-upload/upstream-freq.csv
tail -${NUMENTRIES} upstream-power.csv > for-upload/upstream-power.csv
