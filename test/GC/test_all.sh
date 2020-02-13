
NAME=gc
# VERSIONS='tangram_dynamic tangram base aw ab ag'
RUNS=5
SPACE=7        # 4 ** [ 0 ~ $SPACE ]
FILE=$NAME.csv

echo "benchmark, version, runID, gridDim, blockDim, time" > $FILE
if [ -f $NAME.base ]; then
    for r in `seq 1 $RUNS`; do
        echo $NAME, base, $r, 0, 0, `./$NAME.base -o 0` | tee -a $FILE
    done
fi

for i in `seq 0 $SPACE`; do
    for j in `seq 0 $SPACE`; do
        BIN_NAME=./bins/$NAME.tangram_$((4 ** $i))_$((4 ** $j))
        echo $BIN_NAME
        if [ -f $BIN_NAME ]; then
            for r in `seq 1 $RUNS`; do
                echo $NAME, tangram, $r, $((4 ** $i)), $((4 ** $j)), `./$BIN_NAME -o 0` | tee -a $FILE
            done
        fi
    done
done

for i in `seq 0 $SPACE`; do
    for j in `seq 0 $SPACE`; do
        BIN_NAME=./bins/$NAME.tangram_dynamic_$((4 ** $i))_$((4 ** $j))
        echo $BIN_NAME
        if [ -f $BIN_NAME ]; then
            for r in `seq 1 $RUNS`; do
                echo $NAME, tangram_dynamic, $r, $((4 ** $i)), $((4 ** $j)), `./$BIN_NAME -o 0` | tee -a $FILE
            done
        fi
    done
done
