# M1 Macへのインストール

## 環境設定

[homebrew](https://brew.sh)を利用して、必要なソフトウェアとライブラリをインストールします。

```
$ brew install gcc
$ brew install open-mpi
$ brew install fftw
$ brew install gnuplot
```

## コンパイル

二次元版には、M1 Mac用のMakefileが付属しています。

```
$ cd src_phase
$ make -f Makefile.M1Mac install
```