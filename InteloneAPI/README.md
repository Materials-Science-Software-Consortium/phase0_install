# Intel oneAPI

## 環境設定

高性能なインテルコンパイラが無償で利用できます。
[公式サイト](https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html)から、Base ToolkitとHPC Toolkitをインストールして下さい。

Intel oneAPIは`/opt/intel`（既定値）にインストールされているとして説明します。

ログインの度に（計算実行のみの際にも）下記コマンドを実行すると、環境設定完了です。

```sh
source /opt/intel/oneapi/setvars.sh
```

## コンパイル（二次元版と三次元版共通）

配布物ソースコードには、いくつかのMakefileが付属しています。
それらの中で、`Makefile.asahi_impi`は、Intel製のコンパイラとライブラリ（MKLとMPI）を利用するMakefileですので、oneAPIと相性が良いです。
複数の引数を与えることにより、流用できます。

```sh
make F90="mpiifx -traceback" CC=icx LINK="mpiifx -traceback" MKLHOME="/opt/intel/oneapi/mkl/latest/lib/intel64/" INCLUDE="-I/opt/intel/oneapi/mkl/latest/include/fftw/" -f Makefile.asahi_impi install
```
