#!/bin/bash

exit_code=0

usage()
{
  echo "Usage: check_nvidia-smi.sh [ -a | --alpha ] 
                                   [ -b | --beta ]
                                   [ -c | --charlie CHARLIE ]
                                   [ -d | --delta   DELTA ]"
  exit_code=3
  exit 3
}

nvidia_smi_log="nvidia_smi_log"
gpu="${nvidia_smi_log}/gpu"
fan_speed="${gpu}/fan_speed"
power_readings="${gpu}/power_readings"
power_state="${power_readings}/power_state"
power_management="${power_readings}/power_management"
power_draw="${power_readings}/power_draw"
power_limit="${power_readings}/power_limit"
default_power_limit="${power_readings}/default_power_limit"
enforced_power_limit="${power_readings}/enforced_power_limit"
min_power_limit="${power_readings}/min_power_limit"
max_power_limit="${power_readings}/max_power_limit"
temperature="${gpu}/temperature"
gpu_temp="${temperature}/gpu_temp"
gpu_temp_max_threshold="${temperature}/gpu_temp_max_threshold"
gpu_temp_slow_threshold="${temperature}/gpu_temp_slow_threshold"
gpu_temp_max_gpu_threshold="${temperature}/gpu_temp_max_gpu_threshold"
memory_temp="${temperature}/memory_temp"
gpu_temp_max_mem_threshold="${temperature}/gpu_temp_max_mem_threshold"
utilization="${gpu}/utilization"
gpu_util="${utilization}/gpu_util"
memory_util="${utilization}/memory_util"
encoder_util="${utilization}/encoder_util"
decoder_util="${utilization}/decoder_util"

tmpXmlFileName=nvidia.xml
tmpXmlDir=/tmp
HELP=false

tmpDirTrimmed=$(echo $tmpXmlDir | sed 's:/*$::')
tmpXml=$tmpDirTrimmed/$tmpXmlFileName

hash xmlstarlet 2>/dev/null
checkXmlstarlet=$?
if [ $checkXmlstarlet -ne 0 ]; then
        echo "UNKNOWN: xmlstarlet not found. Try to install xmlstarlet"
        exit_code=3
        exit 3
fi

hash nvidia-smi 2>/dev/null
checkNvidiaSmi=$?
if [ $checkNvidiaSmi -ne 0 ]; then
        echo "UNKNOWN: nvidia-smi not found. Try to install nvidia-smi"
        exit_code=3
        exit 3
fi

nvidia-smi -q -x --filename=$tmpXml
checkXmlCreation=$?
if [ $checkXmlCreation -ne 0 ]; then
        echo "UNKNOWN: could not create $tmpXml with user $USER"
        exit_code=3
        exit 3
fi


max_power_limit=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $max_power_limit | awk '{print $1}' | awk -F "." '{print $1$2}')
power_draw_crit=$(($max_power_limit / 100 ))
enforced_power_limit=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $enforced_power_limit | awk '{print $1}' | awk -F "." '{print $1$2}')
default_power_limit=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $default_power_limit | awk '{print $1}' | awk -F "." '{print $1$2}')
if [[ $enforced_power_limit =~ $isnumber ]]
then
        power_draw_warn=$(($enforced_power_limit / 100 ))
else
        power_draw_warn=$(($default_power_limit / 100 ))
fi
gpu_temp_max_threshold=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $gpu_temp_max_threshold | awk '{print $1}')
gpu_temp_crit=$gpu_temp_max_threshold
gpu_temp_slow_threshold=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $gpu_temp_slow_threshold | awk '{print $1}')
gpu_temp_warn=$gpu_temp_slow_threshold
gpu_temp_max_mem_threshold=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $gpu_temp_max_mem_threshold | awk '{print $1}')
memory_temp_crit=$gpu_temp_max_mem_threshold
gpu_temp_max_mem_threshold=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $gpu_temp_max_mem_threshold | awk '{print $1}')
memory_temp_warn=$gpu_temp_max_mem_threshold
gpu_util_crit=100
gpu_util_warn=80
memory_util_crit=100
memory_util_warn=80
encoder_util_crit=100
encoder_util_warn=80
decoder_util_crit=100
decoder_util_warn=80

OPTS=$(getopt -n 'check_nvidia-smi' -o fpgmGMED --long power_draw_warn:,power_draw_crit:,gpu_temp_warn:,gpu_temp_crit:,memory_temp_warn:,memory_temp_crit:,gpu_util_warn:,gpu_util_crit:,memory_util_warn:,memory_util_crit:,encoder_util_warn:,encoder_util_crit:,decoder_util_warn:,decoder_util_crit: -- "$@")
getOptsExitCode=$?
if [ $getOptsExitCode != 0 ]
then
        echo "UNKNOWN: Failed parsing options." >&2 ;
        usage
        exit_code=3
        exit 3 
fi

eval set -- "$OPTS"
while :
do
        case "$1" in
                -f ) fan_speed=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $fan_speed | awk '{print $1}' ) ; shift ;;
                -p ) power_draw=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $power_draw | awk '{print $1}' | awk -F "." '{print $1$2}' ) ; shift ;;
                -g ) gpu_temp=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $gpu_temp | awk '{print $1}' ) ; shift ;;
                -m ) memory_temp=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $memory_temp | awk '{print $1}' ) ; shift ;;
                -G ) gpu_util=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $gpu_util | awk '{print $1}' ) ; shift ;;
                -M ) memory_util=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $memory_util | awk '{print $1}' ) ; shift ;;
                -E ) encoder_util=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $encoder_util | awk '{print $1}' ) ; shift ;;
                -D ) decoder_util=$(xmlstarlet fo --dropdtd $tmpXml | xmlstarlet sel -t -v $decoder_util | awk '{print $1}' ) ; shift ;;
                --power_draw_crit ) power_draw_crit="$2"; shift 2 ;;
                --power_draw_warn ) power_draw_warn="$2"; shift 2 ;;
                --gpu_temp_crit ) gpu_temp_crit="$2"; shift 2 ;;
                --gpu_temp_warn ) gpu_temp_warn="$2"; shift 2 ;;
                --memory_temp_crit ) memory_temp_crit="$2"; shift 2 ;;
                --memory_temp_warn ) memory_temp_warn="$2"; shift 2 ;;
                --gpu_util_crit ) gpu_util_crit="$2"; shift 2 ;;
                --gpu_util_warn ) gpu_util_crit="$2"; shift 2 ;;
                --memory_util_crit ) memory_util_crit="$2"; shift 2 ;;
                --memory_util_warn ) memory_util_warn="$2"; shift 2 ;;
                --encoder_util_crit ) encoder_util_crit="$2"; shift 2 ;;
                --encoder_util_warn ) encoder_util_warn="$2"; shift 2 ;;
                --decoder_util_crit ) decoder_util_crit="$2"; shift 2 ;;
                --decoder_util_warn ) decoder_util_warn="$2"; shift 2 ;;
                -- ) shift; break ;;
                * ) break ;;
        esac
done

rm -f $tmpXml

serviceoutput=""
perfdata=""
isnumber='^[0-9]+$'

if [[ ${gpu_temp} != *$nvidia_smi_log* ]]
then
        serviceoutput="${serviceoutput}gpu_temp=${gpu_temp}C,"
        if ! [[ $gpu_temp =~ $isnumber ]] && [ $((exit_code)) -lt 2 ]
        then
                exit_code=3
        fi
        if [[ $gpu_temp_warn =~ $isnumber ]]
        then
                if [[ $gpu_temp_crit =~ $isnumber ]]
                then
                        if [ $((gpu_temp_crit)) -lt $((gpu_temp_warn)) ]
                        then
                                invert=$((gpu_temp_crit))
                                gpu_temp_crit=$((gpu_temp_warn))
                                gpu_temp_warn=$((invert))
                        fi
                        if [[ $gpu_temp =~ $isnumber ]]
                        then
                                if [ $((gpu_temp_crit)) -lt $((gpu_temp)) ] && [ $((exit_code)) -lt 2 ]
                                then
                                        exit_code=2
                                elif [ $((gpu_temp_warn)) -lt $((gpu_temp)) ] && [ $((exit_code)) -lt 1 ]
                                then
                                        exit_code=1
                                fi
                        fi
                        perfdata="${perfdata} gpu_temp=${gpu_temp}Celsius;$gpu_temp_warn;$gpu_temp_crit"
                else
                        if [[ $gpu_temp =~ $isnumber ]]
                        then
                                if [ $((gpu_temp_warn)) -lt $((gpu_temp)) ] && [ $((exit_code)) -lt 1 ]
                                then
                                        exit_code=1
                                fi
                        fi
                        perfdata="${perfdata} gpu_temp=${gpu_temp}Celsius;$gpu_temp_warn"
                fi
        elif [[ $gpu_temp_crit =~ $isnumber ]]
        then
                if [[ $gpu_temp =~ $isnumber ]]
                then
                        if [ $((gpu_temp_crit)) -lt $((gpu_temp)) ] && [ $((exit_code)) -lt 2 ]
                        then
                                exit_code=2
                        fi
                fi
                perfdata="${perfdata} gpu_temp=${gpu_temp}Celsius;;$gpu_temp_crit"
        else
                perfdata="${perfdata} gpu_temp=${gpu_temp}Celsius"
        fi
fi

if [[ ${memory_temp} != *$nvidia_smi_log* ]]
then
        serviceoutput="${serviceoutput}memory_temp=${memory_temp}C,"
        if ! [[ $memory_temp =~ $isnumber ]] && [ $((exit_code)) -lt 2 ]
        then
                exit_code=3
        fi
        if [[ $memory_temp_warn =~ $isnumber ]]
        then
                if [[ $memory_temp_crit =~ $isnumber ]]
                then
                        if [ $((memory_temp_crit)) -lt $((memory_temp_warn)) ]
                        then
                                invert=$((memory_temp_crit))
                                memory_temp_crit=$((memory_temp_warn))
                                memory_temp_warn=$((invert))
                        fi
                        if [[ $memory_temp =~ $isnumber ]]
                        then
                                if [ $((memory_temp_crit)) -lt $((memory_temp)) ] && [ $((exit_code)) -lt 2 ]
                                then
                                        exit_code=2
                                elif [ $((memory_temp_warn)) -lt $((memory_temp)) ] && [ $((exit_code)) -lt 1 ]
                                then
                                        exit_code=1
                                fi
                        fi
                        perfdata="${perfdata} memory_temp=${memory_temp}Celsius;$memory_temp_warn;$memory_temp_crit"
                else
                        if [[ $memory_temp =~ $isnumber ]]
                        then
                                if [ $((memory_temp_warn)) -lt $((memory_temp)) ] && [ $((exit_code)) -lt 1 ]
                                then
                                        exit_code=1
                                fi
                        fi
                        perfdata="${perfdata} memory_temp=${memory_temp}Celsius;$memory_temp_warn"
                fi
        elif [[ $memory_temp_crit =~ $isnumber ]]
        then
                if [[ $memory_temp =~ $isnumber ]]
                then
                        if [ $((memory_temp_crit)) -lt $((memory_temp)) ] && [ $((exit_code)) -lt 2 ]
                        then
                                exit_code=2
                        fi
                fi
                perfdata="${perfdata} memory_temp=${memory_temp}Celsius;;$memory_temp_crit"
        else
                perfdata="${perfdata} memory_temp=${memory_temp}Celsius"
        fi
fi

if [[ ${fan_speed} != *$nvidia_smi_log* ]]
then
        serviceoutput="${serviceoutput}fan_speed=${fan_speed}%,"
        if ! [[ $fan_speed =~ $isnumber ]] && [ $((exit_code)) -lt 2 ]
        then
                exit_code=3
        fi
        perfdata="${perfdata} fan_speed=${fan_speed}%"
fi

if [[ ${power_draw} != *$nvidia_smi_log* ]]
then
        serviceoutput="${serviceoutput}power_draw=$(echo "scale=2; ${power_draw}/100" | bc )W,"
        if ! [[ $power_draw =~ $isnumber ]] && [ $((exit_code)) -lt 2 ]
        then
                exit_code=3
        fi
        if [[ $power_draw_warn == *":"* ]]
        then
                power_draw_warn_min=`echo $power_draw_warn | awk -F ":" '{print $1}'`
                power_draw_warn_max=`echo $power_draw_warn | awk -F ":" '{print $2}'`
                if [[ $power_draw_warn_min =~ $isnumber ]]
                then
                        power_draw_warn_min=$(($power_draw_warn_min * 100))
                        if [[ $power_draw_warn_max =~ $isnumber ]]
                        then
                                power_draw_warn_max=$(($power_draw_warn_max * 100))
                                if [ $((power_draw_warn_min)) -gt $((power_draw_warn_max)) ]
                                then
                                        invert=$((power_draw_warn_min))
                                        power_draw_warn_min=$((power_draw_warn_max))
                                        power_draw_warn_max=$((invert))
                                fi
                                if [[ $power_draw_crit =~ $isnumber ]]
                                then
                                        power_draw_crit=$(($power_draw_crit * 100))
                                        if [ $((power_draw_crit)) -lt $((power_draw_warn_max)) ]
                                        then
                                                invert=$((power_draw_crit))
                                                power_draw_crit=$((power_draw_warn_max))
                                                power_draw_warn_max=$((invert))
                                        fi
                                        if [[ $power_draw =~ $isnumber ]]
                                        then

                                                if [ $((power_draw_crit)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 2 ]
                                                then
                                                        exit_code=2
                                                elif [ $((power_draw_warn_max)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                                then
                                                        exit_code=1
                                                elif [ $((power_draw_warn_min)) -gt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                                then
                                                        exit_code=1
                                                fi
                                        fi
                                        perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;$(echo "scale=2; ${power_draw_warn_min}/100" | bc ):$(echo "scale=2; ${power_draw_warn_max}/100" | bc );$(echo "scale=2; ${power_draw_crit}/100" | bc )"
                                else
                                        if [[ $power_draw =~ $isnumber ]]
                                        then
                                                if [ $((power_draw_warn_max)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                                then
                                                        exit_code=1
                                                elif [ $((power_draw_warn_min)) -gt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                                then
                                                        exit_code=1
                                                fi
                                        fi
                                        perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;$(echo "scale=2; ${power_draw_warn_min}/100" | bc ):$(echo "scale=2; ${power_draw_warn_max}/100" | bc )"
                                fi
                        else
                                if [[ $power_draw_crit =~ $isnumber ]]
                                then
                                        power_draw_crit=$(($power_draw_crit * 100))
                                        if [[ $power_draw =~ $isnumber ]]
                                        then
                                                if [ $((power_draw_crit)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 2 ]
                                                then
                                                        exit_code=2
                                                elif [ $((power_draw_warn_min)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                                then
                                                        exit_code=1
                                                fi
                                        fi
                                        perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;0:$(echo "scale=2; ${power_draw_warn}/100" | bc );$(echo "scale=2; ${power_draw_crit}/100" | bc )"
                                else
                                        if [[ $power_draw =~ $isnumber ]]
                                        then
                                                if [ $((power_draw_warn_min)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                                then
                                                        exit_code=1
                                                fi
                                        fi
                                        perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;0:$(echo "scale=2; ${power_draw_warn}/100" | bc )"
                                fi
                        fi
                else
                        if [[ $power_draw_warn_max =~ $isnumber ]]
                        then
                                power_draw_warn=$power_draw_warn_max
                        fi
                fi
        fi

        if [[ $power_draw_warn =~ $isnumber ]]
        then
                power_draw_warn=$(($power_draw_warn * 100))
                if [[ $power_draw_crit =~ $isnumber ]]
                then
                        power_draw_crit=$(($power_draw_crit * 100))
                        if [ $((power_draw_crit)) -lt $((power_draw_warn)) ]
                        then
                                invert=$((power_draw_crit))
                                power_draw_crit=$((power_draw_warn))
                                power_draw_warn=$((invert))
                        fi
                        if [[ $power_draw =~ $isnumber ]]
                        then
                                if [ $((power_draw_crit)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 2 ]
                                then
                                        exit_code=2
                                elif [ $((power_draw_warn)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                then
                                        exit_code=1
                                fi
                        fi
                        perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;$(echo "scale=2; ${power_draw_warn}/100" | bc );$(echo "scale=2; ${power_draw_crit}/100" | bc )"
                else
                        if [[ $power_draw =~ $isnumber ]]
                        then
                                if [ $((power_draw_warn)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 1 ]
                                then
                                        exit_code=1
                                fi
                        fi
                        perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;$(echo "scale=2; ${power_draw_warn}/100" | bc )"
                fi
        elif [[ $power_draw_crit =~ $isnumber ]] && [[ $power_draw_warn != *":"* ]]
        then
                power_draw_crit=$(($power_draw_crit * 100))
                if [[ $power_draw =~ $isnumber ]]
                then
                        if [ $((power_draw_crit)) -lt $((power_draw)) ] && [ $((exit_code)) -lt 2 ]
                        then
                                exit_code=2
                        fi
                fi
                perfdata="${perfdata} power_draw=$(echo "scale=2; ${power_draw}/100" | bc )Watts;;$(echo "scale=2; ${power_draw_crit}/100" | bc )"
        fi
fi

if [ $((exit_code)) -eq 0 ]
then
        echo "GPU OK: $serviceoutput | $perfdata"
elif [ $((exit_code)) -eq 1 ]
then
        echo "GPU WARNING: $serviceoutput | $perfdata"
elif [ $((exit_code)) -eq 2 ]
then
        echo "GPU CRITICAL: $serviceoutput | $perfdata"
else
        echo "GPU UNKNOWN: $serviceoutput | $perfdata"
fi
exit $exit_code

