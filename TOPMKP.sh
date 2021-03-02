#!/bin/bash

export MYSQL_PWD='stsuser@6Dtech'


Q1=$(echo -e "\n\e[1;34m ENTER MSISDN  : \e[0m")
read -p "$Q1" MSISDN


ACCOUNTID=`mysql -ustsuser  -h192.168.42.11 -P3306 BILLING_BSS -sse "select account_id from BS_SERVICE where service_id='$MSISDN' and status='1'"`
PROFILEID=`mysql -ustsuser  -h192.168.42.11 -P3306 BILLING_BSS -sse "select profile_id from BS_SERVICE where service_id='$MSISDN' and status='1'"`



echo "$ACCOUNTID"
echo "$PROFILEID"
TOPRQID=TP`date +%F`
MKP=MK`date +%N`
echo "$TOPRQID"
echo "$MKP"

QW=`curl -i -X POST -H "Content-Type:application/json" -d '{"Request":{"request_id":"'$TOPRQID'","action":"TopUp","request_timestamp":"01092019140114","source_node":"SmartAttacker","userid":"1","username":"SmartAttacker","order_information":{"order_type":"TopUp","customer_name":"ABIN","dataset":{"param":[{"id":"service_id","value":"'$MSISDN'"},{"id":"account_id","value":"'$ACCOUNTID'"},{"id":"profile_id","value":"'$PROFILEID'"},{"id":"amount","value":"200000"},{"id":"TopUpType","value":"CREDIT"},{"id":"upfront_payment","value":"yes"}]}}}}' "http://192.168.42.13:18086/APIGateway/APIRequest/Submit"`

echo "$QW"

oid=$(echo "$QW"|grep -Po '"id":"order_id","value":*\K"[^"]*"'|sed 's/"//g')



PQ=`curl -i -X POST -H "Content-Type:application/json" -d '{"Request":{"request_id":"'$MKP'","request_timestamp":"30122018210252","action":"MakePayment","source_node":"SmartAttacker","userid":"1799","username":"SmartAttacker","order_information":{"order_type":"MakePayment","customer_name":"ABIN","payment":{"profile_id":"'$PROFILEID'","account_id":"'$ACCOUNTID'","amount":"150000.0","amount_paid":"","order_type":"","collection_source_type":"","collection_id":"","comment":"Ok","currency_code":"IDR","card_number":"","invoice_ids":"","invoice_amounts":"","payment_detail":[{"payment_mode":"9","reference_external_id":"2001","amount_paid":"2000000.0","amount_description":"whatsapp payment","mode_detail":[{"key":"payment_subscriber_id","value":""}]}]},"dataset":{"param":[{"id":"entity_id","value":"200"},{"id":"order_id","value":"'$oid'"},{"id":"service_id","value":"'$MSISDN'"}]}}}}' "http://192.168.42.13:18086/APIGateway/APIRequest/Submit"`

echo "$PQ"

resultcode=$(echo "$PQ"|grep -Po '"result_description": *\K"[^"]*"'|sed 's/"//g')




echo -e "\n\e[1;34m $resultcode  : \e[0m"