 ### Novaseq ###

#putting all reads into 1 forward and 1 reverse
#create empty files in your soil folder where you will run the assembly from
touch <soil_1_>R1.fastq
touch <soil_1_>R2.fastq
#See excel sample sheet for more info

## go to illumina raw reads
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/


#concatenate each sample into 1 forward and 1 reverse file for each soil

## In ##
#In10a
zcat 0_raw_data/SD7438_S40_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7438_S40_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7438_S40_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7438_S40_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In1a
zcat 0_raw_data/SD7439_S41_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7439_S41_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7439_S41_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7439_S41_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In2
zcat 0_raw_data/SD7440_S42_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7440_S42_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7440_S42_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7440_S42_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In2a
zcat 0_raw_data/SD7441_S43_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7441_S43_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7441_S43_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7441_S43_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In4
zcat 0_raw_data/SD7416_S18_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7416_S18_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7416_S18_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7416_S18_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In6
zcat 0_raw_data/SD7422_S24_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7422_S24_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7422_S24_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7422_S24_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In8
zcat 0_raw_data/SD7430_S32_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7430_S32_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7430_S32_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7430_S32_L004_R2_001.fastq.gz >> In/In_R2.fastq
#In9
zcat 0_raw_data/SD7433_S35_L003_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7433_S35_L004_R1_001.fastq.gz >> In/In_R1.fastq
zcat 0_raw_data/SD7433_S35_L003_R2_001.fastq.gz >> In/In_R2.fastq
zcat 0_raw_data/SD7433_S35_L004_R2_001.fastq.gz >> In/In_R2.fastq

##concat into individual samples
#In10a
zcat 0_raw_data/SD7438_S40_L003_R1_001.fastq.gz >> In/In10a_SD7438_S40_R1.fastq
zcat 0_raw_data/SD7438_S40_L004_R1_001.fastq.gz >> In/In10a_SD7438_S40_R1.fastq
zcat 0_raw_data/SD7438_S40_L003_R2_001.fastq.gz >> In/In10a_SD7438_S40_R2.fastq
zcat 0_raw_data/SD7438_S40_L004_R2_001.fastq.gz >> In/In10a_SD7438_S40_R2.fastq
#In1a
cat 0_raw_data/SD7439_S41_L003_R1_001.fastq.gz >> In/In1a_SD7439_S41_R1.fastq
zcat 0_raw_data/SD7439_S41_L004_R1_001.fastq.gz >> In/In1a_SD7439_S41_R1.fastq
zcat 0_raw_data/SD7439_S41_L003_R2_001.fastq.gz >> In/In1a_SD7439_S41_R2.fastq
zcat 0_raw_data/SD7439_S41_L004_R2_001.fastq.gz >> In/In1a_SD7439_S41_R2.fastq
#In2
zcat 0_raw_data/SD7440_S42_L003_R1_001.fastq.gz >> In/In2_SD7440_S42_R1.fastq
zcat 0_raw_data/SD7440_S42_L003_R2_001.fastq.gz >> In/In2_SD7440_S42_R2.fastq
zcat 0_raw_data/SD7440_S42_L004_R1_001.fastq.gz >> In/In2_SD7440_S42_R1.fastq
zcat 0_raw_data/SD7440_S42_L004_R2_001.fastq.gz >> In/In2_SD7440_S42_R2.fastq
#In2a
zcat 0_raw_data/SD7441_S43_L003_R1_001.fastq.gz >> In/In2a_SD7441_S43_R1.fastq
zcat 0_raw_data/SD7441_S43_L004_R1_001.fastq.gz >> In/In2a_SD7441_S43_R1.fastq
zcat 0_raw_data/SD7441_S43_L003_R2_001.fastq.gz >> In/In2a_SD7441_S43_R2.fastq
zcat 0_raw_data/SD7441_S43_L004_R2_001.fastq.gz >> In/In2a_SD7441_S43_R2.fastq
#In4
zcat 0_raw_data/SD7416_S18_L003_R1_001.fastq.gz >> In/In4_SD716_S18_R1.fastq
zcat 0_raw_data/SD7416_S18_L004_R1_001.fastq.gz >> In/In4_SD716_S18_R1.fastq
zcat 0_raw_data/SD7416_S18_L003_R2_001.fastq.gz >> In/In4_SD716_S18_R2.fastq
zcat 0_raw_data/SD7416_S18_L004_R2_001.fastq.gz >> In/In4_SD716_S18_R2.fastq
#In6
zcat 0_raw_data/SD7422_S24_L003_R1_001.fastq.gz >> In/In6_SD7422_S24_R1.fastq
zcat 0_raw_data/SD7422_S24_L004_R1_001.fastq.gz >> In/In6_SD7422_S24_R1.fastq
zcat 0_raw_data/SD7422_S24_L003_R2_001.fastq.gz >> In/In6_SD7422_S24_R2.fastq
zcat 0_raw_data/SD7422_S24_L004_R2_001.fastq.gz >> In/In6_SD7422_S24_R2.fastq
#In8
zcat 0_raw_data/SD7430_S32_L003_R1_001.fastq.gz >> In/In8_SD7430_S32_R1.fastq
zcat 0_raw_data/SD7430_S32_L004_R1_001.fastq.gz >> In/In8_SD7430_S32_R1.fastq
zcat 0_raw_data/SD7430_S32_L003_R2_001.fastq.gz >> In/In8_SD7430_S32_R2.fastq
zcat 0_raw_data/SD7430_S32_L004_R2_001.fastq.gz >> In/In8_SD7430_S32_R2.fastq
#In9
zcat 0_raw_data/SD7433_S35_L003_R1_001.fastq.gz >> In/In9_SD7433_S35_R1.fastq
zcat 0_raw_data/SD7433_S35_L004_R1_001.fastq.gz >> In/In9_SD7433_S35_R1.fastq
zcat 0_raw_data/SD7433_S35_L003_R2_001.fastq.gz >> In/In9_SD7433_S35_R2.fastq
zcat 0_raw_data/SD7433_S35_L004_R2_001.fastq.gz >> In/In9_SD7433_S35_R2.fastq

#gzip all files
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/In
gzip *.fastq

## Li ##

#Li10a
zcat 0_raw_data/SD7442_S44_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7442_S44_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7442_S44_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7442_S44_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li2
zcat 0_raw_data/SD7409_S11_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7409_S11_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7409_S11_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7409_S11_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li3
zcat 0_raw_data/SD7412_S14_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7412_S14_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7412_S14_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7412_S14_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li4
zcat 0_raw_data/SD7417_S19_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7417_S19_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7417_S19_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7417_S19_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li6
zcat 0_raw_data/SD7423_S25_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7423_S25_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7423_S25_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7423_S25_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li7
zcat 0_raw_data/SD7426_S28_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7426_S28_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7426_S28_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7426_S28_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li8
zcat 0_raw_data/SD7431_S33_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7431_S33_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7431_S33_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7431_S33_L004_R2_001.fastq.gz >> Li/Li_R2.fastq
#Li9
zcat 0_raw_data/SD7434_S36_L003_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7434_S36_L003_R2_001.fastq.gz >> Li/Li_R2.fastq
zcat 0_raw_data/SD7434_S36_L004_R1_001.fastq.gz >> Li/Li_R1.fastq
zcat 0_raw_data/SD7434_S36_L004_R2_001.fastq.gz >> Li/Li_R2.fastq

##Individual samples
#Li10a
zcat 0_raw_data/SD7442_S44_L003_R1_001.fastq.gz >> Li/Li10a_SD7442_S44_R1.fastq
zcat 0_raw_data/SD7442_S44_L003_R2_001.fastq.gz >> Li/Li10a_SD7442_S44_R2.fastq
zcat 0_raw_data/SD7442_S44_L004_R1_001.fastq.gz >> Li/Li10a_SD7442_S44_R1.fastq
zcat 0_raw_data/SD7442_S44_L004_R2_001.fastq.gz >> Li/Li10a_SD7442_S44_R2.fastq
#Li2
zcat 0_raw_data/SD7409_S11_L003_R1_001.fastq.gz >> Li/Li2_SD7409_S11_R1.fastq
zcat 0_raw_data/SD7409_S11_L003_R2_001.fastq.gz >> Li/Li2_SD7409_S11_R2.fastq
zcat 0_raw_data/SD7409_S11_L004_R1_001.fastq.gz >> Li/Li2_SD7409_S11_R1.fastq
zcat 0_raw_data/SD7409_S11_L004_R2_001.fastq.gz >> Li/Li2_SD7409_S11_R2.fastq
#Li3
zcat 0_raw_data/SD7412_S14_L003_R1_001.fastq.gz >> Li/Li3_SD7412_S14_R1.fastq
zcat 0_raw_data/SD7412_S14_L003_R2_001.fastq.gz >> Li/Li3_SD7412_S14_R2.fastq
zcat 0_raw_data/SD7412_S14_L004_R1_001.fastq.gz >> Li/Li3_SD7412_S14_R1.fastq
zcat 0_raw_data/SD7412_S14_L004_R2_001.fastq.gz >> Li/Li3_SD7412_S14_R2.fastq
#li4
zcat 0_raw_data/SD7417_S19_L003_R1_001.fastq.gz >> Li/Li4_SD7417_S19_R1.fastq
zcat 0_raw_data/SD7417_S19_L003_R2_001.fastq.gz >> Li/Li4_SD7417_S19_R2.fastq
zcat 0_raw_data/SD7417_S19_L004_R1_001.fastq.gz >> Li/Li4_SD7417_S19_R1.fastq
zcat 0_raw_data/SD7417_S19_L004_R2_001.fastq.gz >> Li/Li4_SD7417_S19_R2.fastq
#Li6
zcat 0_raw_data/SD7423_S25_L003_R1_001.fastq.gz >> Li/Li6_SD7423_S25_R1.fastq
zcat 0_raw_data/SD7423_S25_L003_R2_001.fastq.gz >> Li/Li6_SD7423_S25_R2.fastq
zcat 0_raw_data/SD7423_S25_L004_R1_001.fastq.gz >> Li/Li6_SD7423_S25_R1.fastq
zcat 0_raw_data/SD7423_S25_L004_R2_001.fastq.gz >> Li/Li6_SD7423_S25_R2.fastq
#Li7
zcat 0_raw_data/SD7426_S28_L003_R1_001.fastq.gz >> Li/Li7_SD7426_S28_R1.fastq
zcat 0_raw_data/SD7426_S28_L003_R2_001.fastq.gz >> Li/Li7_SD7426_S28_R2.fastq
zcat 0_raw_data/SD7426_S28_L004_R1_001.fastq.gz >> Li/Li7_SD7426_S28_R1.fastq
zcat 0_raw_data/SD7426_S28_L004_R2_001.fastq.gz >> Li/Li7_SD7426_S28_R2.fastq
#Li8
zcat 0_raw_data/SD7431_S33_L003_R1_001.fastq.gz >> Li/Li8_SD7431_S33_R1.fastq
zcat 0_raw_data/SD7431_S33_L003_R2_001.fastq.gz >> Li/Li8_SD7431_S33_R2.fastq
zcat 0_raw_data/SD7431_S33_L004_R1_001.fastq.gz >> Li/Li8_SD7431_S33_R1.fastq
zcat 0_raw_data/SD7431_S33_L004_R2_001.fastq.gz >> Li/Li8_SD7431_S33_R2.fastq
#Li9
zcat 0_raw_data/SD7434_S36_L003_R1_001.fastq.gz >> Li/Li9_SD7434_S36_R1.fastq
zcat 0_raw_data/SD7434_S36_L003_R2_001.fastq.gz >> Li/Li9_SD7434_S36_R2.fastq
zcat 0_raw_data/SD7434_S36_L004_R1_001.fastq.gz >> Li/Li9_SD7434_S36_R1.fastq
zcat 0_raw_data/SD7434_S36_L004_R2_001.fastq.gz >> Li/Li9_SD7434_S36_R2.fastq

#gzip all files
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/li
gzip *.fastq

## Pg ##

#Pg1a
zcat 0_raw_data/SD7443_S45_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7443_S45_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7443_S45_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
cat 0_raw_data/SD7443_S45_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg2
zcat 0_raw_data/SD7410_S12_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7410_S12_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7410_S12_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7410_S12_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg3
zcat 0_raw_data/SD7413_S15_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7413_S15_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7413_S15_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7413_S15_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg4
zcat 0_raw_data/SD7418_S20_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7418_S20_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7418_S20_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7418_S20_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg6
zcat 0_raw_data/SD7444_S46_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7444_S46_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7444_S46_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7444_S46_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg6a
zcat 0_raw_data/SD7445_S47_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7445_S47_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7445_S47_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7445_S47_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg7
zcat 0_raw_data/SD7427_S29_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7427_S29_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7427_S29_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7427_S29_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq
#Pg9
zcat 0_raw_data/SD7435_S37_L003_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7435_S37_L003_R2_001.fastq.gz >> Pg/Pg_R2.fastq
zcat 0_raw_data/SD7435_S37_L004_R1_001.fastq.gz >> Pg/Pg_R1.fastq
zcat 0_raw_data/SD7435_S37_L004_R2_001.fastq.gz >> Pg/Pg_R2.fastq

##Individual samples
#Pg1a
zcat 0_raw_data/SD7443_S45_L003_R1_001.fastq.gz >> Pg/Pg1a_SD7443_S45_R1.fastq
zcat 0_raw_data/SD7443_S45_L003_R2_001.fastq.gz >> Pg/Pg1a_SD7443_S45_R2.fastq
zcat 0_raw_data/SD7443_S45_L004_R1_001.fastq.gz >> Pg/Pg1a_SD7443_S45_R1.fastq
zcat 0_raw_data/SD7443_S45_L004_R2_001.fastq.gz >> Pg/Pg1a_SD7443_S45_R2.fastq
#Pg2
zcat 0_raw_data/SD7410_S12_L003_R1_001.fastq.gz >> Pg/Pg2_SD7410_S12_R1.fastq
zcat 0_raw_data/SD7410_S12_L003_R2_001.fastq.gz >> Pg/Pg2_SD7410_S12_R2.fastq
zcat 0_raw_data/SD7410_S12_L004_R1_001.fastq.gz >> Pg/Pg2_SD7410_S12_R1.fastq
zcat 0_raw_data/SD7410_S12_L004_R2_001.fastq.gz >> Pg/Pg2_SD7410_S12_R2.fastq
#Pg3
zcat 0_raw_data/SD7413_S15_L003_R1_001.fastq.gz >> Pg/Pg3_SD7413_S15_R1.fastq
zcat 0_raw_data/SD7413_S15_L003_R2_001.fastq.gz >> Pg/Pg3_SD7413_S15_R2.fastq
zcat 0_raw_data/SD7413_S15_L004_R1_001.fastq.gz >> Pg/Pg3_SD7413_S15_R1.fastq
zcat 0_raw_data/SD7413_S15_L004_R2_001.fastq.gz >> Pg/Pg3_SD7413_S15_R2.fastq
#Pg4
zcat 0_raw_data/SD7418_S20_L003_R1_001.fastq.gz >> Pg/Pg4_SD7418_S20_R1.fastq
zcat 0_raw_data/SD7418_S20_L003_R2_001.fastq.gz >> Pg/Pg4_SD7418_S20_R2.fastq
zcat 0_raw_data/SD7418_S20_L004_R1_001.fastq.gz >> Pg/Pg4_SD7418_S20_R1.fastq
zcat 0_raw_data/SD7418_S20_L004_R2_001.fastq.gz >> Pg/Pg4_SD7418_S20_R2.fastq
#Pg6
zcat 0_raw_data/SD7444_S46_L003_R1_001.fastq.gz >> Pg/Pg6_SD7444_S46_R1.fastq
zcat 0_raw_data/SD7444_S46_L003_R2_001.fastq.gz >> Pg/Pg6_SD7444_S46_R2.fastq
zcat 0_raw_data/SD7444_S46_L004_R1_001.fastq.gz >> Pg/Pg6_SD7444_S46_R1.fastq
zcat 0_raw_data/SD7444_S46_L004_R2_001.fastq.gz >> Pg/Pg6_SD7444_S46_R2.fastq
#Pg6a
zcat 0_raw_data/SD7445_S47_L003_R1_001.fastq.gz >> Pg/Pg6a_SD7445_S47_R1.fastq
zcat 0_raw_data/SD7445_S47_L003_R2_001.fastq.gz >> Pg/Pg6a_SD7445_S47_R2.fastq
zcat 0_raw_data/SD7445_S47_L004_R1_001.fastq.gz >> Pg/Pg6a_SD7445_S47_R1.fastq
zcat 0_raw_data/SD7445_S47_L004_R2_001.fastq.gz >> Pg/Pg6a_SD7445_S47_R2.fastq
#Pg7
zcat 0_raw_data/SD7427_S29_L003_R1_001.fastq.gz >> Pg/Pg7_SD7427_S29_R1.fastq
zcat 0_raw_data/SD7427_S29_L003_R2_001.fastq.gz >> Pg/Pg7_SD7427_S29_R2.fastq
zcat 0_raw_data/SD7427_S29_L004_R1_001.fastq.gz >> Pg/Pg7_SD7427_S29_R1.fastq
zcat 0_raw_data/SD7427_S29_L004_R2_001.fastq.gz >> Pg/Pg7_SD7427_S29_R2.fastq
#Pg9
zcat 0_raw_data/SD7435_S37_L003_R1_001.fastq.gz >> Pg/Pg9_SD7435_S37_R1.fastq
zcat 0_raw_data/SD7435_S37_L003_R2_001.fastq.gz >> Pg/Pg9_SD7435_S37_R2.fastq
zcat 0_raw_data/SD7435_S37_L004_R1_001.fastq.gz >> Pg/Pg9_SD7435_S37_R1.fastq
zcat 0_raw_data/SD7435_S37_L004_R2_001.fastq.gz >> Pg/Pg9_SD7435_S37_R2.fastq

#gzip all files
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Pg
gzip *.fastq

## To ##
#To10
zcat 0_raw_data/SD7407_S9_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7407_S9_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7407_S9_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7407_S9_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To9
zcat 0_raw_data/SD7436_S38_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7436_S38_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7436_S38_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7436_S38_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To2
zcat 0_raw_data/SD7446_S48_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7446_S48_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7446_S48_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7446_S48_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To3
zcat 0_raw_data/SD7414_S16_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7414_S16_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7414_S16_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7414_S16_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To4
zcat 0_raw_data/SD7419_S21_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7419_S21_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7419_S21_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7419_S21_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To5
zcat 0_raw_data/SD7420_S22_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7420_S22_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7420_S22_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7420_S22_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To6
zcat 0_raw_data/SD7424_S26_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7424_S26_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7424_S26_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7424_S26_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To7
zcat 0_raw_data/SD7428_S30_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7428_S30_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7428_S30_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7428_S30_L004_R2_001.fastq.gz >> To/To_R2.fastq
#To8
zcat 0_raw_data/SD7432_S34_L003_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7432_S34_L004_R1_001.fastq.gz >> To/To_R1.fastq
zcat 0_raw_data/SD7432_S34_L003_R2_001.fastq.gz >> To/To_R2.fastq
zcat 0_raw_data/SD7432_S34_L004_R2_001.fastq.gz >> To/To_R2.fastq

# concat each sample
#To10
zcat 0_raw_data/SD7407_S9_L003_R1_001.fastq.gz >> To/SD7407_S9_R1.fastq
Zcat 0_raw_data/SD7407_S9_L004_R1_001.fastq.gz >> To/SD7407_S9_R1.fastq
zcat 0_raw_data/SD7407_S9_L003_R2_001.fastq.gz >> To/SD7407_S9_R2.fastq
zcat 0_raw_data/SD7407_S9_L004_R2_001.fastq.gz >> To/SD7407_S9_R2.fastq
#To9
zcat 0_raw_data/SD7436_S38_L003_R1_001.fastq.gz >> To/SD7436_S38_R1.fastq
zcat 0_raw_data/SD7436_S38_L004_R1_001.fastq.gz >> To/SD7436_S38_R1.fastq
zcat 0_raw_data/SD7436_S38_L003_R2_001.fastq.gz >> To/SD7436_S38_R2.fastq
zcat 0_raw_data/SD7436_S38_L004_R2_001.fastq.gz >> To/SD7436_S38_R2.fastq
#To2
zcat 0_raw_data/SD7446_S48_L003_R1_001.fastq.gz >> To/SD7446_S48_R1.fastq
zcat 0_raw_data/SD7446_S48_L004_R1_001.fastq.gz >> To/SD7446_S48_R1.fastq
zcat 0_raw_data/SD7446_S48_L003_R2_001.fastq.gz >> To/SD7446_S48_R2.fastq
zcat 0_raw_data/SD7446_S48_L004_R2_001.fastq.gz >> To/SD7446_S48_R2.fastq
#To3
zcat 0_raw_data/SD7414_S16_L003_R1_001.fastq.gz >> To/SD7414_S16_R1.fastq
zcat 0_raw_data/SD7414_S16_L004_R1_001.fastq.gz >> To/SD7414_S16_R1.fastq
zcat 0_raw_data/SD7414_S16_L003_R2_001.fastq.gz >> To/SD7414_S16_R2.fastq
zcat 0_raw_data/SD7414_S16_L004_R2_001.fastq.gz >> To/SD7414_S16_R2.fastq
#To4
zcat 0_raw_data/SD7419_S21_L003_R1_001.fastq.gz >> To/SD7419_S21_R1.fastq
zcat 0_raw_data/SD7419_S21_L004_R1_001.fastq.gz >> To/SD7419_S21_R1.fastq
zcat 0_raw_data/SD7419_S21_L003_R2_001.fastq.gz >> To/SD7419_S21_R2.fastq
zcat 0_raw_data/SD7419_S21_L004_R2_001.fastq.gz >> To/SD7419_S21_R2.fastq
#To5
zcat 0_raw_data/SD7420_S22_L003_R1_001.fastq.gz >> To/SD7420_S22_R1.fastq
zcat 0_raw_data/SD7420_S22_L004_R1_001.fastq.gz >> To/SD7420_S22_R1.fastq
zcat 0_raw_data/SD7420_S22_L003_R2_001.fastq.gz >> To/SD7420_S22_R2.fastq
zcat 0_raw_data/SD7420_S22_L004_R2_001.fastq.gz >> To/SD7420_S22_R2.fastq
#To6
zcat 0_raw_data/SD7424_S26_L003_R1_001.fastq.gz >> To/SD7424_S26_R1.fastq
zcat 0_raw_data/SD7424_S26_L004_R1_001.fastq.gz >> To/SD7424_S26_R1.fastq
zcat 0_raw_data/SD7424_S26_L003_R2_001.fastq.gz >> To/SD7424_S26_R2.fastq
zcat 0_raw_data/SD7424_S26_L004_R2_001.fastq.gz >> To/SD7424_S26_R2.fastq
#To7
zcat 0_raw_data/SD7428_S30_L003_R1_001.fastq.gz >> To/SD7428_S30_R1.fastq
zcat 0_raw_data/SD7428_S30_L004_R1_001.fastq.gz >> To/SD7428_S30_R1.fastq
zcat 0_raw_data/SD7428_S30_L003_R2_001.fastq.gz >> To/SD7428_S30_R2.fastq
zcat 0_raw_data/SD7428_S30_L004_R2_001.fastq.gz >> To/SD7428_S30_R2.fastq
#To8
zcat 0_raw_data/SD7432_S34_L003_R1_001.fastq.gz >> To/SD7432_S34_R1.fastq
zcat 0_raw_data/SD7432_S34_L004_R1_001.fastq.gz >> To/SD7432_S34_R1.fastq
zcat 0_raw_data/SD7432_S34_L003_R2_001.fastq.gz >> To/SD7432_S34_R2.fastq
zcat 0_raw_data/SD7432_S34_L004_R2_001.fastq.gz >> To/SD7432_S34_R2.fastq

#Had to rename all the individual samples to add in the sample names, like the
#other soils. used the mv function see soil specific notebook

#gzip all files
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/To
gzip *.fastq


## Tu ##

#Tu10
zcat 0_raw_data/SD7408_S10_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7408_S10_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7408_S10_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7408_S10_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu2
zcat 0_raw_data/SD7411_S13_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7411_S13_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7411_S13_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7411_S13_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu3
zcat 0_raw_data/SD7415_S17_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7415_S17_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7415_S17_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7415_S17_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu5
zcat 0_raw_data/SD7421_S23_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7421_S23_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7421_S23_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7421_S23_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu6
zcat 0_raw_data/SD7425_S27_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7425_S27_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7425_S27_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7425_S27_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu7
zcat 0_raw_data/SD7429_S31_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7429_S31_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7429_S31_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
#zcat 0_raw_data/SD7429_S31_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu8
zcat 0_raw_data/SD7447_S49_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7447_S49_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7447_S49_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7447_S49_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu8a
zcat 0_raw_data/SD7448_S50_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7448_S50_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7448_S50_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7448_S50_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq
#Tu9
zcat 0_raw_data/SD7437_S39_L003_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7437_S39_L003_R2_001.fastq.gz >> Tu/Tu_R2.fastq
zcat 0_raw_data/SD7437_S39_L004_R1_001.fastq.gz >> Tu/Tu_R1.fastq
zcat 0_raw_data/SD7437_S39_L004_R2_001.fastq.gz >> Tu/Tu_R2.fastq

#samples
#Tu10
zcat 0_raw_data/SD7408_S10_L003_R1_001.fastq.gz >> Tu/Tu10_SD7408_S10_R1.fastq
zcat 0_raw_data/SD7408_S10_L003_R2_001.fastq.gz >> Tu/Tu10_SD7408_S10_R2.fastq
zcat 0_raw_data/SD7408_S10_L004_R1_001.fastq.gz >> Tu/Tu10_SD7408_S10_R1.fastq
zcat 0_raw_data/SD7408_S10_L004_R2_001.fastq.gz >> Tu/Tu10_SD7408_S10_R2.fastq
#Tu2
zcat 0_raw_data/SD7411_S13_L003_R1_001.fastq.gz >> Tu/Tu2_SD7411_S13_R1.fastq
zcat 0_raw_data/SD7411_S13_L003_R2_001.fastq.gz >> Tu/Tu2_SD7411_S13_R2.fastq
zcat 0_raw_data/SD7411_S13_L004_R1_001.fastq.gz >> Tu/Tu2_SD7411_S13_R1.fastq
zcat 0_raw_data/SD7411_S13_L004_R2_001.fastq.gz >> Tu/Tu2_SD7411_S13_R2.fastq
#Tu3
zcat 0_raw_data/SD7415_S17_L003_R1_001.fastq.gz >> Tu/Tu3_SD7415_S17_R1.fastq
zcat 0_raw_data/SD7415_S17_L003_R2_001.fastq.gz >> Tu/Tu3_SD7415_S17_R2.fastq
zcat 0_raw_data/SD7415_S17_L004_R1_001.fastq.gz >> Tu/Tu3_SD7415_S17_R1.fastq
zcat 0_raw_data/SD7415_S17_L004_R2_001.fastq.gz >> Tu/Tu3_SD7415_S17_R2.fastq
#Tu5
zcat 0_raw_data/SD7421_S23_L003_R1_001.fastq.gz >> Tu/Tu5_SD7421_S23_R1.fastq
zcat 0_raw_data/SD7421_S23_L003_R2_001.fastq.gz >> Tu/Tu5_SD7421_S23_R2.fastq
zcat 0_raw_data/SD7421_S23_L004_R1_001.fastq.gz >> Tu/Tu5_SD7421_S23_R1.fastq
zcat 0_raw_data/SD7421_S23_L004_R2_001.fastq.gz >> Tu/Tu5_SD7421_S23_R2.fastq
#Tu6
zcat 0_raw_data/SD7425_S27_L003_R1_001.fastq.gz >> Tu/Tu6_SD7425_S27_R1.fastq
zcat 0_raw_data/SD7425_S27_L003_R2_001.fastq.gz >> Tu/Tu6_SD7425_S27_R2.fastq
zcat 0_raw_data/SD7425_S27_L004_R1_001.fastq.gz >> Tu/Tu6_SD7425_S27_R1.fastq
zcat 0_raw_data/SD7425_S27_L004_R2_001.fastq.gz >> Tu/Tu6_SD7425_S27_R2.fastq
#Tu7
zcat 0_raw_data/SD7429_S31_L003_R1_001.fastq.gz >> Tu/Tu7_SD7429_S31_R1.fastq
zcat 0_raw_data/SD7429_S31_L003_R2_001.fastq.gz >> Tu/Tu7_SD7429_S31_R2.fastq
zcat 0_raw_data/SD7429_S31_L004_R1_001.fastq.gz >> Tu/Tu7_SD7429_S31_R1.fastq
zcat 0_raw_data/SD7429_S31_L004_R2_001.fastq.gz >> Tu/Tu7_SD7429_S31_R2.fastq
#Tu8
zcat 0_raw_data/SD7447_S49_L003_R1_001.fastq.gz >> Tu/Tu8_SD7447_S49_R1.fastq
zcat 0_raw_data/SD7447_S49_L003_R2_001.fastq.gz >> Tu/Tu8_SD7447_S49_R2.fastq
zcat 0_raw_data/SD7447_S49_L004_R1_001.fastq.gz >> Tu/Tu8_SD7447_S49_R1.fastq
zcat 0_raw_data/SD7447_S49_L004_R2_001.fastq.gz >> Tu/Tu8_SD7447_S49_R2.fastq
#Tu8a
zcat 0_raw_data/SD7448_S50_L003_R1_001.fastq.gz >> Tu/Tu8a_SD7448_S50_R1.fastq
zcat 0_raw_data/SD7448_S50_L003_R2_001.fastq.gz >> Tu/Tu8a_SD7448_S50_R2.fastq
zcat 0_raw_data/SD7448_S50_L004_R1_001.fastq.gz >> Tu/Tu8a_SD7448_S50_R1.fastq
zcat 0_raw_data/SD7448_S50_L004_R2_001.fastq.gz >> Tu/Tu8a_SD7448_S50_R2.fastq
#Tu9
zcat 0_raw_data/SD7437_S39_L003_R1_001.fastq.gz >> Tu/Tu9_SD7437_S39_R1.fastq
zcat 0_raw_data/SD7437_S39_L003_R2_001.fastq.gz >> Tu/Tu9_SD7437_S39_R2.fastq
zcat 0_raw_data/SD7437_S39_L004_R1_001.fastq.gz >> Tu/Tu9_SD7437_S39_R1.fastq
zcat 0_raw_data/SD7437_S39_L004_R2_001.fastq.gz >> Tu/Tu9_SD7437_S39_R2.fastq

#gzip all files
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Tu
gzip *.fastq

#Check that concat worked
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Pg/
grep '@' Pg_R1.fastq | wc -c
14872403411
grep '@' Pg_R2.fastq | wc -c
15202470345

rm Pg_R1.fastq
rm Pg_R2.fastq
touch Pg_R1.fastq
touch Pg_R2.fastq

#check each samples 03/08/21
grep '@' Pg1a_SD7443_S45_R1.fastq | wc -c
2739290362
grep '@' Pg1a_SD7443_S45_R2.fastq | wc -c
2739290362

grep '@' Pg2_SD7410_S12_R1.fastq | wc -c
1048965983
grep '@' Pg2_SD7410_S12_R2.fastq | wc -c
1048965983

grep '@' Pg3_SD7413_S15_R1.fastq | wc -c
2996288297 #needs to be redone
grep '@' Pg3_SD7413_S15_R2.fastq | wc -c
2296815956

grep '@' Pg4_SD7418_S20_R1.fastq | wc -c
1734799604
grep '@' Pg4_SD7418_S20_R2.fastq | wc -c
1734799604

grep '@' Pg6a_SD7445_S47_R1.fastq | wc -c
1623248943
grep '@' Pg6a_SD7445_S47_R2.fastq | wc -c
1623248943

grep '@' Pg6_SD7444_S46_R1.fastq | wc -c
1922139690
grep '@' Pg6_SD7444_S46_R2.fastq | wc -c
1922139690

grep '@' Pg7_SD7427_S29_R1.fastq | wc -c
1339697223
grep '@' Pg7_SD7427_S29_R2.fastq | wc -c
1339697223

grep '@' Pg9_SD7435_S37_R1.fastq | wc -c
2046206121
grep '@' Pg9_SD7435_S37_R2.fastq | wc -c
2046206121

rm Pg3_SD7413_S15_R1.fastq
rm Pg3_SD7413_S15_R2.fastq
touch Pg3_SD7413_S15_R1.fastq
touch Pg3_SD7413_S15_R2.fastq

cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/

#Pg3
zcat 0_raw_data/SD7413_S15_L003_R1_001.fastq.gz >> Pg/Pg3_SD7413_S15_R1.fastq
zcat 0_raw_data/SD7413_S15_L003_R2_001.fastq.gz >> Pg/Pg3_SD7413_S15_R2.fastq
zcat 0_raw_data/SD7413_S15_L004_R1_001.fastq.gz >> Pg/Pg3_SD7413_S15_R1.fastq
zcat 0_raw_data/SD7413_S15_L004_R2_001.fastq.gz >> Pg/Pg3_SD7413_S15_R2.fastq

cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Pg/

grep '@' Pg3_SD7413_S15_R1.fastq | wc -c
2264316187
grep '@' Pg3_SD7413_S15_R2.fastq | wc -c
2264316187

#Reconcating all samples
cd /rdm/Q0775-uqbclar8/belle/01_core/01_5soils_AER/02_novaseq/Pg/

#Pg1a
cat Pg1a_SD7443_S45_R1.fastq >> Pg_R1.fastq
cat Pg1a_SD7443_S45_R2.fastq >> Pg_R2.fastq
#Pg2
cat Pg2_SD7410_S12_R1.fastq >> Pg_R1.fastq
cat Pg2_SD7410_S12_R2.fastq >> Pg_R2.fastq
#Pg3
cat Pg3_SD7413_S15_R1.fastq >> Pg_R1.fastq
cat Pg3_SD7413_S15_R2.fastq >> Pg_R2.fastq
#Pg4
cat Pg4_SD7418_S20_R1.fastq >> Pg_R1.fastq
cat Pg4_SD7418_S20_R2.fastq >> Pg_R2.fastq
#Pg6a
cat Pg6a_SD7445_S47_R1.fastq >> Pg_R1.fastq
cat Pg6a_SD7445_S47_R2.fastq >> Pg_R2.fastq
#Pg6
cat Pg6_SD7444_S46_R1.fastq >> Pg_R1.fastq
cat Pg6_SD7444_S46_R2.fastq >> Pg_R2.fastq
#Pg7
cat Pg7_SD7427_S29_R1.fastq >> Pg_R1.fastq
cat Pg7_SD7427_S29_R2.fastq >> Pg_R2.fastq
#Pg9
cat Pg9_SD7435_S37_R1.fastq >> Pg_R1.fastq
cat Pg9_SD7435_S37_R2.fastq >> Pg_R2.fastq

grep '@' Pg_R1.fastq | wc -c
14718664113
grep '@' Pg_R2.fastq | wc -c
14718664113
gzip *.fastq


### Minion ###
#see 1_minion_data_workflow for more details

#Once you have gziped pass and fail barcodes move the relevant novaseq folder
#to the server and then put the relevant barcode (minion sequence) into the
#same folder
