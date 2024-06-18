# Mac (Apple Silicon) へのインストール

## 環境設定

[homebrew](https://brew.sh)を利用して、必要なソフトウェアとライブラリをインストールします。

```sh
brew install gcc
brew install open-mpi
brew install fftw
brew install gnuplot
```

## コンパイル：電子状態計算ソルバーphase, ekcal, epsmain

Mac (Apple Silicon) 用のMakefileが付属しています。

```sh
cd src_phase
make -f Makefile.M1Mac install
```

生成された実行形式ファイルは、`bin`ディレクトリにあります。

## コンパイル：仕事関数解析プログラムworkfunc

変数`F90`を指定して、`make`コマンドを実行します。

```sh
cd src_workfunc
F90="gfortran -fallow-argument-mismatch" make install
```

生成された実行形式ファイル`workfunc`も、`bin`ディレクトリにあります。
