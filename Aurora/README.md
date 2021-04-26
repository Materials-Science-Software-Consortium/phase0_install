# NEC SX-Aurora TSUBASAへのインストール

## 環境設定

コンパイラ（nfortおよびncc）、MPIライブラリ(NEC MPI)および数値計算ライブラリNLCを使用可能とします。

```
$ . /opt/nec/ve/mpi/[version]/bin64/necmpivars.sh
$ . /opt/nec/ve/nlc/[version]/bin/nlcvars.sh mpi
```

## コンパイル

NEC SX-Aurora TSUBASAでは二次元版の使用をお勧めします。二次元版にはNEC SX-Aurora TSUBASA用のMakefileが付属しています。

```
$ cd src_phase
$ make -f Makefile.Aurora install
```
