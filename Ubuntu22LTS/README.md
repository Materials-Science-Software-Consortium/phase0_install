# Ubuntu 22.04LTS

## 概要

Ubuntuの22.04LTSがリリースされました。
その際、gcc（gfortranを含みます）のバージョンが11に上がりました。
このバージョンは変数の型の不一致に厳しくなったため、`phase0_2022.01.tar.gz`付属の`Makefile.Linux_Generic`ではコンパイルできません。
型の不一致に寛容になるオプション`-fallow-argument-mismatch`をつけてコンパイルして下さい。

## 環境設定

必要なソフトウェアとライブラリをインストールします。

```sh
sudo apt install -y make gnuplot-x11 gfortran libopenmpi-dev libfftw3-dev liblapack-dev libopenblas-dev evince
```

## コンパイル

型の不一致に寛容になるオプションを追加した[Makefile](./Makefile.zip)（リンク先画面右下Downloadボタンでzipファイルをダウンロード）を`phase0_2022.01/src_phase`にコピーして使用します。

```sh
cd src_phase
make install
```
