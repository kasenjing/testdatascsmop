#!/bin/bash

#!/bin/bash

print_help()
{
    echo ''
	echo -e "Usage: $0 [options] -t [STR] -n [STR] -1 [FILE] -2 [FILE] -r [DIR] -p [DIR]"
    echo -e "\t-t Experiment type: sprite, scsprite, rdsprite, chiadrop, scrna_10x_v3, scrna_10x_v2, dropseq, scatac_10x_v1, scarc_10x_v1, scair."
	echo -e "\t-n Library name."
    echo -e "\t-1 Read 1 FASTQ."
    echo -e "\t-2 Read 2 FASTQ."
    echo -e "\t-3 Read 3 FASTQ."
    echo -e "\t-4 Read 4 FASTQ."
    echo -e "\t-5 Read 5 FASTQ."
    echo -e "\t-r STAR reference genome directory."
    echo -e "\t-b BWA reference genome directory."
    echo -e "\t-c Custom configuration file."
    echo -e "\t-w Custom whitelist."
	echo -e "\t-@ Thread to use."
    echo -e "\t-l self ligation length."
    echo -e "\t-p ScSmOP directory."
    echo -e "\t-s Chromosome size file, need by chiadrop, scatac_10x_v1, scarc_10x_v1."
    echo -e "\t   Processing scARC-seq, specify ATAC FASTQ through -1 ATAC R1 -2 ATAC R2 -3 ATAC R3 -4 GEX R1 -5 GEX R2.\n"
    echo -e "Universal pipeline for multi-omics data process: <https://github.com/ZhengmzLab/ScSmOP/wiki>.\n"
}

if [[ $1 == '' ]]
then
    print_help
    exit 1
fi

thread=1
read_1_str="R1.fq.gz"
read_2_str="R2.fq.gz"
read_3_str="R3.fq.gz"
read_4_str="R4.fq.gz"
read_5_str="R5.fq.gz"
custom_config="-"
custom_whitelist="-"
chrom_size="-"
self_ligate="-"
barp_dir="-"

while getopts t:n:1:2:3:4:5:r:b:c:w:@:p:s:l:h flag
do
    case "${flag}" in 
        t)  expe_type=${OPTARG};;
        n)  name=${OPTARG};;
        1)  read_1_str=${OPTARG};;
        2)  read_2_str=${OPTARG};;
        3)  read_3_str=${OPTARG};;
        4)  read_4_str=${OPTARG};;
        5)  read_5_str=${OPTARG};;
        r)  star_ref=${OPTARG};;
        b)  bwa_ref=${OPTARG};;
        c)  custom_config=${OPTARG};;
        w)  custom_whitelist=${OPTARG};;
        @)  thread=${OPTARG};;
        p)  barp_dir=${OPTARG};;
        s)  chrom_size=${OPTARG};;
        l)  self_ligate=${OPTARG};;
        ? | h) print_help
            exit 1;;
    esac
done

if [[ $barp_dir == '-' ]]
then
    echo "ScSmOP directory is necessary for testing..."
    echo "Universal pipeline for multi-omics data process: <https://github.com/ZhengmzLab/ScSmOP/wiki>.\n"
    exit 1
fi

echo -e "${barp_dir}/scsmop.sh -t $expe_type -n test -1 ${read_1_str} -2 ${read_2_str} -3 ${read_3_str} -4 ${read_4_str} -5 ${read_5_str} -r ${star_ref} -b ${bwa_ref} -l 3000 "
cd ${expe_type}
${barp_dir}/scsmop.sh -t $expe_type -n test -1 ${read_1_str} -2 ${read_2_str} -3 ${read_3_str} -4 ${read_4_str} -5 ${read_5_str} -r ${star_ref} -b ${bwa_ref} -l 3000 -s ${chrom_size}