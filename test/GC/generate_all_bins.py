#!/usr/bin/python3
import os
import sys
import time
import subprocess
from subprocess import Popen

BINS_DIR = "bins"

compile_cmd_tmp = "nvcc -I. -I../../include -std=c++11 -rdc=true -lcudadevrt -gencode arch=compute_60,code=sm_60 " + \
                  "-D GRID_DIM={} -D BLOCK_DIM={} main.cu graphColoring.cu kernel.{}.cu -o ./bins/gc.{}_{}_{}"

grid_dims  = [4**i for i in range(8)]
block_dims = [4**i for i in range(8)]


def get_compile_cmd(program_name, grid_dim, block_dim):
    cmd = compile_cmd_tmp.format(grid_dim, block_dim, program_name, \
                                  program_name, grid_dim, block_dim)
    print(cmd)
    return cmd

def cpu_count():
    ''' Returns the number of CPUs in the system
    '''
    num = 1
    if sys.platform == 'win32':
        try:
            num = int(os.environ['NUMBER_OF_PROCESSORS'])
        except (ValueError, KeyError):
            pass
    elif sys.platform == 'darwin':
        try:
            num = int(os.popen('sysctl -n hw.ncpu').read())
        except ValueError:
            pass
    else:
        try:
            num = os.sysconf('SC_NPROCESSORS_ONLN')
        except (ValueError, OSError, AttributeError):
            pass

    return num


def exec_commands(cmds, max_task=8):
    ''' Exec commands in parallel in multiple process 
    (as much as we have CPU)
    '''
    if not cmds: return # empty list

    def done(p):
        return p.poll() is not None
    def success(p):
        return p.returncode == 0
    def fail():
        sys.exit(1)

    processes = []
    while True:
        while cmds and len(processes) < max_task:
            task = cmds.pop()
            # print(task)
            # print(list2cmdline(task))
            processes.append(Popen(task, shell=True))

        for p in processes:
            if done(p):
                if success(p):
                    processes.remove(p)
                else:
                    fail()

        if not processes and not cmds:
            break
        else:
            time.sleep(0.05)




if __name__ == '__main__':

    if not os.path.exists(BINS_DIR):
        os.makedirs(BINS_DIR)

    compile_cmds = []

    for grid_dim in grid_dims:
        for block_dim in block_dims:
            compile_cmds += [ get_compile_cmd("tangram", grid_dim, block_dim) ]
            compile_cmds += [ get_compile_cmd("tangram_dynamic", grid_dim, block_dim) ]

    exec_commands(compile_cmds, cpu_count()-2)