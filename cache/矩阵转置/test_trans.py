"""
使用指南：
  将你的文件命名为 `trans.c`，置于与该脚本相同目录，运行 `python test_trans.py`
  即可生成三个矩阵转置过程的 trace 文件，你可以使用你的 csim 程序解析它们，并
  得到 miss 数据。

  默认情况下，该脚本会相继运行三个转置函数，你也可以通过给予一个参数来选择只运行
  其中的一个，例如 `python test_trans.py 1`：
    0 -- 32x32 Matrix
    1 -- 64x64 Matrix
    2 -- 61x67 Matrix
"""

template = """
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

volatile uint8_t Marker_Start, Marker_End;

static int A[256][256], B[256][256];

int run(int M, int N, int A[N][M], int B[M][N]) {
    int i, j;
    srand(time(NULL));
    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            A[i][j] = rand();
            B[j][i] = rand();
        }
    }
    FILE *marker_fp = fopen(".marker", "w");
    if (NULL == marker_fp) {
        return EXIT_FAILURE;
    }
    fprintf(marker_fp, "%llx %llx", (unsigned long long int) &Marker_Start, (unsigned long long int) &Marker_End);
    fclose(marker_fp);

    /* Do Transpose */
    Marker_Start = 33;
    transpose_${M}x${N}(M, N, A, B);
    Marker_End = 34;

    return EXIT_SUCCESS;
}

int main() {
    return run(${M}, ${N}, A, B);
}
"""

tests = [(32, 32), (64, 64), (61, 67)]


def tuple2str(tt0, tt1):
    return f"{tt0}x{tt1}"


# region arg parser

from sys import argv, exit

if len(argv) == 1:
    pass
elif len(argv) == 2:
    if argv[1] not in ["0", "1", "2"]:
        print("The Argument shall be 0, 1 or 2. Abort!")
        print("  0 -- 32x32 Matrix")
        print("  1 -- 64x64 Matrix")
        print("  2 -- 61x67 Matrix")
        exit(1)
    tests = [tests[int(argv[1])]]
else:
    print("Too many arguments. Abort!")
    print("The Argument shall be 0, 1 or 2:")
    print("  0 -- 32x32 Matrix")
    print("  1 -- 64x64 Matrix")
    print("  2 -- 61x67 Matrix")
    exit(1)

# endregion

# region file check

from pathlib import Path

base_dir = Path('.cache')
submit_src = Path('trans.c')
spawned_src = base_dir / "target.c"
executable = base_dir / "target"
trace_temp = base_dir / "trace.tmp"
trace_marker = Path(".marker")

print("Checking and Preparing the Files ...")

base_dir.mkdir(parents=False, exist_ok=True)
if not submit_src.is_file():
    print("Cannot find the 'trans.c'. Abort!")
    exit(1)
try:
    source = submit_src.read_text()
except:
    print("Cannot read the 'trans.c'. Abort!")
    exit(1)

# endregion

from subprocess import call, TimeoutExpired

for i, test in enumerate(tests, 1):
    print(f"Test ({i} / {len(tests)}): {tuple2str(*test)}")

    trace_final = Path(f"m{tuple2str(*test)}.trace")

    # region Step 01
    print("  Step.01 Compile the code ...")
    spawned_src.write_text(
        source +
        "\n/* =-=-=-=-= */\n\n" +
        template.replace("${M}", str(test[0])).replace("${N}", str(test[1]))
    )
    ret_value = call(
        ["gcc", str(spawned_src), "-O0", "-o", str(executable)],
    )
    if ret_value != 0:
        print("  > Compile Error. Continuing!")
        continue
    # endregion

    # region Step 02
    print("  Step.02 Get the raw trace ...")
    try:
        ret_value = call(
            ["valgrind", "--tool=lackey", "--trace-mem=yes", "--log-fd=1",
             "-v", str(executable)],
            stdout=trace_temp.open("w"),
            timeout=120,
        )
    except TimeoutExpired:
        ret_value = 1
        print("  > Timeout! Maybe you should put all the files in your vm.")

    if 0 != ret_value:
        print("  > Run valgrind failed. Continuing!")
        continue
    # endregion

    # region Step 03
    print("  Step.03 Pick the trace line ...")
    llx = lambda s: int(s, 16)
    marker_start, marker_end = map(llx, trace_marker.read_text().split())
    traces = []
    flag = False
    for buf in trace_temp.read_text().splitlines():
        if not (buf[0] == ' ' and buf[1] in "LMS" and buf[2] == ' '):
            continue
        addr, length = buf[3:].split(",")
        addr = llx(addr)
        if addr == marker_end:
            break
        if flag and addr < 0xffffffff:
            traces.append(buf)
        if addr == marker_start:
            flag = True
    trace_final.write_text("\n".join(traces))
    print(f"  > Generated: {trace_final}")
    # endregion

print("Cleaning ...")
spawned_src.unlink(missing_ok=True)
executable.unlink(missing_ok=True)
trace_marker.unlink(missing_ok=True)
trace_temp.unlink(missing_ok=True)
base_dir.rmdir()
