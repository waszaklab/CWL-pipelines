#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "run-cgprna_htseq-count"

label: "cgpRna htseq-count"

cwlVersion: v1.0

doc: |
  ![build_status](https://quay.io/repository/wtsicgp/cgprna/status)
  A Docker container for the cgpRna mapping flow. See the [cgpRna](https://github.com/cancerit/cgpRna) website for more information.
  Please read the relevant [changes](https://github.com/cancerit/cgpRna/blob/dev/CHANGES.md) when upgrading.
  Parameters for a CWL definition are generally described in a json file, but parameters can be provided on the command line.
  To see the parameters descriptions please run: cwltool --tool-help path_to.cwl
  codeRepository, https://github.com/cancerit/cgpRna
  license, https://spdx.org/licenses/AGPL-3.0-only
  author, Yaobo Xu (cgphelp@sanger.ac.uk)
    
requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/cgprna:2.6.1"

hints:
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4000

inputs:
  sample_bam:
    type: File
    doc: "Input BAM file, in which reads are mapped to a reference genome (NOT transcriptome)."
    inputBinding:
      prefix: --input
      separate: true

  reference:
    type: File
    doc: "A reference GTF file."
    inputBinding:
      prefix: --reference
      separate: true

outputs:
  out_count:
    type: File
    outputBinding:
      glob: rna_htseqcount.gz

baseCommand: ["run-cgprna", "count"]
