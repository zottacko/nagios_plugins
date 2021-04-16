#!/bin/bash

# snmpwalk -v 3 -l authPriv -u Liebert -a SHA -A VertivGXT3 -x DES -X VertivGXT3 -m LIEBERT-GP-AGENT-MIB:LIEBERT-GP-CONDITIONS-MIB:LIEBERT-GP-ENVIRONMENTAL-MIB:LIEBERT-GP-POWER-MIB:LIEBERT-GP-SYSTEM-MIB:RFC1213-MIB:SNMP-FRAMEWORK-MIB:SNMP-MPD-MIB:SNMP-NOTIFICATION-MIB:SNMP-TARGET-MIB:SNMP-USER-BASED-SM-MIB:SNMPv2-MIB:SNMP-VIEW-BASED-ACM-MIB:UPS-MIB:USM-TARGET-TAG-MIB 148.204.110.36 .1

# Liebert MIBs

LIEBERT=".1.3.6.1.4.1.476.1.42"
lgpModuleReg="$LIEBERT.1"
lgpAgent="$LIEBERT.2"
lgpAgentIdent="$lgpAgent.1"
lgpAgentNotifications="$lgpAgent.2"
lgpAgentDevice="$lgpAgent.3"
lgpAgentControl="$lgpAgent.4"
lgpFoundation="$LIEBERT.3"
lgpConditions="$lgpFoundation.2"
lgpConditionsPresent="$lgpConditions.2.0"
lgpNotifications="$lgpFoundation.3"
lgpEnvironmental="$lgpFoundation.4"
lgpEnvTemperatureEntryDegC="$lgpEnvironmental.1.3.3.1"
lgpEnvTemperatureMeasurementDegC="$lgpEnvTemperatureEntryDegC.3.1"
lgpPower="$lgpFoundation.5"
lgpPwrBattery="$lgpPower.1"
lgpPwrConfigLowBatteryWarningTime="$lgpPwrBattery.5.0"
lgpPwrBatteryTestResult="$lgpPwrBattery.8.0"
lgpPwrNominalBatteryCapacity="$lgpPwrBattery.9.0"
lgpPwrBatteryFloatVoltage="$lgpPwrBattery.10.0"
lgpPwrBatteryChargeStatus="$lgpPwrBattery.14.0"
lgpPwrBatteryCharger="$lgpPwrBattery.16.0"
lgpPwrBatteryTimeRemaining="$lgpPwrBattery.18.0"
lgpPwrBatteryCapacity="$lgpPwrBattery.19.0"
lgpPwrBatteryCabinet="$lgpPwrBattery.20"
lgpPwrBatteryCabinetCount="$lgpPwrBatteryCabinet.1.0"
lgpPwrBatteryCabinetType="$lgpPwrBatteryCabinet.2.0"
lgpPwrBatteryCabinetRatedCapacity="$lgpPwrBatteryCabinet.3.0"
lgpPwrMeasurements="$lgpPower.2"
lgpPwrMeasurementPointTable="$lgpPwrMeasurements.2.1"
lgpPwrMeasurementPointId1="$lgpPwrMeasurementPointTable.2.1"
lgpPwrMeasurementPointNumLines1="$lgpPwrMeasurementPointTable.3.1"
lgpPwrMeasurementPointNomVolts1="$lgpPwrMeasurementPointTable.4.1"
lgpPwrMeasurementPointNomFrequency1="$lgpPwrMeasurementPointTable.5.1"
lgpPwrMeasurementPointFrequency1="$lgpPwrMeasurementPointTable.6.1"
lgpPwrMeasurementPointNomCurrent1="$lgpPwrMeasurementPointTable.14.1"
lgpPwrMeasurementPointId2="$lgpPwrMeasurementPointTable.2.2"
lgpPwrMeasurementPointNumLines2="$lgpPwrMeasurementPointTable.3.2"
lgpPwrMeasurementPointNomVolts2="$lgpPwrMeasurementPointTable.4.2"
lgpPwrMeasurementPointFrequency2="$lgpPwrMeasurementPointTable.6.2"
lgpPwrMeasurementPointId3="$lgpPwrMeasurementPointTable.2.3"
lgpPwrMeasurementPointNumLines3="$lgpPwrMeasurementPointTable.3.3"
lgpPwrMeasurementPointNomVolts3="$lgpPwrMeasurementPointTable.4.3"
lgpPwrMeasurementPointNomFrequency3="$lgpPwrMeasurementPointTable.5.3"
lgpPwrMeasurementPointFrequency3="$lgpPwrMeasurementPointTable.6.3"
lgpPwrMeasurementPointApparentPower3="$lgpPwrMeasurementPointTable.7.3"
lgpPwrMeasurementPointTruePower3="$lgpPwrMeasurementPointTable.8.3"
lgpPwrMeasurementPointVAPercent3="$lgpPwrMeasurementPointTable.11.3"
lgpPwrMeasurementPointNomPowerFactor3="$lgpPwrMeasurementPointTable.15.3"
lgpPwrMeasurementPointNomVA3="$lgpPwrMeasurementPointTable.16.3"
lgpPwrLineMeasurementTable="$lgpPwrMeasurements.3.1"
lgpPwrMeasurementPoint1="$lgpPwrLineMeasurementTable.3.1.1"
lgpPwrLineMeasurementCurrent1="$lgpPwrLineMeasurementTable.6.1.1"
lgpPwrLineMeasurementMaxVolts1="$lgpPwrLineMeasurementTable.16.1.1"
lgpPwrLineMeasurementMinVolts1="$lgpPwrLineMeasurementTable.17.1.1"
lgpPwrLineMeasurementVolts1="$lgpPwrLineMeasurementTable.20.1.1"
lgpPwrMeasurementPoint2="$lgpPwrLineMeasurementTable.3.2.1"
lgpPwrLineMeasurementCurrent2="$lgpPwrLineMeasurementTable.6.2.1"
lgpPwrLineMeasurementVolts2="$lgpPwrLineMeasurementTable.20.2.1"
lgpPwrMeasurementPoint3="$lgpPwrLineMeasurementTable.3.3.1"
lgpPwrLineMeasurementCurrent3="$lgpPwrLineMeasurementTable.6.3.1"
lgpPwrLineMeasurementMaxVolts3="$lgpPwrLineMeasurementTable.16.3.1"
lgpPwrLineMeasurementMinVolts3="$lgpPwrLineMeasurementTable.17.3.1"
lgpPwrLineMeasurementVolts3="$lgpPwrLineMeasurementTable.20.3.1"
lgpPwrDcMeasurementPointTable="$lgpPwrMeasurements.4.1"
lgpPwrDcMeasurementPointId="$lgpPwrDcMeasurementPointTable.2.1"
lgpPwrDcMeasurementPointSubID="$lgpPwrDcMeasurementPointTable.3.1"
lgpPwrDcMeasurementPointVolts="$lgpPwrDcMeasurementPointTable.4.1"
lgpPwrDcMeasurementPointNomVolts="$lgpPwrDcMeasurementPointTable.6.1"
lgpPwrStatus="$lgpPower.3"
lgpPwrDcToDcConverter="$lgpPwrStatus.6.0"
lgpPwrOutputToLoadOnInverter="$lgpPwrStatus.7.0"
lgpPwrInverterReady="$lgpPwrStatus.9.0"
lgpPwrOutputToLoadOnBypass="$lgpPwrStatus.10.0"
lgpPwrShutdownOverTemperature="$lgpPwrStatus.13.0"
lgpPwrShutdownOverload="$lgpPwrStatus.14.0"
lgpPwrShutdownDcBusOverload="$lgpPwrStatus.15.0"
lgpPwrShutdownOutputShort="$lgpPwrStatus.16.0"
lgpPwrShutdownLineSwap="$lgpPwrStatus.17.0"
lgpPwrShutdownLowBattery="$lgpPwrStatus.18.0"
lgpPwrShutdownRemote="$lgpPwrStatus.19.0"
lgpPwrShutdownInputUnderVoltage="$lgpPwrStatus.20.0"
lgpPwrShutdownPowerFactorCorrectionFailure="$lgpPwrStatus.21.0"
lgpPwrShutdownHardware="$lgpPwrStatus.22.0"
lgpPwrPowerFactorCorrection="$lgpPwrStatus.27.0"
lgpPwrSettings="$lgpPower.4"
lgpPwrConversion="$lgpPower.5"
lgpPwrControl="$lgpPower.6"
lgpPwrTopology="$lgpPower.7"
lgpPwrStatistic="$lgpPower.8"
lgpPwrConfig="$lgpPower.9"
lgpController="$lgpFoundation.6"
lgpSystem="$lgpFoundation.7"
lgpPdu="$lgpFoundation.8"
lgpFlexible="$lgpFoundation.9"
lgpSrc="$lgpFoundation.10"
lgpProductSpecific="$LIEBERT.4"

status="$lgpConditionsPresent"
bat_mins="$lgpPwrBatteryTimeRemaining"
bat_perc="$lgpPwrBatteryCapacity"
load="$lgpPwrMeasurementPointVAPercent3"

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
	upsbatmins) mib=$bat_mins 
		get_data 
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

