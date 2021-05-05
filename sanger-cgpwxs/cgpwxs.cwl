#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgpwxs"

label: "CGP WXS analysis flow"

cwlVersion: v1.0

doc: |
    codeRepository, https://github.com/cancerit/dockstore-cgpwxs
    license, https://spdx.org/licenses/AGPL-3.0-only
    author, Keiran Raine
    identifier, https://orcid.org/0000-0002-5634-1539
    email, mailto:cgphelp@sanger.ac.uk
    WARNING: The usual setting for 'exclude' is 'NC_007605,hs37d5,GL%' (human GRCh37/NCBI37). Examples
    are configured to run as quickly as possible.

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-cgpwxs:3.1.7"

hints:
  - class: ResourceRequirement
    coresMin: 1 # works but long, 8 recommended
    ramMin: 15000
    outdirMin: 1000

inputs:
  reference:
    type: File
    doc: "The core reference (fa, fai, dict) as tar.gz"
    inputBinding:
      prefix: -reference
      position: 1
      separate: true

  annot:
    type: File
    doc: "The VAGrENT cache files"
    inputBinding:
      prefix: -annot
      position: 2
      separate: true

  snv_indel:
    type: File
    doc: "Supporting files for SNV and INDEL analysis"
    inputBinding:
      prefix: -snv_indel
      position: 3
      separate: true

  tumour:
    type: File
    secondaryFiles:
    - .bas
    doc: "Tumour alignments file [bam|cram]"
    inputBinding:
      prefix: -tumour
      position: 4
      separate: true

  tumourIdx:
    type: File
    doc: "Tumour alignment file index [bai|csi|crai]"
    inputBinding:
      prefix: -tidx
      position: 5
      separate: true

  normal:
    type: File
    secondaryFiles:
    - .bas
    doc: "Normal alignments file [bam|cram]"
    inputBinding:
      prefix: -normal
      position: 6
      separate: true

  normalIdx:
    type: File
    doc: "Normal alignment file index"
    inputBinding:
      prefix: -nidx
      position: 7
      separate: true

  exclude:
    type: string
    doc: "Contigs to block during indel analysis"
    inputBinding:
      prefix: -exclude
      position: 8
      separate: true
      shellQuote: true

  species:
    type: string?
    doc: "Species to apply if not found in BAM headers"
    default: ''
    inputBinding:
      prefix: -species
      position: 9
      separate: true
      shellQuote: true

  assembly:
    type: string?
    doc: "Assembly to apply if not found in BAM headers"
    default: ''
    inputBinding:
      prefix: -assembly
      position: 10
      separate: true
      shellQuote: true

  cores:
    type: int?
    default: 4
    doc: "Number of CPU cores to use hwere possible. w/o this option the container uses all available cores"
    inputBinding:
        prefix: -cores
        position: 11

outputs:
  run_params:
    type: File
    outputBinding:
      glob: run.params

  result_archive:
    type: File
    outputBinding:
      glob: WXS_*_vs_*.result.tar.gz

  # named like this so can be converted to a secondaryFile set once supported by dockstore cli
  timings:
    type: File
    outputBinding:
      glob:  WXS_*_vs_*.timings.tar.gz

baseCommand: ["/opt/wtsi-cgp/bin/ds-cgpwxs.pl"]

