#!/bin/bash
cd /root/go/bin

while true
do
	current_date=$(date)

	echo "start" $current_date >> compound.log

	echo -e $current_date
	echo "PASSWORD" | /root/go/bin/umeed tx distribution withdraw-all-rewards --from $UMEE_WALLET --fees=300uumee --chain-id $UMEE_CHAIN -y

	sleep 30s

	echo "sleep 30s"

	available_coin=$(/root/go/bin/umeed query bank balances $UMEE_WALLET_ADDRESS --chain-id $UMEE_CHAIN | awk '/amount:/ {print}' | tr -cd [:digit:])
	compounding_coin="$(($available_coin - 100000))"
	
	if [[ $compounding_coin -gt 1000000 ]]
	then
		valoper_address=$(echo "PASSWORD" | umeed keys show $UMEE_WALLET --bech val -a)

		echo "PASSWORD" | /root/go/bin/umeed tx staking delegate $valoper_address ${compounding_coin}uumee --chain-id $UMEE_CHAIN --from $UMEE_WALLET --fees=1000uumee --yes
	echo " " $compounding_coin " uumee delegated" >> compound.log
	else
		echo " " $compounding_coin "lower than 1000000" >> compound.log
	fi
	
	echo "end" $current_date >> compound.log
	
	sleep 600s
done
