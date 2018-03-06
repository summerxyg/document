for i in {0..10000}
do
  redis-cli -h 172.21.118.62 -p 6379 cluster addslots $i
done
