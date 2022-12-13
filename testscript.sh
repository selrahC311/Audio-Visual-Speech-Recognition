#!/bin/bash
HInit -S lists/trainList.txt -l Adam -L labels/train -M hmms -o Adam -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Agne -L labels/train -M hmms -o Agne -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Bradley -L labels/train -M hmms -o Bradley -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Cameron -L labels/train -M hmms -o Cameron -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Darcey -L labels/train -M hmms -o Darcey -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Dylan -L labels/train -M hmms -o Dylan -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Georgiana -L labels/train -M hmms -o Georgiana -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Jack -L labels/train -M hmms -o Jack -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l James -L labels/train -M hmms -o James -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Jordan -L labels/train -M hmms -o Jordan -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Jonathan -L labels/train -M hmms -o Jonathan -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Liam -L labels/train -M hmms -o Liam -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Max -L labels/train -M hmms -o Max -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Mikhayla -L labels/train -M hmms -o Mikhayla -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Rob -L labels/train -M hmms -o Rob -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Shaun -L labels/train -M hmms -o Shaun -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Sophie -L labels/train -M hmms -o Sophie -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Tan -L labels/train -M hmms -o Tan -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Tom -L labels/train -M hmms -o Tom -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l Teodora -L labels/train -M hmms -o Teodora -T 1 lib/proto8States.txt
HInit -S lists/trainList.txt -l sil -L labels/train -M hmms -o sil -T 1 lib/proto8States.txt

HVite -T 1 -S lists/testList.txt -d hmms/ -w lib/NET -l results lib/dict lib/words3
HResults -e "???" sil -e "???" sp -L labels/test lib/words3 results/*.rec

