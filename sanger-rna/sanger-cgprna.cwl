#!/usr/bin/env cwl-runner

class: Workflow

id: "multi-lane-sample-workflow"

label: "workflow to generate mapping stats and gene counts"

cwlVersion: v1.0

doc: |
  A workflow to generate mapping stats and gene counts from RNA-seq data using cgpRna container. See the [cgpRna](https://github.com/cancerit/cgpRna) website for more information.
  codeRepository, https://github.com/cancerit/cgpRna
  license, https://spdx.org/licenses/AGPL-3.0
  author, Yaobo Xu (mailto:yx2@sanger.ac.uk)

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:

#  raw_reads:
#    doc: "RAW read input, can be BAM files or pairs of FastQ files (optionally gzip compressed). Each element of this array will be treated as one read group in the aligned BAM file. Within each element, only either BAM files or FastQ files are allowed."
#    type:
#      type: array
#      items:
#        type: array
#        items: File

  raw_reads:
    doc: "RAW read input, can be BAM files or pairs of FastQ files (optionally gzip compressed)"
    type: array
    items: File

  map_reference:
    type: File
    doc: "The core STAR reference and a GTF file bundled in a tar.gz."

  sample_name:
    type: string
    doc: "Sample name, which will used to prefix output file names and SM tag in the BAM file header."
    default: ''

  stats_reference:
    type: File
    doc: "The reference files bundled in a tar.gz."

  count_reference:
    type: File
    doc: "A reference GTF file."

  bigwig_reference:
    type: File
    doc: "FASTA file of a reference file, which the input BAM file was mapped to."
    secondaryFiles:
    - .fai

  bigwig_threads:
    type: int?
    default: 1
    doc: "Number of threads to use for generating bigwig."

  map_threads:
    type: int?
    default: 1
    doc: "Number of threads to use for each mapping process."

  merge_threads:
    type: int?
    default: 1
    doc: "Number of threads to use for merging step."

    #  rg_id_tags:
    #    type:
    #      type: array
    #      items: ["null", string]
    #    doc: "Readgroup ID tag values. It should have one value for each group of input raw files. Use empty string to use defaults or existing RG ID in the input BAM. It only uses the RG ID value in the first BAM file of a group."
    #
    #  lb_tags:
    #    type:
    #      type: array
    #      items: ["null", string]
    #    doc: "Sequencing library tag values in the output BAM header. It should have one value for each group of input raw files. Use empty string to set it to none or existing LB tag in the input BAM. It only uses the LB tag value in the first BAM file of a group."
    #
    #  ds_tags:
    #    type:
    #      type: array
    #      items: ["null", string]
    #    doc: "Description tag value in the output BAM header. It should have one value for each group of input raw files. Use empty string to set it to none or existing DS tag in the input BAM. It only uses the DS tag value in the first BAM file of a group."
    #
    #  pl_tags:
    #    type:
    #      type: array
    #      items: ["null", string]
    #    doc: "Platform tag value in the output BAM header. It should have one value for each group of input raw files. Use empty string to set it to none or existing PL tag in the input BAM. It only uses the PL tag value in the first BAM file of a group."
    #
    #  pu_tags:
    #    type:
    #      type: array
    #      items: ["null", string]
    #    doc: "Platform unit tag value in the output BAM header. It should have one value for each group of input raw files. Use empty string to set it to none or existing PU tag in the input BAM. It only uses the PU tag value in the first BAM file of a group."


  rg_id_tag:
    type: string?
    default: "null"
    doc: "Readgroup ID tag values. Use empty string to use defaults or existing RG ID in the input BAM."

  lb_tag:
    type: string?
    default: "null"
    doc: "Sequencing library tag values in the output BAM header. Use empty string to set it to none or existing LB tag in the input BAM."

  ds_tag:
    type: string?
    default: "null"
    doc: "Description tag value in the output BAM header. Use empty string to set it to none or existing DS tag in the input BAM."

  pl_tag:
    type: string?
    default: "null"
    doc: "Platform tag value in the output BAM header. Use empty string to set it to none or existing PL tag in the input BAM."

  pu_tag:
    type: string?
    default: "null"
    doc: "Platform unit tag value in the output BAM header. Use empty string to set it to none or existing PU tag in the input BAM."

outputs:
  dup_marked_bam:
    type: File
    outputSource: merge/dup_marked_merged_bam

  dup_marked_bam_md5:
    type: File
    outputSource: merge/dup_marked_bam_md5

  dup_marked_bam_dup_met:
    type: File
    outputSource: merge/dup_marked_bam_dup_met

  transcriptome_lane_bams:
    type: File[]
    outputSource: map_and_stats/transcriptome_bam

  dup_marked_lane_bam_dup_mets:
    type: File[]
    outputSource: map_and_stats/dup_marked_bam_dup_met

  rna_bas_files:
    type: File[]
    outputSource: map_and_stats/rna_bas

  gene_cover_pngs:
    type: File[]
    outputSource: map_and_stats/gene_cover_png

  gene_body_coverage_rscripts:
    type: File[]
    outputSource: map_and_stats/gene_body_coverage_rscript

  gene_body_coverage_txts:
    type: File[]
    outputSource: map_and_stats/gene_body_coverage_txt

  gene_body_coverage_updated_rscripts:
    type: File[]
    outputSource: map_and_stats/gene_body_coverage_updated_rscript

  read_dists:
    type: File[]
    outputSource: map_and_stats/read_dist

  out_bw:
    type: File
    outputSource: bigwig/out_bw

  out_count:
    type: File
    outputSource: count/out_count

steps:
  map_and_stats:
    in:
      raw_reads:
        source: raw_reads
      map_reference:
        source: map_reference
      sample_name:
        source: sample_name
      stats_reference:
        source: stats_reference
      map_threads:
        source: map_threads
      rg_id_tag:
        source: rg_id_tag
      lb_tag:
        source: lb_tag
      ds_tag:
        source: ds_tag
      pl_tag:
        source: pl_tag
      pu_tag:
        source: pu_tag
    out: [dup_marked_bam, dup_marked_bam_dup_met, transcriptome_bam, rna_bas, gene_cover_png, gene_body_coverage_rscript, gene_body_coverage_txt, gene_body_coverage_updated_rscript, read_dist]
#    scatter: [raw_reads, rg_id_tag, lb_tag, ds_tag, pl_tag, pu_tag]
#    scatterMethod: dotproduct
    run: tools/lane_map_and_stats.cwl

  merge:
    in:
      sorted_bams:
        source: map_and_stats/dup_marked_bam
      threads:
        source: merge_threads
      out_bam_name:
        source: sample_name
        valueFrom: $(self).bam
      out_bam_index_name:
        source: sample_name
        valueFrom: $(self).bam.bai
      md5_file_name:
        source: sample_name
        valueFrom: $(self).bam.md5
      dup_met_file_name:
        source: sample_name
        valueFrom: $(self).bam.met
    out: [dup_marked_merged_bam, dup_marked_bam_dup_met, dup_marked_bam_md5]
    run: tools/merge_and_mark_dups.cwl

  bigwig:
    in:
      sample_bam:
        source: merge/dup_marked_merged_bam
      reference:
        source: bigwig_reference
      threads:
        source: bigwig_threads
    out: [out_bw]
    run: tools/run-cgprna_bigwig.cwl

  count:
    in:
      sample_bam:
        source: merge/dup_marked_merged_bam
      reference:
        source: count_reference
    out: [out_count]
    run: tools/run-cgprna_htseq-count.cwl
