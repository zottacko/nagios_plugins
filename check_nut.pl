#! /usr/bin/perl -w


use strict;
use Getopt::Long;
use vars qw($opt_V $opt_h $opt_d $PROGNAME $UPSC $ret $str $opt_d $opt_bw $opt_bc $opt_tw $opt_tc $opt_lw $opt_lc @lines $line $bCharge $bRuntime $brWarn $brCrit $bVoltage $bvWarn $bvCrit $uTemp $uLoad $uStatus $uModel $iVoltage $ivWarn $ivCrit $iFreq $ifWarn $ifCrit $lWarn $lCrit $tWarn $tCrit);
use lib "/usr/lib/nagios/plugins" ;
use utils qw(%ERRORS &print_revision &support &usage);

$PROGNAME = "check_nut";
$UPSC = "/bin/upsc";

$brWarn = "300:";
$brCrit = "180:";

$bvWarn = "12:";
$bvCrit = "11:";

$ivWarn = "110:130";
$ivCrit = "100:140";

$ifWarn = "59.8:60.2";
$ifCrit = "59.5:60.5";

sub print_help ();
sub print_usage ();

$ENV{'PATH'}='';
$ENV{'BASH_ENV'}='';
$ENV{'ENV'}='';

Getopt::Long::Configure('bundling');
GetOptions
        ("V"    => \$opt_V,  "version"        => \$opt_V,
         "d=s"  => \$opt_d,  "device=s"       => \$opt_d,
         "w=s"  => \$opt_bw, "battWarning=s"  => \$opt_bw,
         "c=s"  => \$opt_bc, "battCritical=s" => \$opt_bc,
         "t=s"  => \$opt_tw, "tempWarning=s"  => \$opt_tw,
         "T=s"  => \$opt_tc, "tempCritical=s" => \$opt_tc,
         "l=s"  => \$opt_lw, "loadWarning=s"  => \$opt_lw,
         "L=s"  => \$opt_lc, "loadCritical=s" => \$opt_lc,
         "h"    => \$opt_h,  "help"           => \$opt_h);

if ($opt_V) {
        print_revision($PROGNAME,'$Revision: 1.0 $');
        exit $ERRORS{'OK'};
}

if ($opt_h) {print_help(); exit $ERRORS{'OK'};}

($opt_d) || ($opt_d = shift) || usage("Device not specified\n");
($opt_bw) || ($opt_bw = shift) || usage("Battery charge warning threshold not specified\n");
my $bWarn = $1 if ($opt_bw =~ /^([0-9]{1,2}?|100?)$/);
($bWarn) || usage("Invalid battery charge warning threshold: $opt_bw\n");
($opt_bc) || ($opt_bc = shift) || usage("Battery charge critical threshold not specified\n");
my $bCrit = $1 if ($opt_bc =~ /^([0-9]{1,2}?|100?)$/);
($bCrit) || usage("Invalid battery charge critical threshold: $opt_bc\n");
($opt_tw) || ($opt_tw = shift) || ($opt_tw = '');
if($opt_tw ne '')
{
  $tWarn = $1 if ($opt_tw =~ /^([0-9]{1,2})(\.[0-9]{1,2})?$/);
  ($tWarn) || usage("Invalid temperature warning threshold: $opt_tw\n");
}
else
{
  $tWarn = 0;
}
($opt_tc) || ($opt_tc = shift) || ($opt_tc = '');
if($opt_tc ne '')
{
  $tCrit = $1 if ($opt_tc =~ /^([0-9]{1,2})(\.[0-9]{1,2})?$/);
  ($tCrit) || usage("Invalid temperature critical threshold: $opt_tc\n");
}
else
{
  $tCrit = 0;
}
($opt_lw) || ($opt_lw = shift) || ($opt_lw = '');
if($opt_lw ne '')
{
  $lWarn = $1 if ($opt_lw =~ /^([0-9]{1,2})(\.[0-9]{1,2})?$/);
  ($lWarn) || usage("Invalid load warning threshold: $opt_lw\n");
}
else
{
  $lWarn = 0;
}
($opt_lc) || ($opt_lc = shift) || ($opt_lc = '');
if($opt_lc ne '')
{
  $lCrit = $1 if ($opt_lc =~ /^([0-9]{1,2})(\.[0-9]{1,2})?$/);
  ($lCrit) || usage("Invalid load critical threshold: $opt_lc\n");
}
else
{
  $lCrit = 0;
}

$str = `/bin/ps axuwf | /bin/grep "/upsd\$" | /bin/grep -v grep`;
$ret = $?;

if($ret == 0)
{
  @lines = `$UPSC $opt_d`;
  $bCharge = 0;
  $bRuntime = 0;
  $bVoltage = 0;
  $uTemp = 0;
  $uLoad = 0;
  $uStatus = 0;
  $uModel = '';
  $iVoltage = 0;
  $iFreq = 0;

  foreach $line (@lines)
  {
    $line =~ s/[\n\r]//g;
    $bCharge  = substr($line, 16) if($line =~ /^battery\.charge\:/);
    $bRuntime = substr($line, 17) if($line =~ /^battery\.runtime\:/);
    $bVoltage = substr($line, 17) if($line =~ /^battery\.voltage\:/);
    $uTemp    = substr($line, 17) if($line =~ /^ups\.temperature\:/);
    $uLoad    = substr($line, 10) if($line =~ /^ups\.load\:/);
    $uStatus  = substr($line, 12) if($line =~ /^ups\.status\:/);
    $uModel   = substr($line, 11) if($line =~ /^ups\.model\:/);
    $iVoltage = substr($line, 15) if($line =~ /^input\.voltage\:/);
    $iFreq    = substr($line, 17) if($line =~ /^input\.frequency\:/);
  }
  $ret = 0;
  if($bCharge < $bWarn && $bCharge >= $bCrit && $bWarn ne '')
  {
    $ret = 1;
    print "$opt_d WARNING: Battery Charge! ";
  }
  if($bCharge < $bCrit && $bCrit ne '')
  {
    $ret = 2;
    print "$opt_d CRITICAL: Battery Charge! ";
  }
  if($uTemp > $tWarn && $uTemp <= $tCrit && $tWarn != 0)
  {
    $ret = 1;
    print "$opt_d WARNING: Temperature $uTemp°C ";
  }
  if($uTemp > $tCrit && $tCrit != 0)
  {
    $ret = 2;
    print "$opt_d CRITICAL: Temperature $uTemp°C ";
  }
  if($uLoad > $lWarn && $uLoad <= $lCrit && $lWarn != 0)
  {
    $ret = 1;
    print "$opt_d WARNING: Load $uLoad ";
  }
  if($uLoad > $lCrit && $lCrit != 0)
  {
    $ret = 2;
    print "$opt_d CRITICAL: Load $uLoad ";
  }
  if($uStatus ne 'OL')
  {
    $ret = 1;
    print "$opt_d WARNING: Status $uStatus ";
  }
  if($ret == 0)
  {
          #    print "UPS $opt_d ($uModel) OK: battery charge: $bCharge, temperature: $uTemp, load: $uLoad\n";
          print "$opt_d OK:";
  }
}
else
{
  print "NUT Daemon DOWN\n";
  $ret = 3;
}

print "Battery $bCharge";
print "%,$bRuntime";
print "s,$bVoltage";
print "V; Input $iVoltage";
print "V,$iFreq";
print "Hz|";
print "Battery_Charge=$bCharge";
print "%;$bWarn;$bCrit ";
print "Battery_Runtime=$bRuntime";
print "s;$brWarn;$brCrit ";
print "Battery_Voltage=$bVoltage";
print "V;$bvWarn;$bvCrit ";
print "Input_Voltage=$iVoltage";
print "V;$ivWarn;$ivCrit ";
print "Input_Frequency=$iFreq";
print "Hz;$ifWarn;$ifCrit ";

exit $ERRORS{'UNKNOWN'} if ($ret == 3);
exit $ERRORS{'CRITICAL'} if ($ret == 2);
exit $ERRORS{'WARNING'} if ($ret == 1);
exit $ERRORS{'OK'};


sub print_usage () {
        print "Usage:\n$PROGNAME -d <device> -w <battery charge warning> -c <battery charge critical> -t <temperature warning> -T <temperature critical> -l <ups load warning> -L <ups load critical>\n\n";
}

sub print_help () {
        print_revision($PROGNAME,'$Revision: 1.0 $');
        print "Copyright (c) 2007 Luca Bertoncello <lucabert\@lucabert.de>

This plugin reports the status of the UPS using NUT

";
        print_usage();
        support();
}

