#!/bash/bin

for thread in 1 8 16
do
	for transition in 10000 100000
	do
	   bash test.sh $thread $transition >> final.txt
	   echo "Job done thread = $thread transition = $transition"
	   echo ""
	done
done 

