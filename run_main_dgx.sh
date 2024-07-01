#!/bin/bash -ex
#SBATCH --partition=cpu
#SBATCH --output=slurm/out.%j
#SBATCH --error=slurm/err.%j
#SBATCH --time=5-00:00:00
#SBATCH --ntasks=30
#SBATCH --cpus-per-task=1
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=10

module load dgx
module load openmpi/gcc/64/4.1.5
source activate uniclust

export RUNNER="mpirun --bind-to none"
export COMMON="--threads 16"
export OMP_NUM_THREADS=16
source ./paths.sh
./uniclust_workflow_dgx.sh "${FASTA}" "${BASE}" "${RELEASE}" "${SHORTRELEASE}"

pigz -c "${BASE}/${RELEASE}/uniprot_db.lookup" > "${BASE}/${RELEASE}/uniclust_uniprot_mapping.tsv.gz"
