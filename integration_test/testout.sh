#!/bin/bash
DIR="./integration_test/output.txt"
cat 1> ./integration_test/output-temp.txt
cat ./integration_test/output-temp.txt | tr -d '\000' > $DIR
if cat $DIR | grep -q 'Failed'; then
echo -e '==========================================================='
echo -e '= ERROR DETAILS                                           ='
echo -e '==========================================================='
cat $DIR | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep 'Failed'
cat $DIR | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep 'Failed' >> ./integration_test/failTest.txt
fi
echo -e '==========================================================='
echo -e '= STEPS                                                   ='
echo -e '==========================================================='
cat $DIR | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep '\"STARTED\"$'
cat $DIR | pcregrep -M  '^@\=@\=.*@\+@\+$' | sed -e 's/\(@=@=,\)//g' | sed -e 's/\(,@+@+\)//g'
cat $DIR | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep -v '\"STARTED\"$' | tail -1 | grep -v '\"Passed\"$' | sed 's/BEFORE/Failed/g'
echo -e '==========================================================='
echo -e '= END OF TEST                                             ='
echo -e '==========================================================='
