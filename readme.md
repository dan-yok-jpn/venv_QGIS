## QGIS 同梱の Python を使用する

&emsp;QGIS には Python が同梱されている。
また、この Python では地理情報用のパッケージ群が参照可能になっている。
さらに、これらのパッケージ内のモジュールがロードするダイナミックリンクライブラリ（DLL ― Python 以外からも呼び出される）が確実に収録されている。<br>
&emsp;したがって、普段使いの Python ではなく、QGIS 同梱の Python を使用すると、パッケージや DLL の管理を気にすることなく（ストレージを浪費することなく）地理情報を扱うプログラムの開発できるようになる。
また、普段使いの Python を有さない QGIS ユーザに開発成果を供与することができるようになる。<br>
&emsp;このようなニーズに対して Python では**仮想環境**を設定する [venv](https://www.python.jp/install/windows/venv.html) が用意されている。<br>
&emsp;以下、QGIS 同梱の Python を使用する仮想環境を自動的に作成する ```set_venv.bat```、その仮想環境内で特定のモジュールを実行する ```test_venv.bat``` について記す。

### set_venv.bat（開発用）

&emsp;```set_venv.bat``` を実行<sup> (注1) </sup>すると以下の処理が行われる。

* QGIS 同梱の Python の登録先を検出<sup> (注2)</sup>
* この Python を使用するための仮想環境を ```.venv``` に設定
* ```requirements.txt``` が存在する場合、これに従って追加が必要なパッケージを ```.venv\Lib\site-packages``` にインストール<sup> (注3)</sup>
* 仮想環境に合わせる VSCode の動作設定を ```.vscode``` に配置 

(注)

1. 管理者権限のコマンドプロンプトの起動に関するメッセージには「はい」で応答
1. QGIS を更新した場合は ```.venv``` と ```.vscode``` を削除して ```set_venv.bat``` を再度実行
2. ここではサンプルとして ```requirements.txt``` に ```geopandas>=1.0.0``` を加えてあるが、手元のマシンではこれを満たすものが QGIS 側にインストール済みなのでパッケージの追加はない

#### ■ 仮想環境の使い方

* 次のコマンドで仮想環境に移行し、プロンプトの先頭に ```(.venv)``` が付される。

    ```
    .venv\Scripts\activate
    ```

* QGIS 同梱の Python を使用して通常通りの開発作業を行う。
* 仮想環境から復帰する場合は次のコマンドを実行する。

    ```
    deactivate
    ```

#### ■ パッケージを追加する場合

&emsp;自作のプログラムで用いるモジュールを含むパッケージ ```package_A``` を追加する<sup> (注4) </sup>場合は**仮想環境内で**以下を実行する。

```
python -m pip install package_A
```

&emsp;上記のコマンドにより ```package_A``` の最新版と最新版が依存するパッケージがインストールされる。
その際、意図しないパッケージ（例えば ```numpy```）がインストールされる場合は、次のように```package_A``` およびこれが依存するパッケージを削除した後、こういった事が生ぜず、プログラムが正常に動作する適当なバージョン ```ver_opt``` を指定して ```package_A``` をインストールし直す<sup> (注5) </sup>。

```bash
python -m pip uninstall package_A
python -m pip uninstall package_B　# package_A が依存
python -m pip uninstall package_C　# package_A が依存
python -m pip uninstall package_D　# package_B が依存
    :
python -m pip install package_A==ver_opt    # バージョン指定
```

&emsp;プログラムを配布する場合は ```requirements.txt```に ```package_A>=ver_opt```を追加する（配布先のサイトパッケージが肥大する場合はダウングレードを検討）。

(注)

4. パッケージの追加は必要最小限にとどめるのが無難。
コーディングに当たっては QGIS に含まれているパッケージ（```python -m pip list``` で確認）を優先的に利用することが肝要
5. 依存関係が複雑で削除するパッケージが不明な場合は、バージョン問題が解決済みの追加パッケージを ```requirements.txt``` に列挙したうえで ```.venv``` と ```.vscode``` を削除して ```set_venv.bat``` を再度実行した後、特定のバージョンの ```package_A``` をインストール 

### test_venv.bat（配布用）

&emsp;```test_venv.bat``` はパッケージの追加が必要なプログラムを（QGIS がインストール済みの）ユーザーに配布する場合のバッチファイルのサンプル。配布時は ```set_venv.bat```、```requirements.txt``` も添える。
初回の実行時およびユーザーが QGIS を更新した時にユーザー側の仮想環境を設定し、パッケージのインストール状況を ```install.log``` に出力する。
配布先のサイトパッケージが肥大するようなケースでは、このログを頼りに、① パッケージのバージョンのダウングレード、② QGIS の更新を要請、の何れかを判断する。<br>
&emsp;```test.bat``` はパッケージの追加を要さないプログラムの配布用のバッチファイルのサンプル。
一時的に用いる環境変数 ```PATH```、```PYTHONHOME``` がセットされる。
このケースでも QGIS 側のパッケージ群のみを用いることに変わりはないので、仮想環境内でプログラムの開発を行うことが望ましい。 