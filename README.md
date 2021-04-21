# PHASE/0インストール (2020.01.01)

## ご注意

講習会で利用する程度の基礎的な計算の動作は確認していますが、本格的な大規模計算や、高度な解析機能の全てが正常に動作することまでの確認はできていません。

あらかじめご了承ください。

## ダウンロード

[ダウンロードページ](https://azuma.nims.go.jp/cms1/downloads/software)から

- phase0_2020.01.01.patch
- phase0_2020.01.tar.gz

を入手します。（無償ですが、登録が必要です）

ファイルを展開して、パッチを当てます。

```
$ tar zxf phase0_2020.01.tar.gz
$ cd phase0_2020.01
$ patch -p 1 < ../phase0_2020.01.01.patch
```

## 対応機種・環境

一般的なインストール方法は、ユーザーマニュアルを参照してください。

- Ubuntu20.04LTS (WSL)
- FOCUS
- SX-Aurora TSUBASA
- [Mac (M1)](./Mac_M1/README.md)
