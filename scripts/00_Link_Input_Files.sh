#!/bin/bash

REFERENCE_DIR='/data/courses/rnaseq_course/lncRNAs/Project1/references'
READS_DIR='/data/courses/rnaseq_course/lncRNAs/fastq'

#link the reference genome files
mkdir reference_genome
cd reference_genome

ln -s $REFERENCE_DIR/* .

cd ../

#link the reads (shortened the names to avoid clutter)

mkdir reads
cd reads

ln -s $READS_DIR/3_2_L3_R1_001_DID218YBevN6.fastq.gz 3_2_R1.fastq.gz 
ln -s $READS_DIR/3_2_L3_R2_001_UPhWv8AgN1X1.fastq.gz 3_2_R2.fastq.gz

ln -s $READS_DIR/3_4_L3_R1_001_QDBZnz0vm8Gd.fastq.gz 3_4_R1.fastq.gz
ln -s $READS_DIR/3_4_L3_R2_001_ng3ASMYgDCPQ.fastq.gz 3_4_R2.fastq.gz

ln -s $READS_DIR/3_7_L3_R1_001_Tjox96UQtyIc.fastq.gz 3_7_R1.fastq.gz
ln -s $READS_DIR/3_7_L3_R2_001_f60CeSASEcgH.fastq.gz 3_7_R2.fastq.gz

ln -s $READS_DIR/P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz P1_R1.fastq.gz
ln -s $READS_DIR/P1_L3_R2_001_yd9NfV9WdvvL.fastq.gz P1_R2.fastq.gz
ln -s $READS_DIR/P2_L3_R1_001_R82RphLQ2938.fastq.gz P2_R1.fastq.gz
ln -s $READS_DIR/P2_L3_R2_001_06FRMIIGwpH6.fastq.gz P2_R2.fastq.gz
ln -s $READS_DIR/P3_L3_R1_001_fjv6hlbFgCST.fastq.gz P3_R1.fastq.gz
ln -s $READS_DIR/P3_L3_R2_001_xo7RBLLYYqeu.fastq.gz P3_R2.fastq.gz

cd ../