echo "Start: $(date)"
echo "cwd: $(pwd)"

# mpiexec -n 16 ~/projects/raccoon/raccoon-opt r_i_pre=1 l_j_pre=1 r_i=1 l_j=2 -i elasticity_restart.i --color off > log1_2.txt 2>&1
mpiexec -n 16 ~/projects/raccoon/raccoon-opt r_i_pre=1 l_j_pre=1 r_i=1 l_j=2 -i elasticity_restart.i

for ((i=2; i<=400; i++)); do
  for j in 1 2; do
    if [[ $j -eq 1 ]]; then
      i_pre=$((i - 1))
      j_pre=2
    else
      i_pre=$i
      j_pre=1
    fi
    echo "Cycle ${i}, loading section ${j}:"
    # mpiexec -n 16 ~/projects/raccoon/raccoon-opt r_i_pre=${i_pre} l_j_pre=${j_pre} r_i=${i} l_j=${j} -i elasticity_restart.i --color off > log${i}_${j}.txt 2>&1
    mpiexec -n 16 ~/projects/raccoon/raccoon-opt r_i_pre=${i_pre} l_j_pre=${j_pre} r_i=${i} l_j=${j} -i elasticity_restart.i
  done
done

echo "End: $(date)"
