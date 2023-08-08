# WSLへのインストール
## 概要
[WSL](https://docs.microsoft.com/ja-jp/windows/wsl/)とは，Windows subsystem for Linuxの略称であり，WindowsにおいてLinux環境を構築する手段の一つです。[VirtualBox](https://www.virtualbox.org/)などの仮想化アプリケーションを用いてLinuxをインストールすることによって同様の環境を構築することは可能ですが，Windows謹製の仕組みであり，よりシームレスにホストOS (Windows)とゲストOS (Linux)を用いることができるようになっています。本稿では，以下のようなことがらについて解説します。

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
PHASE/0をコンパイルするために必要なアプリケーションのインストールを行います。以下の要領でコマンドを実行してみてください。

```
$ sudo apt-get update
$ sudo apt install -y make gcc gfortran libfftw3-dev libopenmpi-dev
```

最初のコマンドによって最初からインストールされているアプリケーションのアップデートが行われます。二つ目のコマンドによって，PHASE/0をコンパイルするために必要なアプリケーションやライブラリー群がインストールされます。makeはビルドツール，gcc, gfortranはCコンパイラーおよびFortranコンパイラー，libfftw3-devはFFTW3というFFTライブラリー，libopenmpi-devはOpenMPIというMPIライブラリーです。

## PHASE/0のインストール
### アーカイブのコピーと解凍
PHASE/0のアーカイブをまずは[ダウンロードページ](https://azuma.nims.go.jp/cms1/downloads/software)からダウンロードし(無償ですが登録が必要)，分かりやすい場所(たとえばC:\tmpの下など)に配置してください。WindowsのCドライブはWSLにおいては/mnt/c というディレクトリーにマウントされるので，以下の要領でコピーし，解凍することができます。
```
$ cp /mnt/c/tmp/phase0_2023.01.tar.gz .
$ tar -zxvf phase0_2023.01.tar.gz
```

### PHASE/0 コンパイル方法
コンパイルは，付属のMakefile.Linux\_genericを用いて行うことができます。このMakefileを用いるとFFTライブラリーとしてはFFTW3, LAPACK/BLASはPHASE/0に同梱されているnetlib版が利用されます。
ただし，比較的新しい (バージョン10以降) gfortranを用いる場合，付属のMakefile.Linux\_genericではコンパイルすることができません。以下の箇所
```
F90 = mpif90 -m64
```
に
`-fallow-argument-mismatch`を加えます。
お使いのgfortranのバージョンにあわせたMakefile.Linux_genericを編集ができたら
```
make -f Makefile.Linux_generic install
```
というコマンドを実行することによってコンパイルすることができます。

### PHASE/0の実行
以上の作業によって，ホームディレクトリーの下のphase0\_2023.01の下のbinというディレクトリーにphaseなどのバイナリーファイルが作成されたはずです。これを実行するコマンドは下記の通り。
```
$ mpiexec -n NP $HOME/phase0_2023.01/bin/phase ne=NE nk=NK
```
mpiexecというコマンドは，MPIアプリケーションを実行するためのコマンドです。NP, NE, NKは実際は整数値を指定します。NPは総並列数，NEはバンド並列数，NKはk点並列数に対応します。

なお，後述のWSL2を用いない場合並列計算を実行すると以下のようなWARNINGが得られてしまいます。結果には影響しないようです。
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

### WSL2
WSLには多くの改善がなされたバージョン，[WSL2](https://docs.microsoft.com/ja-jp/windows/wsl/compare-versions)が存在します。機能の比較などを確認し，有用と判断されたのであれば切り替えるとよいでしょう。

WSL2に切り替えるためには，まずはインストールされているLinuxディストリビューションを調べます。コマンドプロンプトかPowershellを起動し，次のようなコマンドを実行してみてください。
```
C:\Users\user> wsl --list --verbose
```
以下のような結果が得られるはずです。
```
  NAME            STATE           VERSION
* Ubuntu-20.04    Running         1
```
NAMEカラムの文字列がLinuxディストリビューション名，VERSIONカラムの文字列がWSLのバージョンです。上述の例のUbuntu-20.04をWSL2で動作するようにするためには以下のようなコマンドを実行します。
```
C:Users\user> wsl --set-version Ubuntu-20.04 2
```
場合によっては時間がかかるかもしれませんが，このコマンドが正常終了すればWSL2に切り替わっているはずです。再度```wsl --list --verbose```を実行し，確認してみましょう。

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

ほかにも好みのアプリケーションがあれば適宜インストールしてください。

### Xウィンドウシステムを用いる方法
WSLで[Xウィンドウシステム](https://ja.wikipedia.org/wiki/X_Window_System)を用いることが可能です。まずは，Windows側にXサーバーを（インストールされていなければ)インストールし，起動します。無償で使えるWindows要のXサーバーとしては，たとえば

- [VcXsrv](https://sourceforge.net/projects/vcxsrv/)
- [MobaXterm](https://mobaxterm.mobatek.net/)（端末ソフトだが起動するとXサーバーもついでに有効になります）

などがあります

また，環境変数DISPLAYに値を設定します。その方法はWSLのバージョン1と2とで異なります。

WSLバージョン1の場合
```
$ export DISPLAY=127.0.0.1:0.0
```

WSLバージョン2の場合
```
$ export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
```

上述のようなコマンドをホームディレクトリーの `.bashrc` ファイルに記述しておけばログインする度に設定されるようになります。

### pythonスクリプトが動作するようにする方法
PHASE/0にはpythonスクリプトがいくつか同梱されています。これらは先頭に`#!/usr/bin/env python`という記述がある場合がありこれらは直接実行できるようになっていますが，UbuntuのPythonコマンドはpythonではなくpython3のようです。そのため，以下のいずれかの対応をしないと実行することができません。
- 先頭の`#!/usr/bin/env python`を`#!/usr/bin/env python3`と書き換える
- パスが通っているディレクトリーにpython3へのシンボリックリンクをpythonという名前で作る
```
$ sudo ln -s /usr/bin/python3 /usr/bin/python
```
- python-is-python3 をインストールすることによってPythonのコマンドをpythonに変更する
```
$ sudo apt-get install python-is-python3
```
- python3の引数としてPythonスクリプトを実行する
```
$ python3 $HOME/phase0_2023.01/bin/conv.py
```
 
#### dos.pyスクリプトが利用できるようにする方法
上記に加え，dos.pyというPythonスクリプトは[tkinter](https://docs.python.org/ja/3/library/tkinter.html)と[matplotlib](https://matplotlib.org/)がインストールされていないと動作しませんが，Ubuntuのpythonにはどちらもインストールされていないようです。以下のコマンドを実行するとインストールすることができます。

```
$ sudo apt-get install python3-pip
$ sudo apt-get install python3-tk
$ python3 -m pip install matplotlib
```

