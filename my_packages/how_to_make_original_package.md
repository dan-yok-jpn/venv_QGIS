## パッケージの自作・配布

&emsp;このディレクトリ以下の構成は次のようになっている。
説明用の最低限のサンプルなので、実際に合わせて変更されたい。

```
.
│  makefile
│  how_to_make_original_package.md
│  setup.py
│  
└─package_1
        module_1.py
        module_2.py
        __init__.py
```

&emsp;```package_1``` を ```import package_1``` で参照できるようにするには以下を実行する。

1. ```make build``` を実行
1. ```make install``` を実行して ```package_1``` を ```.venv\Lib\site-packages``` にインストール
1. ```package_1``` を配布する場合は ```dist\package_1-0.1.0-py3-none-any.whl``` を ```requirements.txt``` と同じディレクトリにコピーし、```requirements.txt``` に ```package_1-0.1.0-py3-none-any.whl``` を加える
1. 必要があれば ```make clean``` を実行