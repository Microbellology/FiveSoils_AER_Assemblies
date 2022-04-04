#!/usr/bin/env bash
~/ont-guppy_4.5.4/bin/guppy_basecaller -i belle_fast5/ -s fastq/ -c dna_r9.4.1_450bps_hac.cfg --device cuda:0 -q 0 --barcode_kits EXP-NBD104
