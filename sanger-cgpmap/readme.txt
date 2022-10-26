Notes on paired-end files and readgroup definitions
---------------------------------------------------
Paired-end fastq files must end with _1.[ext] _2.[ext] or _R1_001.[ext] _R2_001.[ext]. 
See https://github.com/cancerit/PCAP-core/blob/7414c1034a8b08c2d112cd10f72b4c49fe572376/lib/PCAP/Bwa/Meta.pm#L354.

If supplying a readinfo file, only the fastq file of read1 must be specified. An error like "No readgroup info defined for input data AS-844817-LR-64712_R2.fastq.gz in file /var/lib/cwl/stg113ea33e-4748-4c8e-9095-d20d3af7a78c/WGS_control_AS-844817-LR-64712.yaml at /opt/wtsi-cgp/lib/perl5/PCAP/Bwa.pm line 98" indicates that it is not running in paired-end mode, likely because the two mate files do not follow the pattern of paired-end fastq file names described above.

Example readinfo yaml file (for paired-end)
-------------------------------------------
SM: SRR8551279
READGRPS:
    SRR8551279_fastp_1.fq.gz:
        ID: SRR8551279
        PL: ILLUMINA
        LB: SRR8551279
        PU: SRR8551279
