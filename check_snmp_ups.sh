#!/bin/bash

# check_snmp_ups
# Description : Check Uninterruptible Power Supply (UPS)
# Version : 1.1
# Author : Yoann LAMY, Zottacko WallyMan
# Licence : GPLv2

# Commands
CMD_BASENAME="/usr/bin/basename"
CMD_SNMPGET="/usr/bin/snmpget"
CMD_SNMPWALK="/usr/bin/snmpwalk"
CMD_BC="/usr/bin/bc"
CMD_EXPR="/usr/bin/expr"

# Script name
SCRIPTNAME=`$CMD_BASENAME $0`

# Version
VERSION="1.1"

# Plugin return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

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

# Default variables
DESCRIPTION="Unknown"
STATE=$STATE_UNKNOWN
OUTPUTPOWER=0

# Default options
COMMUNITY="public"
HOSTNAME="127.0.0.1"
TYPE="battery"
WARNING=0
CRITICAL=0

# Option processing
print_usage() {
  echo "Usage: ./check_snmp_ups -H 127.0.0.1 -C public -t battery"
  echo "  $SCRIPTNAME -H ADDRESS"
  echo "  $SCRIPTNAME -C STRING"
  echo "  $SCRIPTNAME -t STRING"
  echo "  $SCRIPTNAME -w INTEGER"
  echo "  $SCRIPTNAME -c INTEGER"
  echo "  $SCRIPTNAME -h"
  echo "  $SCRIPTNAME -V"
}

print_version() {
  echo $SCRIPTNAME version $VERSION
  echo ""
  echo "This nagios plugins comes with ABSOLUTELY NO WARRANTY."
  echo "You may redistribute copies of the plugins under the terms of the GNU General Public License v2."
}

print_help() {
  print_version
  echo ""
  print_usage
  echo ""
  echo "Check Uninterruptible power supply (UPS)"
  echo ""
  echo "-H ADDRESS"
  echo "   Name or IP address of host (default: 127.0.0.1)"
  echo "-C STRING"
  echo "   Community name for the host's SNMP agent (default: public)"
  echo "-t STRING"
  echo "   Different status (battery, charge, power, source, temperature) (default: battery)"
  echo "-w INTEGER"
  echo "   Warning battery level in percent and UPS Warning temperature level in degres celsius (default: 0)"
  echo "-c INTEGER"
  echo "   Critical battery level in percent and UPS Critical temperature level in degres celsius (default: 0)"
  echo "-h"
  echo "   Print this help screen"
  echo "-V"
  echo "   Print version and license information"
  echo ""
  echo ""
  echo "This plugin uses the 'snmpget' command included with the NET-SNMP package."
}

while getopts H:C:t:w:c:hV OPT
do
  case $OPT in
    H) HOSTNAME="$OPTARG" ;;
    C) COMMUNITY="$OPTARG" ;;
    t) TYPE="$OPTARG" ;;
    w) WARNING="$OPTARG" ;;
    c) CRITICAL="$OPTARG" ;;
    h)
      print_help
      exit $STATE_UNKNOWN
      ;;
    V)
      print_version
      exit $STATE_UNKNOWN
      ;;
   esac
done

# Plugin processing
size_convert() {
  if [ $VALUE -ge 1000 ]; then
    VALUE=`echo "scale=2 ; $VALUE / 1000" | $CMD_BC`
    VALUE="$VALUE KWatt"
  else
    VALUE="$VALUE Watt"
  fi
}

if [ $TYPE = "battery" ]; then
  # Check battery status (Usage: ./check_snmp_ups -H 127.0.0.1 -C public -t battery)
  BATTERY=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME $upsBatteryStatus`
  DESCRIPTION="Battery status : "
  case $BATTERY in
    1)
      DESCRIPTION="$DESCRIPTION Unknown"
      STATE=$STATE_UNKNOWN
      ;;
    2)
      DESCRIPTION="$DESCRIPTION Battery level is ok"
      STATE=$STATE_OK
      ;;
    3)
      DESCRIPTION="$DESCRIPTION Low battery level"
      STATE=$STATE_WARNING
      ;;
    4)
      DESCRIPTION="$DESCRIPTION UPS Battery is Discharged"
      STATE=$STATE_CRITICAL
      ;;
    *)
      DESCRIPTION="$DESCRIPTION Unknown"
      STATE=$STATE_UNKNOWN
      ;;
  esac
elif [ $TYPE = "charge" ]; then
  # Check battery charge (Usage: ./check_snmp_ups -H 127.0.0.1 -C public -t charge -w 60 -c 30)
  CHARGE=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME $upsEstimatedChargeRemaining`

  if [ -n "$CHARGE" ]; then
    CHARGE_REMAINING=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME $upsEstimatedMinutesRemaining`
    if [ $WARNING != 0 ] || [ $CRITICAL != 0 ]; then
      if [ $CHARGE -lt $CRITICAL ] && [ $CRITICAL != 0 ]; then
        STATE=$STATE_CRITICAL
      elif [ $CHARGE -lt $WARNING ] && [ $WARNING != 0 ]; then
        STATE=$STATE_WARNING
      else
        STATE=$STATE_OK
      fi
    else
      STATE=$STATE_OK
    fi
    DESCRIPTION="Battery level : ${CHARGE}%. Remaining time : ${CHARGE_REMAINING} minutes | charge=$CHARGE;$WARNING:;$CRITICAL:;0"
  fi
elif [ $TYPE = "power" ]; then
  # Check output power (Usage: ./check_snmp_ups -H 127.0.0.1 -C public -t power -w 40000 -c 50000)
  for NUMBER in `$CMD_SNMPWALK -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME $upsOutputPower` 
  do
    if [ -n "$NUMBER" ]; then
      OUTPUTPOWER=`$CMD_EXPR $OUTPUTPOWER + $NUMBER`
    fi
  done

  if [ $WARNING != 0 ] || [ $CRITICAL != 0 ]; then
    if [ $OUTPUTPOWER -gt $CRITICAL ] && [ $CRITICAL != 0 ]; then
      STATE=$STATE_CRITICAL
    elif [ $OUTPUTPOWER -gt $WARNING ] && [ $WARNING != 0 ]; then
      STATE=$STATE_WARNING
    else
      STATE=$STATE_OK
    fi
  else
    if [ $OUTPUTPOWER != 0 ]; then
      STATE=$STATE_OK
    else
      STATE=$STATE_UNKNOWN
    fi
  fi

  VALUE=$OUTPUTPOWER
  size_convert
  OUTPUTPOWER_FORMAT=$VALUE

  DESCRIPTION="Output power : $OUTPUTPOWER_FORMAT | output_power=$OUTPUTPOWER;$WARNING;$CRITICAL"
elif [ $TYPE = "source" ]; then
  # Check output source (Usage: ./check_snmp_ups -H 127.0.0.1 -C public -t source)
  SOURCE=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME $upsOutputSource` 
  DESCRIPTION="Output source : "
  case $SOURCE in
    1)
      DESCRIPTION="$DESCRIPTION Unknown"
      STATE=$STATE_UNKNOWN
      ;;
    2)
      DESCRIPTION="$DESCRIPTION UPS circuit breaker is tripped"
      STATE=$STATE_CRITICAL
      ;;
    3)
      DESCRIPTION="$DESCRIPTION Output is filtered"
      STATE=$STATE_OK
      ;;
    4)
      DESCRIPTION="$DESCRIPTION UPS is in bypass mode"
      STATE=$STATE_CRITICAL
      ;;
    5)
      DESCRIPTION="$DESCRIPTION Power loss. UPS is in backup mode"
      STATE=$STATE_CRITICAL
      ;;
    6)
      DESCRIPTION="$DESCRIPTION Voltage regulator mode (booster)"
      STATE=$STATE_WARNING
      ;;
    7)
      DESCRIPTION="$DESCRIPTION Voltage regulator mode (reducer)"
      STATE=$STATE_WARNING
      ;;
    *)
      DESCRIPTION="$DESCRIPTION Unknown"
      STATE=$STATE_UNKNOWN
      ;;
  esac
elif [ $TYPE = "temperature" ]; then
  # Check temperature (Usage: ./check_snmp_ups -H 127.0.0.1 -C public -t temperature -w 25 -c 30)
  TEMPERATURE=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME $upsBatteryTemperature`

  if [ -n "$TEMPERATURE" ]; then
    if [ $WARNING != 0 ] || [ $CRITICAL != 0 ]; then
      if [ $TEMPERATURE -gt $CRITICAL ] && [ $CRITICAL != 0 ]; then
        STATE=$STATE_CRITICAL
      elif [ $TEMPERATURE -gt $WARNING ] && [ $WARNING != 0 ]; then
        STATE=$STATE_WARNING
      else
        STATE=$STATE_OK
      fi
    else
      STATE=$STATE_OK
    fi
    DESCRIPTION="Temperature : $TEMPERATURE Degree Celsius | temperature=$TEMPERATURE;$WARNING;$CRITICAL;0"
  fi

fi

echo $DESCRIPTION
exit $STATE
