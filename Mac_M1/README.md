# Mac (Apple Silicon) へのインストール

## 環境設定

[homebrew](https://brew.sh)を利用して、必要なソフトウェアとライブラリをインストールします。

```sh
brew install gcc
brew install open-mpi
brew install fftw
brew install gnuplot
```

## コンパイル

二次元版には、Mac (Apple Silicon) 用のMakefileが付属しています。

```sh
cd src_phase
make -f Makefile.M1Mac install
```
