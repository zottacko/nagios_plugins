#!/bin/bash

# Powerware MIBs
POWERWARE=".1.3.6.1.4.1.534.1"
xupsIdent="$POWERWARE.1"
xupsBattery="$POWERWARE.2"
xupsBatTimeRemaining="$xupsBattery.1.0"
xupsBatVoltage="$xupsBattery.2.0"
#xupsBatCurrent="$xupsBattery.3"
xupsBatCapacity="$xupsBattery.4.0"
xupsBatteryAbmStatus="$xupsBattery.5.0"
xupsBatteryLastReplacedDate="$xupsBattery.6.0"
xupsInput="$POWERWARE.3"
xupsInputFrequency="$xupsInput.1.0"
xupsInputLineBads="$xupsInput.2.0"
xupsInputNumPhases="$xupsInput.3.0"
xupsInputTable="$xupsInput.4.1"
xupsInputPhase="$xupsInputTable.1.1"
xupsInputVoltage="$xupsInputTable.2.1"
xupsInputCurrent="$xupsInputTable.3.1"
#xupsInputWatts="$xupsInputTable.4"
xupsInputSource="$xupsInput.5.0"
#xupsDualInputStatus="$xupsInput.6"
#xupsSecondaryInputWatch="$xupsInput.7"
xupsOutput="$POWERWARE.4"
xupsOutputLoad="$xupsOutput.1.0"
xupsOutputFrequency="$xupsOutput.2.0"
xupsOutputNumPhases="$xupsOutput.3.0"
xupsOutputTable="$xupsOutput.4.1"
xupsOutputPhase="$xupsOutputTable.1.1"
xupsOutputVoltage="$xupsOutputTable.2.1"
xupsOutputCurrent="$xupsOutputTable.3.1"
xupsOutputWatts="$xupsOutputTable.4.1"
xupsOutputSource="$xupsOutput.5.0"
#xupsBypass="$POWERWARE.5"
#xupsBypassFrequency="$xupsBypass.1"
#xupsBypassNumPhases="$xupsBypass.2"
#xupsBypassTable="$xupsBypass.3.1"
#xupsBypassPhase="$xupsBypassTable.1"
#xupsBypassVoltage="$xupsBypassTable.2"
xupsEnvironment="$POWERWARE.6"
xupsEnvAmbientTemp="$xupsEnvironment.1.0"
xupsEnvAmbientLowerLimit="$xupsEnvironment.2.0"
xupsEnvAmbientUpperLimit="$xupsEnvironment.3.0"
xupsEnvAmbientHumidity="$xupsEnvironment.4.0"
xupsAlarm="$POWERWARE.7"
xupsAlarms="$xupsAlarm.1.0"
xupsAlarmTable="$xupsAlarm.2.1"
xupsAlarmID="$xupsAlarmTable.1.16"
xupsAlarmDescr="$xupsAlarmTable.2.16"
xupsAlarmTime="$xupsAlarmTable.3.16"
xupsAlarmNumEvents="$xupsAlarm.18.0"
#xupsAlarmEventTable="$xupsAlarm.19.1"
#xupsAlarmEventID="$xupsAlarmEventTable.1"
#xupsAlarmEventDateAndTime="$xupsAlarmEventTable.2"
#xupsAlarmEventKind="$xupsAlarmEventTable.3"
#xupsAlarmEventDescr="$xupsAlarmEventTable.4"
#xupsAlarmEventMsg="$xupsAlarmEventTable.5"
xupsTest="$POWERWARE.8"
xupsControl="$POWERWARE.9"
xupsConfig="$POWERWARE.10"
xupsTrapControl="$POWERWARE.11"
xupsRecep="$POWERWARE.12"
xupsTopology="$POWERWARE.13"

status="$xupsAlarms"
load="$xupsOutputLoad"
bat_secs="$xupsBatTimeRemaining"
bat_perc="$xupsBatCapacity"

# RFC 1628
RFC1628=".1.3.6.1.2.1.33"
RFC1628_ID="$RFC1628.1.1"
upsIdentManufacturer="$RFC1628_ID.1.0"
upsIdentModel="$RFC1628_ID.2.0"
upsIdentUPSSoftwareVersion="$RFC1628_ID.3.0"
upsIdentAgentSoftwareVersion="$RFC1628_ID.4.0"
upsIdentName="$RFC1628_ID.5.0"
upsIdentAttachedDevices="$RFC1628_ID.6.0"
RFC1628_BATTERY="$RFC1628.1.2"
upsBatteryStatus="$RFC1628_BATTERY.1.0"
upsSecondsOnBatteryl="$RFC1628_BATTERY.2.0"
upsEstimatedMinutesRemaining="$RFC1628_BATTERY.3.0"
upsEstimatedChargeRemaining="$RFC1628_BATTERY.4.0"
upsBatteryVoltage="$RFC1628_BATTERY.5.0"
upsBatteryCurrent="$RFC1628_BATTERY.6.0"
upsBatteryTemperature="$RFC1628_BATTERY.7.0"
RFC1628_INPUT="$RFC1628.1.3"
upsInputLineBads="$RFC1628_INPUT.1.0"
upsInputNumLines="$RFC1628_INPUT.2.0"
upsInputLineIndex="$RFC1628_INPUT.3.1.1"
upsInputFrequency="$RFC1628_INPUT.3.1.2"
upsInputVoltage="$RFC1628_INPUT.3.1.3"
upsInputCurrent="$RFC1628_INPUT.3.1.4"
upsInputTruePower="$RFC1628_INPUT.3.1.5"
RFC1628_OUTPUT="$RFC1628.1.4"
upsOutputSource="$RFC1628_OUTPUT.1.0"
upsOutputFrequency="$RFC1628_OUTPUT.2.0"
upsOutputNumLines="$RFC1628_OUTPUT.3.0"
upsOutputLineIndex="$RFC1628_OUTPUT.4.1.1"
upsOutputVoltage="$RFC1628_OUTPUT.4.1.2"
upsOutputCurrent="$RFC1628_OUTPUT.4.1.3"
upsOutputPower="$RFC1628_OUTPUT.4.1.4"
upsOutputPercentLoad="$RFC1628_OUTPUT.4.1.5"
RFC1628_BYPASS="$RFC1628.1.5"
upsBypassFrequency="$RFC1628_BYPASS.1.0"
upsBypassNumLines="$RFC1628_BYPASS.2.0"
upsBypassLineIndex="$RFC1628_BYPASS.3.1.1"
upsBypassVoltage="$RFC1628_BYPASS.3.1.2"
upsBypassCurrent="$RFC1628_BYPASS.3.1.3"
upsBypassPower="$RFC1628_BYPASS.3.1.4"
RFC1628_ALARM="$RFC1628.1.6"
upsAlarmsPresent="$RFC1628_ALARM.1.0"
upsAlarmId="$RFC1628_ALARM.2.1.1"
upsAlarmDescr="$RFC1628_ALARM.2.1.2"
upsAlarmTime="$RFC1628_ALARM.2.1.3"
upsAlarmBatteryBad="$RFC1628_ALARM.3.1"
upsAlarmOnBattery="$RFC1628_ALARM.3.2"
upsAlarmLowBattery="$RFC1628_ALARM.3.3"
upsAlarmDepletedBattery="$RFC1628_ALARM.3.4"
upsAlarmTempBad="$RFC1628_ALARM.3.5"
upsAlarmInputBad="$RFC1628_ALARM.3.6"
upsAlarmOutputBad="$RFC1628_ALARM.3.7"
upsAlarmOutputOverload="$RFC1628_ALARM.3.8"
upsAlarmOnBypass="$RFC1628_ALARM.3.9"
upsAlarmBypassBad="$RFC1628_ALARM.3.10"
upsAlarmOutputOffAsRequested="$RFC1628_ALARM.3.11"
upsAlarmUpsOffAsRequested="$RFC1628_ALARM.3.12"
upsAlarmChargerFailed="$RFC1628_ALARM.3.13"
upsAlarmUpsOutputOff="$RFC1628_ALARM.3.14"
upsAlarmUpsSystemOff="$RFC1628_ALARM.3.15"
upsAlarmFanFailure="$RFC1628_ALARM.3.16"
upsAlarmFuseFailure="$RFC1628_ALARM.3.17"
upsAlarmGeneralFault="$RFC1628_ALARM.3.18"
upsAlarmDiagnosticTestFailed="$RFC1628_ALARM.3.19"
upsAlarmCommunicationsLost="$RFC1628_ALARM.3.20"
upsAlarmAwaitingPower="$RFC1628_ALARM.3.21"
upsAlarmShutdownPending="$RFC1628_ALARM.3.22"
upsAlarmShutdownImminent="$RFC1628_ALARM.3.23"
upsAlarmTestInProgress="$RFC1628_ALARM.3.24"
RFC1628_TEST="$RFC1628.1.7"
upsTestId="$RFC1628_TEST.1.0"
upsTestSpinLock="$RFC1628_TEST.2.0"
upsTestResultsSummary="$RFC1628_TEST.3.0"
upsTestResultsDetail="$RFC1628_TEST.4.0"
upsTestStartTime="$RFC1628_TEST.5.0"
upsTestElapsedTime="$RFC1628_TEST.6.0"
upsTestNoTestsInitiated="$RFC1628_TEST.7.1"
upsTestAbortTestInProgress="$RFC1628_TEST.7.2"
upsTestGeneralSystemsTest="$RFC1628_TEST.7.3"
upsTestQuickBatteryTest="$RFC1628_TEST.7.4"
upsTestDeepBatteryCalibration="$RFC1628_TEST.7.5"
RFC1628_CONTROL="$RFC1628.1.8"
upsShutdownType="$RFC1628_CONTROL.1.0"
upsShutdownAfterDelay="$RFC1628_CONTROL.2.0"
upsStartupAfterDelay="$RFC1628_CONTROL.3.0"
upsRebootWithDuration="$RFC1628_CONTROL.4.0"
upsAutoRestart="$RFC1628_CONTROL.5.0"
RFC1628_CONF="$RFC1628.1.9"
upsConfigInputVoltage="$RFC1628_CONF.1.0"
upsConfigInputFreq="$RFC1628_CONF.2.0"
upsConfigOutputVoltage="$RFC1628_CONF.3.0"
upsConfigOutputFreq="$RFC1628_CONF.4.0"
upsConfigOutputVA="$RFC1628_CONF.5.0"
upsConfigOutputPower="$RFC1628_CONF.6.0"
upsConfigLowBattTime="$RFC1628_CONF.7.0"
upsConfigAudibleStatus="$RFC1628_CONF.8.0"
upsConfigLowVoltageTransferPoint="$RFC1628_CONF.9.0"

function get_data () {
	if [[ $version -ne 3 ]] 
	then
		res=$(snmpget -v $version -c $commun $host $mib -Oqv) 
		if [[ $? -ne 0 ]]  
		then
				echo "Snmpget failed" 
				exit 2 
		fi
	else
		res=$(snmpget -v $version -l $level -u $user -a $authprot -A $authpass -x $privprot -X $privpass $host $mib -Oqv) 
		if [[ $? -ne 0 ]]  
		then
				echo "Snmpget failed" 
				exit 2 
		fi 
	fi 
}
#
while getopts "h:o:c:v:l:u:a:A:x:X:W:C:" opt
do
	case $opt in
		h) host=$OPTARG 
		;;
		c) commun=$OPTARG 
		;;
		o) type=$OPTARG
		;;
		v) version=$OPTARG
		;;
		l) level=$OPTARG
		;;
		u) user=$OPTARG
		;;
		a) authprot=$OPTARG
		;;
		A) authpass=$OPTARG
		;;
		x) privprot=$OPTARG
		;;
		X) privpass=$OPTARG
		;;
		W) warn=$OPTARG
		;;
		C) crit=$OPTARG
		;;
		*) echo "No reasonable options found!"
		;;
	esac
done
#
case $type in
	upsstatus) mib=$status 
		get_data 
		if [[ $res -ne 0 ]] 
	       	then
			echo "CRITICAL - $(($res))|ups_status=$(($res));0;0" 
			exit 2 
		else 
			echo "OK - $(($res))|ups_status=$(($res));0;0" 
       			exit 0 
		fi
	;;
	upsload) mib=$load 
		get_data 
		res=$(($res/10)) 
		if [[ $res -ge $crit ]] 
		then
			echo "CRITICAL - $(($res))%|ups_load=$(($res));$(($warn));$(($crit))" 
			exit 2 
		elif [[ $res -le $crit && $res -ge $warn || $res -eq 0 ]]  
		then
			echo "WARNING - $(($res))%|ups_load=$(($res));$(($warn));$(($crit))" 
			exit 1 
		else
			echo "OK - $(($res))%|ups_load=$(($res));$(($warn));$(($crit))" 
			exit 0 
		fi
	;;
	upsbatperc) mib=$bat_perc 
		get_data 
		if [[ $res -le $crit ]] 
		then
			echo "CRITICAL - $(($res))%|ups_batperc=$(($res));$(($warn)):;$(($crit)):" 
			exit 2 
		elif [[ $res -ge $crit && $res -le $warn ]]  
		then
			echo "WARNING - $(($res))%|ups_batperc=$(($res));$(($warn)):;$(($crit)):" 
			exit 1 
		else
			echo "OK - $(($res))%|ups_batperc=$(($res));$(($warn)):;$(($crit)):" 
			exit 0 
		fi
	;;
	upsbatmins) mib=$bat_secs 
		get_data 
		res=$(($res/60))
		if [[ $res -le $crit ]]  
		then
			echo "CRITICAL - $(($res)) min|ups_batmins=$(($res));$(($warn)):;$(($crit)):" 
			exit 2 
		elif [[ $res -ge $crit && $res -le $warn ]] 
		then
			echo "WARNING - $(($res)) min|ups_batmins=$(($res));$(($warn)):;$(($crit)):" 
			exit 1 
		else 
			echo "OK - $(($res)) min|ups_batmins=$(($res));$(($warn)):;$(($crit)):" 
			exit 0 
		fi
	;;
	*) echo "Wrong type" 
		exit 2 
		;;
esac

