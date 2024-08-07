# FOCUSスパコン

## 概要

公益財団法人計算科学振興財団様が運営する[FOCUSスパコン](https://www.j-focus.or.jp/focus/)でも、PHASE/0を利用できます。

> FOCUSスパコンは、スパコン利用企業層の拡大を目的に整備された産業利用向けの公的スーパーコンピュータです。

ログインサーバーを経由して、フロントエンドに接続してから、コンパイルや計算ジョブ投入などを行います。

```sh
ssh ff
```

`sftp`などでファイル転送する際には、ログインサーバーに接続して操作します。
ログインサーバーとフロントエンドはファイル共有されています。

## コンパイル

かつては`module`コマンドでコンパイル環境を整えていましたが、令和6年春のOS入れ替え（CentOSからRockyへ）と前後して、コンパイラのライセンスが取得できなくなってしまいました。

```txt
ifort: エラー #10052: FLEXlm ライセンスをチェックアウトできませんでした。
```

oneAPIがあるので、そちらを使います。

```sh
source /home1/share/opt/intel-2023.0.0/setvars.sh
```

[oneAPI](../InteloneAPI/README.md)の説明が参考になりますが、インストール（ライブラリが存在する）ディレクトリなどが異なるので、実行オプションは少々異なります。
`src_phase` （もしくは`src_phase_3d`）ディレクトリにて、次のようにmakeコマンドを実行します。

```sh
make CC=icx MKLHOME="/home1/share/opt/intel-2023.0.0/mkl/latest/lib/intel64/" -f Makefile.asahi_impi install
```

コンパイルされた実行形式ファイルは、`phase0_2024.01/bin/`ディレクトリにコピーされます。

## 計算実行

FOCUSスパコンに限らず、他の人とシェアして利用する計算機では、計算実行にジョブ管理システムを使用することが一般的です。
世の中には数多のジョブ管理システムが実在しますが、FOCUSでは[Slurm](https://slurm.schedmd.com/)が採用されています。

PHASE/0を実行するためのサンプルスクリプトを用意しました。

[実行スクリプト（サンプル）](./phase0.sh)

- Aシステムを利用します（24時間キュー）。

```sh
#SBATCH -p a024h
```

- 実行時間は10分に制限されています。

```sh
#SBATCH -t 0:10:00
```

制限時間を超えると、計算は強制的に終了させられてしまいますのでご注意ください。

- 並列実行環境を整えます。
コンパイル時の設定に合わせてください。

```sh
source /home1/share/opt/intel-2023.0.0/setvars.sh
```

- コンパイル済みのPHASE/0実行形式ファイルを指定します。

```sh
PHASE=~/phase0_2024.01/bin/phase
```

- 計算を実行するコマンドです。

```sh
mpirun -n 12 $PHASE #ne=1 nk=12
```

このスクリプトを`キュー`に登録（ジョブ投入）すると、計算資源が利用可能な時に（計算資源に空きがあれば直ちに）実行されます。

```sh
sbatch phase0.sh
```

### 並列性能確認：小規模計算低並列数向け

`samples/basic/Si8`を使ってテスト計算を実行します。
一般的なパソコンが搭載しているCPUコア数は4程度ですが、スパコンは多くのコアを搭載しています。
テストに利用するAシステムは（もはや最新機種ではありませんが）各ノードに12コア搭載されていますので、1ノードの利用でも12並列するのが良さそうです。

並列計算では、計算負荷を分けやすい単位で分割して、各プロセッサ（コア）に割り当てます。
（二次元版の）PHASE/0では、**k点数**と**バンド数**が分割の単位です。
`Si8`例題は、総k点数64、バンド数20です。
これを二通りの分割方法で並列実行しました。

- k点のみ12並列　(ne=1 nk=12)
- k点4並列、バンド3並列 (ne=3, nk=4)：分割方法を指定しない場合の規定値

一般には、k点並列の方が並列効率が高い傾向があります。
とはいうものの、特に大規模系ではk点が少なくなる傾向があり、k点数以上にはk点での並列はできません。
`Si8`はk点数が十分にありますが、k点数64が並列数12の倍数でなけれは効率が低下します。
これをk点並列数12で計算すると、並列起動される12プロセスの内、4プロセスにk点6個分の計算が、残りの8プロセスにはk点5個分の計算がが割り当てられます(6x4+5x8=64)。
後者8プロセスは、前者4プロセスよりも担当分の計算を早く終えますが、繰り返し計算途中に全体の計算結果を集計する際に待たされます。
結局、各プロセスがk点6個分の処理をする計算速度で実行されます。

PHASE/0は並列の分割数を指定しない場合、k点数と総並列数の最大公約数がk点並列数に設定されます；`Si8`を12並列実行するとk点並列数は4です。
上記のようなk点の余りは発生しません。

k点並列は高い並列性能が期待できるのですが単独では実用性が乏しく、バンド並列を併用します。
原子数が多い大規模系では、価電子数が多いことに伴ってバンド数が多くなり、分割に困ることはありません。
`Si8`をk点4並列、バンド3並列で実行すると、全てのプロセスが平等にk点16個分の計算を担当します(16x4=64)。
そして各k点の計算は、3個のプロセスが協力して実行します。
20バンドの計算をできるだけ均等になるように三分割しますので、3つのプロセスが担当するバンド数は、7, 7, 6です。
`Si8`のような簡単なサンプルではバンド数の**余り**が目立ちますが、バンド数が多くなれば余りの影響は小さくなります。

以上の説明からでは、二通りの並列実行のどちらが適切なのか予想することは困難です。
実行してみると、k点のみ12並列が約17秒、k点4並列バンド3並列が約21秒でした。

今回は簡単なテスト計算でしたので大きな差を生じませんが、大規模な計算では、実行のさせ方（三次元並列版`src_phase_3d`の利用を含みます）で効率に無視できない差を生じる場合があります。
長時間の計算の前には、効率の良い並列方法を確認することをお勧めします。
