#!/usr/bin/python3

import sys
from scipy.stats.mstats import gmean

def is_float(input):
    try:
        num = float(input)
    except ValueError:
        return False
    return True

if __name__ == '__main__':
    if len(sys.argv) < 2:
        exit(0)
    res_file = open(sys.argv[1])
    results = res_file.readlines()[1:]
    output = open("results_"+sys.argv[1], "w")

    prev_test = None
    exec_time = []

    output.write("benchmark, version, gridDim, blockDim, time\n")

    for res in results:
        benchmark, version, runID, gridDim, blockDim, time = \
            [ e.strip() for e in res.split(",") ]
        if is_float(time):
            test = (benchmark, version, gridDim, blockDim)
            if test == prev_test or prev_test == None:
                exec_time += [float(time)]
            else:
                if len(exec_time) > 0: 
                    # print(exec_time)
                    final_time = gmean(exec_time)
                    output.write(", ".join(prev_test) + ", " \
                        + str(final_time) + "\n")

                exec_time = []



            prev_test = test

    final_time = gmean(exec_time)
    output.write(", ".join(prev_test) + ", " + str(final_time))

    res_file.close()
    output.close()
