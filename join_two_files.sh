#! /bin/bash

tmp_dir=/tmp

out1=$tmp_dir/{$$}_1
sort $1 > $out1

out1=$tmp_dir/{$$}_2
sort $2 > $out2

join $out1 $out2

rm $out1 $out2

