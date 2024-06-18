# 富岳へのインストール

富岳では、大規模並列に適した三次元並列版を利用します。

## FFTWを使う準備

PHASE/0は、高速Fourier変換に[FFTW](https://fftw.org/)を利用します。
SPACKを使って、プリインストールされているFFTWを利用可能にします。

```sh
. /vol0004/apps/oss/spack/share/spack/setup-env.sh
spack load fujitsu-fftw
```

## コンパイル：電子状態計算ソルバーphase.3d, epsmain.3d

富岳用のMakefileが付属しています。

```sh
cd src_phase_3d
make -f Makefile.Fugaku install
```

コンパイルには時間を要します。
（並列makeには対応していません。）
生成された実行形式ファイルは、`bin`ディレクトリにあります。

## ジョブ投入スクリプト例

計算実行のためのスクリプト例を紹介します。
（小規模並列；練習用）

```sh
#!/bin/bash
#PJM -L "node=12"
#PJM -L "rscgrp=small"
#PJM -L "elapse=1:00:00"
#PJM --mpi "max-proc-per-node=12"
#PJM -g hpXXXXXX
#PJM -s

export PLE_MPI_STD_EMPTYFILE=off
export OMP_NUM_THREADS=4

mpiexec PATH_TO_PHASE0/bin/phase.3d ne=4 nk=1 ng=36
```

`node=12`で、12ノード利用を指定します。
`max-proc-per-node=12`で、1ノードあたりMPIプロセスを12個起動します。
総MPI並列数は144です。
これを、バンド並列4とG並列36に分割して並列実行します。
また、1ノードあたり48コア搭載していますので、スレッド並列数に4を指定します（`OMP_NUM_THREADS=4`）。

計算課題を指定します。

```sh
#PJM -g hpXXXXXX
```

## 計算実行

`pjsub`コマンドで、ジョブ投入します。

```sh
pjsub phase0.sh
```
