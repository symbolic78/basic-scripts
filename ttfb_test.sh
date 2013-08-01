#!/bin/bash
# Simple script to measure some network diagnostics of a number
# of urls
#
# RMC - 28/05/2012

CITY_URLS="/ /courses /courses/postgraduate /courses/undergraduate /courses/short-courses /international/international-students /study/why-study-at-city/accommodation /visit /law /study/why-study-at-city/accommodation/halls-of-residence"
CASS_URLS="/ /courses/masters /intranet/student /courses/mba /courses/masters/apply /courses/mba/full-time-mba /intranet/staff /intranet/student/learning-resource-centre /courses/masters/courses/management"

for url in $CITY_URLS 
do
   for (( c=1; c<=5; c++ ))
   do
      echo "##########"
      echo "TESTING URL TIME $c http://www.test.city.ac.uk$url"
      echo "#########"
      curl -o /dev/null -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n" http://www.test.city.ac.uk$url
      echo "##########"
      echo " "
   done
done

for url in $CASS_URLS
do
   for (( c=1; c<=5; c++ ))
   do
      echo "##########"
      echo "TESTING URL TIME $c http://www.test.cass.city.ac.uk$url"
      echo "#########"
      curl -o /dev/null -w "Connect: %{time_connect} TTFB: %{time_starttransfer} Total time: %{time_total} \n" http://www.test.cass.city.ac.uk$url
      echo "##########"
      echo " "
   done
done

exit 0
