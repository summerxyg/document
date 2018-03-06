for i in {10001..16383}
do
  redis-cli -h 172.21.118.62 -p 6380 cluster addslots $i
done
