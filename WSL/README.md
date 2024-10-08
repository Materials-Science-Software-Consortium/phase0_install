# WSLへのインストール
## 概要
[WSL](https://docs.microsoft.com/ja-jp/windows/wsl/)とは，Windows subsystem for Linuxの略称であり，WindowsにおいてLinux環境を構築する手段の一つです。[VirtualBox](https://www.virtualbox.org/)などの仮想化アプリケーションを用いてLinuxをインストールすることによって同様の環境を構築することは可能ですが，Windowsに標準で備わっている仕組みのため，よりシームレスにホストOS (Windows)とゲストOS (Linux)を用いることができるようになっています。本稿では，以下のようなことがらについて解説します。

- WSLの有効化およびLinuxのインストール
- PHASE/0をコンパイルするために必要なアプリケーションのインストール
- PHASE/0のインストール

## WSLの有効化およびLinuxのインストール
### WSLを有効にする方法
WSLを有効にする手続きは下記の通りです。

- コントロールパネルから「プログラムと機能」を選択
- 結果得られる画面左の領域の「Windowsの機能の有効化または無効化」を選ぶ
- 結果得られる画面の「Linux用Windowsサブシステム」および「仮想化マシン プラットフォーム」にチェックが入っていない場合チェックをいれて再起動する

 以上の操作によってWSLが有効になります。

### Ubuntuのインストール
WSLにおいて利用できるLinuxのディストリビューションは複数存在しますが，ここではUbuntuをインストールすることを想定しています。Microsoft Storeアプリを起動し，「検索」にUbuntuと入力すればいくつか候補があらわれます。基本的には最新のものをインストールすればよいでしょう。インストールできれば，「スタート画面」などから実行できるはずです。初回起動時には Installing, this may take a few minutes ...という文字列があらわれ，しばらく待たされます。その後ユーザー名とパスワードの入力を促されます。希望のユーザー名とパスワードを入力します(Windowsのユーザー名やパスワードとは関係なく決められます)。確認を含めパスワードを入力すればコマンドプロンプトがあらわれ，利用可能な状態となります。

[MobaXterm](https://mobaxterm.mobatek.net/)というターミナルエミュレーターからUbuntuに接続することもできます。UbuntuをインストールするとMobaXtermの"User sessions"一覧に追加されるので，そこをダブルクリックすることによって接続することできます。この方法によって接続すると，後述のXサーバーの利用のために特別な設定が不要になるなどのメリットがあります。

## 必要なアプリケーションのインストール
### PHASE/0コンパイルするために必要なアプリケーションのインストール
PHASE/0をコンパイルするために必要なアプリケーションのインストールを行います。以下の要領でコマンドを実行してみてください。

```
$ sudo apt-get update
$ sudo apt install -y make gcc gfortran libfftw3-dev libopenmpi-dev
```

最初のコマンドによって最初からインストールされているアプリケーションのアップデートが行われます。二つ目のコマンドによって，PHASE/0をコンパイルするために必要なアプリケーションやライブラリー群がインストールされます。makeはビルドツール，gcc, gfortranはCコンパイラーおよびFortranコンパイラー，libfftw3-devはFFTW3というFFTライブラリー，libopenmpi-devはOpenMPIというMPIライブラリーです。

### 可視化などに必要アプリケーションのインストール
以下のコマンドによって，X11やgnuplotなどのアプリケーションをインストールすることができます。
```
$ sudo apt install -y xorg-dev gnuplot-x11 ghostscript evince gedit
```
gnuplot-x11はプロットツールです。PHASE/0に付属するツール群の多くがgnuplot-x11に依存するので，インストールしておくことが推奨されます。gnuplot-x11はX関連の他のアプリもインストールされるためかインストールサイズが大きく，時間も相応にかかりますのでご注意ください。ghostscriptやevinceはEPSファイルを表示するために必要なアプリケーションです。先に言及したPHASE/0に付属するツール群は結果としてEPS形式の画像ファイルを出力することが多いので，やはりインストールしておくことが推奨されます。geditはテキストエディターです。Linuxの標準的なテキストエディターはviやemacsですが，これらになじみがない場合インストールしておくとよいでしょう。

ほかにも好みのアプリケーションがあれば適宜インストールしてください。

#### Xウィンドウシステムを用いる方法
可視化のアプリケーションを用いる場合，[Xサーバー](https://ja.wikipedia.org/wiki/X_Window_System)が必要となります。まずは，Windows側にXサーバーを(インストールされていなければ)インストールし，起動します。無償で使えるWindows用のXサーバーとしては，たとえば

- [VcXsrv](https://sourceforge.net/projects/vcxsrv/)
- [MobaXterm](https://mobaxterm.mobatek.net/)（ターミナルエミュレーターですが起動するとXサーバーもついでに有効になります）

などがあります

MobaXtermを用いてWSLに接続する場合Xサーバーの利用に特別な設定は要りませんが，MobaXterm以外のターミナルエミュレーターを用いる場合環境変数DISPLAYに値を設定しないとXサーバーを用いることができません。その方法はWSLのバージョン1と2とで異なります。

WSLバージョン1の場合
```
$ export DISPLAY=127.0.0.1:0.0
```

WSLバージョン2の場合
```
$ export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
```

上述のようなコマンドをホームディレクトリーの `.bashrc` ファイルに記述しておけばログインする度に設定されるようになります。また，Xサーバーによっては外部からの接続を許可する設定を施す必要があります。

## PHASE/0のインストール
### アーカイブのコピーと解凍
PHASE/0のアーカイブをまずは[ダウンロードページ](https://azuma.nims.go.jp/cms1/downloads/software)からダウンロードし(無償ですが登録が必要)，分かりやすい場所(たとえば`C:\tmp`の下など)に配置してください。WindowsのCドライブはWSLにおいては`/mnt/c` というディレクトリーにマウントされるので，以下の要領でコピーし，解凍することができます。
```
$ cp /mnt/c/tmp/phase0_2024.01.tar.gz .
$ tar -zxvf phase0_2024.01.tar.gz
```

### PHASE/0 コンパイル方法
PHASE/0のソースコードは`src_phase`ディレクトリーにあるのでまずはここに移ります。
```
$ cd $HOME/phase0_2024.01/src_phase
```

コンパイルは，付属の`Makefile.Linux_generic`を用いて行うことができます。このMakefileを用いるとFFTライブラリーとしてはFFTW3, LAPACK/BLASはPHASE/0に同梱されているnetlib版が利用されます。

コンパイルに用いるコマンドはお使いの`gfortran`のバージョンに依存します。以下のコマンドによってまずは`gfortran`のバージョンを確認します。
```
$ gfortran --version
GNU Fortran (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
この例では`gfortran`のバージョンは11.3.0です。

`gfortran`のバージョンが10未満の場合

```
$ make -f Makefile.Linux_generic install
```

`gfortran`のバージョンが10以上の場合

```
$ make -f Makefile.Linux_generic F90='mpif90 -m64 -fallow-argument-mismatch' install
```
コンパイルの結果得られるバイナリーは`$HOME/phase0_2024.01/bin`の下に配置されます。

### PHASE/0の実行
以上の作業によって`$HOME/phase0_2024.01/bin`というディレクトリーにphaseなどのバイナリーファイルが作成されたはずです。これを実行するコマンドは下記の通り。
```
$ mpiexec -n NP ~/phase0_2024.01/bin/phase ne=NE nk=NK
```
mpiexecというコマンドは，MPIアプリケーションを実行するためのコマンドです。NP, NE, NKは実際は整数値を指定します。NPは総並列数，NEはバンド並列数，NKはk点並列数に対応します。NP = NE x NK という関係が成立している必要があります。

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
WindowsからはUbuntuのファイルシステムはネットワークドライブとして認識されるようです。エクスプローラーに```\\wsl$```と入力するとUbuntu-20.04というフォルダーがエクスプローラーに表示されます。ダブルクリックしてUbuntu-20.04にアクセスすると，通常のLinuxのルートディレクトリーのようなフォルダー構成のフォルダー群があらわれます。逆に，Ubuntu側は`/mnt/`以下にWindowsのドライブがマウントされます。たとえばCドライブは`/mnt/c`にマウントされます。

- Ubuntuにファイルを取り込む方法：エクスプローラーからUbuntuのディレクトリーにファイルコピーをしてもよいのですが，この方法を用いるとファイルの持ち主がrootになるようで，場合によってはわずらわしいかもしれません。`/mnt/c/...`からコピーすればこのような問題はありません。
- UbuntuのファイルにWindowsからアクセスする方法：Ubuntuのファイルシステムはエクスプローラーなどからアクセス可能なので，作業スタイルに応じて自由にアクセスすればよいです。WSLからWindowsアプリケーションを起動することも可能となっているため，たとえばWSLのコマンドプロンプトから`explorer.exe .`というコマンドを実行すると現在いるディレクトリーをエクスプローラーで開くこともできます。

前述のMobaXtermを用いてWSLに接続する場合，付属のsftpクライアントを用いてファイルのやり取りをすることもできます。

### pythonスクリプトについて
PHASE/0にはpythonスクリプトがいくつか同梱されています。ここでは，スクリプトを利用するにあたって気に留めておく必要のある事柄について説明します。
#### pythonスクリプトが動作するようにする方法
> [!NOTE]
> バージョン2024.01以降，シェバン行において指定するPythonコマンドとして`python3`を用いるようになったため，以下の作業を行う必要はなくなりました。

同梱のpythonスクリプトの先頭に`#!/usr/bin/env python`という記述がある場合がありこれらは直接実行できるようになっていますが，UbuntuのPythonコマンドはpythonではなくpython3のようです。そのため，以下のいずれかの対応をしないと実行することができません。

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
$ python3 $HOME/phase0_2024.01/bin/conv.py
```
 
#### dos.pyスクリプトについて
dos.pyというPythonスクリプトは[tkinter](https://docs.python.org/ja/3/library/tkinter.html)と[matplotlib](https://matplotlib.org/)がインストールされていないと動作しませんが，Ubuntuのpythonにはどちらも標準ではインストールされていないようです。以下のコマンドを実行するとインストールすることができます。

```
$ sudo apt-get install python3-pip
$ sudo apt-get install python3-tk
$ python3 -m pip install matplotlib
```
