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
`2025`版から、oneAPI用の`Makefile.impi`が添付されています。

```sh
make -f Makefile.impi install
```
