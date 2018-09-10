for file in trimmed/*P1*
do
  	name=${file#*/}
        samfile=${name/.lane*/.sam}
        id1=${name#*.}
        id2=${id1/lane_}
        id=${id2/_*}
        sm=${name:0:4}
        rg="@RG\tID:$id\tSM:$sm\tPL:ILLUMINA\tLB:$sm"
	echo "$rg"
done

