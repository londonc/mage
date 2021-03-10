#!/bin/bash
# LMC

# Set ANSI color output
red='\e[31m'
green='\e[32m'
yellow='\e[1;33m'
reset='\e[0m'

# Don't leave some .sh file in your document root just in case.
mageRoot=/var/www/html

# Final output for support
logCombined=~/sa_output.txt

sysctl -a >$logCombined
vmstat 1 10 >>$logCombined
mysql -e "show global status" >>$logCombined
mysql -e "show global variables" >>$logCombined
netstat -nap >>$logCombined
iostat -dx >>$logCombined
dmesg >>$logCombined
free -m >>$logCombined
uptime >>$logCombined

# Cron
logCron=~/sa_cron.txt
crontab -l >$logCron
if [[ $(cat $logCron| grep "magento cron:run") ]]; then echo -e "${green}Magento cron found.${reset}"; else echo -e "${red}Magento cron job not found! Strongly recommend fixing.${reset}"; fi
## Create header and combine
echo "### CRON ###" >> $logCombined
cat $logCron >> $logCombined
rm -f $logCron

# PHP
logPHP=~/sa_php_modules.txt
php -v >$logPHP
## TODO version check
php -m >>$logPHP
if [[ $(cat $logPHP | grep "OPcache") ]]; then echo -e "${green}OPcache found.${reset}"; else echo "${red}OPcache not found! Strongly recommend fixing.${reset}"; fi
php -i >>$logPHP
## Create header and combine
echo "### PHP ###" >> $logCombined
cat $logPHP >> $logCombined
rm -f $logPHP

# Magento 
cd $mageRoot
ls -latr app app/etc var >>$logCombined
