#!/bin/sh
# @name: report_vufind.sh
# @version: 1.0
# @creation_date: Unknown
# @license: GNU General Public License version 3 (GPLv3) <https://www.gnu.org/licenses/gpl-3.0.en.html>
# @author: Scanbit <info.sca.ils@gmail.com>
#
# @purpose:
# This program will send a daily report to the email address specified
 
PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH

#df -k | mailx -s "Report size" againzarain@scanbit.net
#tail -100 /usr/local/vufind/harvest.log | mailx -s "Report log" againzarain@scanbit.net
#w  | mailx -s "CPU log" againzarain@scanbit.net

df -k | mailx -s "Report size" sb174@soas.ac.uk csbs@soas.ac.uk
tail -100 /usr/local/vufind/harvest.log | mailx -s "Report log" sb174@soas.ac.uk csbs@soas.ac.uk
w  | mailx -s "CPU log" sb174@soas.ac.uk csbs@soas.ac.uk

