#!/bin/bash

#file check or add
if [ -d /root/2020Q1 ]; then
        echo "file check ok"
else
        mkdir /root/2020Q1
        echo -e 新增资料夹/root/2020Q1
fi

case ${1} in
    "pay") #選擇執行支付
     rm -rf /root/2020Q1/2020_q1_pay_report.txt
     cat /root/2020Q1/rp_servername.txt | grep pay > /root/2020Q1/rp_servername_pay.txt

IFS='-'
while read brand item domain old
  do
    echo $brand >> /root/2020Q1/2020_q1_pay_report.txt
    echo $domain >> /root/2020Q1/2020_q1_pay_report.txt
    curl -Lk -m 3 --retry 3 http://$domain:30000/respPayWeb/YOUCHUANGZHIFU2_BANK_WAP_ZFB_SM/ | grep 'ERROR'
    if [ $? -ne 0 ]; then
      echo "test 1 $brand $domain error, /respPayWeb/YOUCHUANGZHIFU2_BANK_WAP_ZFB_SM/ should show 'ERROR'" >>/root/2020Q1/2020_q1_pay_report.txt
      #curl -Lk -m 3 --retry 3 http://$domain:30000/respPayWeb/YOUCHUANGZHIFU2_BANK_WAP_ZFB_SM/  >> /root/2020Q1/2020_q1_pay_report.txt
    fi
    curl -Lk -m 3 --retry 3 http://$domain:30000/info | grep 'commit'
    if [ $? -ne 0 ]; then
      echo "test 2 $brand $domain error, /info should show 'commit'" >>/root/2020Q1/2020_q1_pay_report.txt
      #curl -Lk -m 3 --retry 3 http://$domain:30000/info  >> /root/2020Q1/2020_q1_pay_report.txt
    fi
    echo ==================== >> /root/2020Q1/2020_q1_pay_report.txt
  done < "/root/2020Q1/rp_servername_pay.txt"

#echo 測試report error數量
echo -e "\033[43m_ERROR_量數:\033[0m" >> /root/2020Q1/2020_q1_pay_report.txt
cat /root/2020Q1/2020_q1_pay_report.txt | grep 'error' |wc -l >> /root/2020Q1/2020_q1_pay_report.txt

rm -rf /root/2020Q1/rp_servername_pay.txt
    ;;

    "app") #選擇執行app
    rm -rf /root/2020Q1/2020_q1_app_report.txt
    cat /root/2020Q1/rp_servername.txt | grep app > /root/2020Q1/rp_servername_app.txt
IFS='-'
while read brand item domain old
  do
    echo $brand >> /root/2020Q1/2020_q1_app_report.txt
    echo $domain >> /root/2020Q1/2020_q1_app_report.txt
    curl -I -Lk -m 3 --retry 3 $domain:10000/statics/sys/index.html | grep '404 Not Found'
    if [ $? -ne 0 ]; then
      echo "$brand $domain 1testerror /statics/sys/index.html should show '404 Not Found'" >> /root/2020Q1/2020_q1_app_report.txt
      #curl -I -Lk -m 3 --retry 3 $domain:10000/statics/sys/index.html | grep '404 Not Found' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -Lk -m 3 --retry 3 $domain:10000/apis/preferentialActive/findByCondition | grep '400'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 2testerror /apis/preferentialActive/findByCondition should show '400'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -Lk -m 3 --retry 3 $domain:10000/apis/preferentialActive/findByCondition | grep '400' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -Lk -m 3 --retry 3 $domain:10000/apis/healthCheck | grep 'passed'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 3testerror /apis/healthCheck should show 'passed'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -Lk -m 3 --retry 3 $domain:10000/apis/healthCheck | grep 'passed' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -Lk -m 3 --retry 3 $domain:10000/apis/info | grep 'commit'
    if [ $? -ne 0 ]; then
      echo "$brand $domain 4testerror /apis/info should show 'commit'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -Lk -m 3 --retry 3 $domain:10000/apis/info | grep 'commit'  >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -I -Lk -m 3 --retry 3 $domain:10000/app/event/index.html | grep '200 OK'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 5testerror /app/event/index.html should show '200 OK'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -I -Lk -m 3 --retry 3 $domain:10000/app/event/index.html | grep '200 OK' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -I -Lk -m 3 --retry 3 $domain:10000/statics/info | grep '404 Not Found'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 6testerror should show '404 Not Found'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -I -Lk -m 3 --retry 3 $domain:10000/statics/info | grep '404 Not Found' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -I -Lk -m 3 --retry 3 $domain:10000/app/info | grep '404 Not Found'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 7testerror /app/info should show '404 Not Found'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -I -Lk -m 3 --retry 3 $domain:10000/app/info | grep '404 Not Found' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -I -Lk -m 3 --retry 3 $domain:10000/fb/info | grep '404 Not Found'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 8testerror /fb/info should show '404 Not Found'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -I -Lk -m 3 --retry 3 $domain:10000/fb/info | grep '404 Not Found' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    curl -I -Lk -m 3 --retry 3 $domain:10000/aide/info | grep '200'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 9testerror /aide/info should show '200'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -I -Lk -m 3 --retry 3 $domain:10000/aide/info | grep '200' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    #echo ==================== >> /root/2020Q1/2020_q1_app_report.txt

    curl -Lk -m 3 --retry 3 $domain:10000/cp/info | grep 'message'
    if [ $? -ne 0 ]; then
      echo " $brand $domain 10testerror /cp/info should show 'message'" >>/root/2020Q1/2020_q1_app_report.txt
      #curl -Lk -m 3 --retry 3 $domain:10000/cp/info | grep 'message' >> /root/2020Q1/2020_q1_app_report.txt
    fi
    echo ==================== >> /root/2020Q1/2020_q1_app_report.txt

done < "/root/2020Q1/rp_servername_app.txt"

echo -e "\033[43m_ERROR_量數:\033[0m" >> /root/2020Q1/2020_q1_app_report.txt
cat /root/2020Q1/2020_q1_app_report.txt | grep testerror |wc -l 
cat /root/2020Q1/2020_q1_app_report.txt | grep testerror |wc -l >> /root/2020Q1/2020_q1_app_report.txt
rm -rf /root/2020Q1/rp_servername_app.txt
    ;;

   "fe") #選擇執行前台
    rm -rf /root/2020Q1/2020_q1_fe_report.txt
    cat /root/2020Q1/rp_servername.txt | grep fend > /root/2020Q1/rp_servername_fe.txt
IFS='-'
while read brand item domain old
  do
    echo $brand >> /root/2020Q1/2020_q1_fe_report.txt
    echo $domain >> /root/2020Q1/2020_q1_fe_report.txt
    #測試項目
        curl -Lk -m  3 --retry 3 https://$domain/apis/preferentialActive/findByCondition | grep '400'
    if [ $? -ne 0 ]; then
      echo "$brand $domain error, /apis/preferentialActive/findByCondition should show '400'" >>/root/2020Q1/2020_q1_fe_report.txt
      #curl -Lk -m  3 --retry 3 https://$domain/apis/preferentialActive/findByCondition | grep '400'   >> /root/2020Q1/2020_q1_fe_report.txt
    fi    
	curl -Lk -m  3 --retry 3 https://$domain/apis/healthCheck | grep 'passed'
    if [ $? -ne 0 ]; then
      echo "$brand $domain error, /apis/healthCheck should show 'passed'" >>/root/2020Q1/2020_q1_fe_report.txt
      #curl -Lk -m  3 --retry 3 https://$domain/apis/healthCheck | grep 'passed'  >> /root/2020Q1/2020_q1_fe_report.txt
    fi   
	curl -Lk -m  3 --retry 3 https://$domain/aide/promotion/gerUrl | grep '200'
    if [ $? -ne 0 ]; then
      echo "$brand $domain error, /aide/promotion/gerUrl should show '200' " >>/root/2020Q1/2020_q1_fe_report.txt
      #curl -Lk -m  3 --retry 3 https://$domain/aide/promotion/gerUrl | grep '200'  >> /root/2020Q1/2020_q1_fe_report.txt
    fi    
	curl -Lk -m  3 --retry 3 https://$domain/aide/info | grep 'commit'
    if [ $? -ne 0 ]; then
      echo "$brand $domain error, /aide/info should show 'commit'" >>/root/2020Q1/2020_q1_fe_report.txt
      #curl -Lk -m  3 --retry 3 https://$domain/aide/info | grep 'commit'  >> /root/2020Q1/2020_q1_fe_report.txt
    fi    
	curl -Lk -m  3 --retry 3 https://$domain/apis/login | grep '400'
    if [ $? -ne 0 ]; then
      echo "$brand $domain error, /apis/login should show '400'" >>/root/2020Q1/2020_q1_fe_report.txt
      #curl -Lk -m  3 --retry 3 https://$domain/apis/login | grep '400'  >> /root/2020Q1/2020_q1_fe_report.txt
    fi    
	curl -I -Lk -m  3 --retry 3 https://$domain/home | grep '200'
    if [ $? -ne 0 ]; then
      echo "$brand $domain error, /home should show '200'" >>/root/2020Q1/2020_q1_fe_report.txt
      #curl -I -Lk -m  3 --retry 3 https://$domain/home | grep '200'  >> /root/2020Q1/2020_q1_fe_report.txt
    fi
    echo ==================== >> /root/2020Q1/2020_q1_fe_report.txt

	#清單輸入
    done < "/root/2020Q1/rp_servername_fe.txt"

echo -e "\033[43m_ERROR_量數:\033[0m" >> /root/2020Q1/2020_q1_fe_report.txt
cat /root/2020Q1/2020_q1_fe_report.txt | grep 'error' |wc -l  >> /root/2020Q1/2020_q1_fe_report.txt
rm -rf /root/2020Q1/rp_servername_fe.txt
    ;;

    "be") #選擇執行後台
    rm -rf /root/2020Q1/2020_q1_fe_report.txt
    cat /root/2020Q1/rp_servername.txt | grep bend > /root/2020Q1/rp_servername_be.txt
IFS='-'
while read brand item domain old
  do
    echo $brand >> /root/2020Q1/2020_q1_be_report.txt
    echo $domain >> /root/2020Q1/2020_q1_be_report.txt
    curl -Lk -m 5 https://$domain/apis/public/checkNew  | grep '401'
  if [ $? -ne 0 ]; then
    echo "$brand $domain error, /apis/public/checkNew  | grep '401'" >> /root/2020Q1/2020_q1_be_report.txt
  fi
    curl -Lk -m 5 https://$domain/apis/healthCheck should show 'passed'
  if [ $? -ne 0 ]; then
    echo "$brand $domain error, /apis/healthCheck should show 'passed'" >> /root/2020Q1/2020_q1_be_report.txt
  fi  
    curl -Lk -m 5 https://$domain/appauth/info | grep 'commit'
  if [ $? -ne 0 ]; then
    echo "$brand $domain error, /appauth/info should show 'commit'"  >> /root/2020Q1/2020_q1_be_report.txt
  fi
    curl -Lk -m 5 https://$domain/appauth | grep '不支持该请求来源'
  if [ $? -ne 0 ]; then
    echo "$brand $domain error, /appauth should show '不支持该请求来源'"  >> /root/2020Q1/2020_q1_be_report.txt  
  fi  
    curl -I -Lk -m 5 https://$domain/login | grep '200'  >> /root/2020Q1/2020_q1_be_report.txt
  if [ $? -ne 0 ]; then
    echo "$brand $domain error, /login should show '200'"  >> /root/2020Q1/2020_q1_be_report.txt
  fi
    echo ==================== >> /root/2020Q1/2020_q1_be_report.txt
done < "/root/2020Q1/rp_servername_be.txt"
echo -e "\033[43m_ERROR_量數:\033[0m" >> /root/2020Q1/2020_q1_be_report.txt
cat /root/2020Q1/2020_q1_fe_report.txt | grep 'error' |wc -l  >> /root/2020Q1/2020_q1_be_report.txt
rm -rf /root/2020Q1/rp_servername_be.txt
    ;;

  *)   
	exit
    ;;
esac

