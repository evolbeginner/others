#! /bin/bash

transpose=`dirname $0`/transpose.rb


########################################################
for i in $@; do
	input_args=(${input_args[@]} "-i $i")
done

ruby $transpose ${input_args[@]}

