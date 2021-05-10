# WSLへのインストール
## 概要
WSLとは，Windows subsystem for Linuxの略称であり，WindowsにおいてLinux環境を構築する手段の一つです。[VirtualBox](https://www.virtualbox.org/)などの仮想化アプリケーションを用いてLinuxをインストールすることによって同様の環境を構築することは可能ですが，Windows謹製の仕組みであり，よりシームレスにホストOS (Windows)とゲストOS (Linux)を用いることができるようになっています。本稿では，以下のようなことがらについて解説します。

- WSLの有効化およびLinuxのインストール
- PHASE/0をコンパイルするために必要なアプリケーションのインストール
- PHASE/0のインストール

## WSLの有効化およびLinuxのインストール
### WSLを有効にする方法
WSLを有効にする手続きは下記の通りです。

- コントロールパネルから「プログラムと機能」を選択
- 結果得られる画面左の領域の「Windowsの機能の有効化または無効化」を選ぶ
- 結果得られる画面の「Linux用Windowsサブシステム」にチェックが入っていない場合チェックをいれて再起動する

 以上の操作によってWSLが有効になります。

### Ubuntuのインストール
WSLにおいて利用できるLinuxのディストリビューションは複数存在しますが，ここではUbuntuをインストールすることを想定しています。Microsoft Storeアプリを起動し，「検索」にUbuntuと入力すればいくつか候補があらわれます。基本的には最新のものをインストールすればよいでしょう。インストールできれば，「スタート画面」などから実行できるはずです。初回起動時には Installing, this may take a few minutes ...という文字列があらわれ，しばらく待たされます。その後ユーザー名とパスワードの入力を促されます。希望のユーザー名とパスワードを入力します(Windowsのユーザー名やパスワードとは関係なく決められます)。確認を含めパスワードを入力すればコマンドプロンプトがあらわれ，利用可能な状態となります。

## 必要なアプリケーションのインストール
PHASE/0をコンパイルするために必要なアプリケーションのインストールを行います。以下の要領で紺などを実行してみてください。

```
$ sudo apt-get update
$ sudo apt install -y make gcc gfortran libfftw3-dev libopenmpi-dev
```

最初のコマンドによって最初からインストールされているアプリケーションのアップデートが行われます。二つ目のコマンドによって，PHASE/0をコンパイルするために必要なアプリケーションやライブラリー群がインストールされます。makeはビルドツール，gcc, gfortranはCコンパイラーおよびFortranコンパイラー，libfftw3-devはFFTW3というFFTライブラリー，libopenmpi-devはOpenMPIというMPIライブラリーです。

## PHASE/0のインストール
### アーカイブのコピーと解凍
PHASE/0のアーカイブをまずはダウンロードし，分かりやすい場所(たとえばC:\tmpの下など)に配置してください。WindowsのCドライブはWSLにおいては/mnt/c というディレクトリーにマウントされるので，以下の要領でコピーし，解凍することができます。
```
$ cp /mnt/c/tmp/phase0_2020.01.tar.gz .
$ tar -zxvf phase0_2020.01.tar.gz
```

### PHASE/0 コンパイル方法
コンパイルは，通常の一般的なLinuxマシンにおけるPHASE/0のコンパイル方法と同じ方法で行うことができます。FFTライブラリーとしてはFFTW3, LAPACK/BLASはPHASE/0に同梱されているnetlib版を用います。以下，install.shスクリプトを用いて二次元版のPHASE/0をインストールする方法を説明します。コンパイル中Warningが得られるかもしれませんが，動作に支障はありません。
```
$ cd phase0_2020.01
$ ./install.sh
=== PHASE installer ===
 Do you want to install PHASE? (yes/no) [yes]
yes
GenMake ver 1200
Supported platforms
 0) GNU Linux (IA32)
 1) GNU Linux (EM64T/AMD64)
 2) NEC SX Series
 x) Exit
Enter number of your platform. [0]
1
Selected platform: GNU Linux (EM64T/AMD64)
Supported compilers
 0) GNU compiler collection (gfortran)
 1) Intel Fortran compiler
 x) Exit
Enter number of a desired compiler. [0]
⏎
Selected compiler: GNU compiler collection (gfortran)
Supported programming-models
 0) Serial
 1) MPI parallel
 x) Exit
Enter number of a desired programming-model. [0]
1
Selected programming-model: MPI parallel
Supported MPI libraries
 0) Open MPI
 1) SGI MPT
 x) Exit
Enter number of a desired MPI library. [0]
⏎
Selected MPI library: Open MPI
Supported BLAS/LAPACK
 0) Netlib BLAS/LAPACK
 1) Intel Math Kernel Library (MKL)
 x) Exit
Enter number of a desired library. [0]
⏎
Selected BLAS/LAPACK: Netlib BLAS/LAPACK
Supported FFT libraries
 0) Built-in FFT subroutnes
 1) FFTW3 library
 x) Exit
Enter number of a desired library. [0]
1
Selected FFT library: FFTW3 library
Enter FFT library directory. [/usr/local/lib]
/usr/lib
Selected FFT library directory: /usr/lib
Do you want to enable the ESM feature? (yes/no) [yes]
⏎
 Do you want to edit the makefile that has been generated? (yes/no/exit) [no]
⏎
Do you want to make PHASE now? (yes/no) [yes]
⏎
...
...
make[1]: Leaving directory '/home/user/phase0_2020.01/src_phase/EsmPack'
PHASE was successfully installed.
Do you want to check the installed programs? (yes/no) [no]
yes
Checking total-energy calculation.
 Total energy : -7.897015064593 Hartree/cell
 Reference    : -7.897015064593 Hartree/cell
Checking band-energy calculation.
 Valence band maximum : 0.233846 Hartree
 Reference            : 0.233847 Hartree
```

### PHASE/0の実行
以上の作業によって，ホームディレクトリーの下のphase0_2020.01の下のbinというディレクトリーにphaseなどのバイナリーファイルが作成されたはずです。これを実行するコマンドは下記の通り。
```
$ mpiexec -n NP $HOME/phase0_2020.01/bin/phase ne=NE nk=NK
```
mpiexecというコマンドは，MPIアプリケーションを実行するためのコマンドです。NP, NE, NKは実際は整数値を指定します。NPは総並列数，NEはバンド並列数，NKはk点並列数に対応します。

なお，並列計算を実行すると以下のようなWARNINGが得られてしまいます。結果には影響しないようです。
```
WARNING: Linux kernel CMA support was requested via the
btl_vader_single_copy_mechanism MCA variable, but CMA support is
not available due to restrictive ptrace settings.

The vader shared memory BTL will fall back on another single-copy
mechanism if one is available. This may result in lower performance.

  Local host: DESKTOP-MERQRS3
--------------------------------------------------------------------------
[DESKTOP-MERQRS3:17396] 3 more processes have sent help message help-btl-vader.txt / cma-permission-denied
[DESKTOP-MERQRS3:17396] Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
```

## WSL活用Tips
コンパイルし，実行するだけならば前節までの説明で十分ですが，いろいろなアプリケーションをインストールすることによってPHASE/0を便利に利用できるようになります。ここでは，そのようなアプリケーションのインストール方法やWSLの便利な使い方を紹介したいと思います。

### ファイルシステムについて
WindowsからはUbuntuのファイルシステムはネットワークドライブとして認識されるようです。エクスプローラーに```\\wsl$```と入力するとUbuntu-20.04というフォルダーがエクスプローラーに表示されます。ダブルクリックしてUbuntu-20.04にアクセスすると，通常のLinuxのルートディレクトリーのようなフォルダー構成のフォルダー群があらわれます。逆に，Ubuntu側は/mnt/以下にWindowsのドライブがマウントされます。たとえばCドライブは/mnt/c にマウントされます。

- Ubuntuにファイルを取り込む方法：エクスプローラーからUbuntuのディレクトリーにファイルコピーをしてもよいのですが，この方法を用いるとファイルの持ち主がrootになるようで，場合によってはわずらわしいかもしれません。/mnt/c/...からコピーすればこのような問題はありません。
- UbuntuのファイルにWindowsからアクセスする方法：Ubuntuのファイルシステムはエクスプローラーなどからアクセス可能なので，作業スタイルに応じて自由にアクセスすればよいです。

### 可視化用アプリケーションのインストール
以下のコマンドによって，X11やgnuplotなどのアプリケーションをインストールすることができます。
```
$ sudo apt install -y xorg-dev gnuplot-x11 ghostscript evince gedit
```
gnuplot-x11はプロットツールです。PHASE/0に付属するツール群の多くがgnuplot-x11に依存するので，インストールしておくことが推奨されます。gnuplot-x11はX関連の他のアプリもインストールされるためかインストールサイズが大きく，時間も相応にかかりますのでご注意ください。ghostscriptやevinceはEPSファイルを表示するために必要なアプリケーションです。先に言及したPHASE/0に付属するツール群は結果としてEPS形式の画像ファイルを出力することが多いので，やはりインストールしておくことが推奨されます。geditはテキストエディターです。Linuxの標準的なテキストエディターはviやemacsですが，これらになじみがない場合インストールしておくとよいでしょう。

ほかにも好みのアプリがあれば適宜インストールしてください。

### Xウィンドウシステムを用いる方法
WSLで[Xウィンドウシステム](https://ja.wikipedia.org/wiki/X_Window_System)を用いることが可能です。まずは，Windows側にXサーバーを（インストールされていなければ)インストールし，起動します。無償で使えるWindows要のXサーバーとしては，たとえば

- [VcXsrv](https://sourceforge.net/projects/vcxsrv/)
- [MobaXterm](https://mobaxterm.mobatek.net/)（端末ソフトだが起動するとXサーバーもついでに有効になります）

などがあります

また，環境変数DISPLAYに値を設定します。
```
$ export DISPLAY=127.0.0.1:0.0
```
WSL2を用いる場合127.0.0.1ではなくIPアドレスを指定するようにしてください。

### dos.pyスクリプトが動作するようにする方法
PHASE/0付属のdos.pyというPythonスクリプトは[tkinter](https://docs.python.org/ja/3/library/tkinter.html)と[matplotlib](https://matplotlib.org/)がインストールされていないと動作しませんが，Ubuntuのpythonにはどちらもインストールされていないようです。以下のコマンドを実行するとインストールすることができます。
```
$ sudo apt install python3-pip
$ sudo apt-get install python3-tk
$ python3 -m pip install matplotlib
```

また，UbuntuのPythonのコマンドはpythonではなくpython3のようです。dos.pyはpythonというコマンド名であることを想定しているので，dos.pyの先頭の#!/usr/bin/env pythonを#!/usr/bin/env python3と書き換えるか，パスの通っているディレクトリーにpython3へのシンボリックリンクをpythonという名前で作ります。たとえば，下記のようなコマンドを実行します。
```
$ sudo ln -s /usr/bin/python3 /usr/bin/python
```