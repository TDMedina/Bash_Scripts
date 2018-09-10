#!/bin/bash

#example file naming scheme
#tumour_sample1.BD1LYPACXX.lane_8_P1_I18
#tumour_sample1.BD1LYPACXX.lane_8_P2_I18

for f1 in *_1_*;

do
	echo "First in pair is: $f1";
        f2="$(echo $f1 | sed -e 's/_1_/_2_/')";
	echo "Second in pair is: $f2";

	#now process pair files
done
