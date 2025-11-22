# omarchy テーマ自動変更 (systemd版)

`systemd`のタイマー機能を利用して、omarchyのテーマを定期的に自動変更する方法のまとめです。

---

## 概要

この方法では、以下の3つのファイルを作成して連携させます。

1.  **テーマ変更スクリプト (`.sh`)**: 実行されるとテーマを一度だけランダムに変更する。
2.  **サービスユニット (`.service`)**: 上記のスクリプトを実行する役割を持つ。
3.  **タイマーユニット (`.timer`)**: サービスユニットを定期的に起動するタイマー。

---

## 1. テーマ変更スクリプト

ループと待機処理をなくし、実行されるたびに一度だけテーマを変更するシンプルなスクリプトです。

**ファイル名:** `omarchy_theme_changer.sh`
**保存先:** `/home/kei/.local/share/bin/omarchy_theme_changer.sh`

```bash
#!/bin/bash

# omarchyのテーマをランダムに変更するスクリプト
# systemd.timerなどから定期的に実行されることを想定

# --- 設定 ---
# omarchyのコマンドが格納されているディレクトリ
OMARCHY_BIN_DIR="$HOME/.local/share/omarchy/bin"

# --- スクリプト本体 ---

# omarchyのコマンドが存在するかチェック
for cmd in omarchy-theme-set omarchy-theme-list omarchy-theme-current; do
    if ! command -v "$OMARCHY_BIN_DIR/$cmd" &> /dev/null; then
        # エラーメッセージはsystemdのログに出力される
        echo "エラー: omarchyのコマンドが見つかりません: $OMARCHY_BIN_DIR/$cmd" >&2
        exit 1
    fi
done

# 1. 現在のテーマを取得
CURRENT_THEME=$("$OMARCHY_BIN_DIR/omarchy-theme-current")

# 2. 利用可能なテーマのリストから現在のテーマを除外し、ランダムに1つ選ぶ
NEW_THEME=$("$OMARCHY_BIN_DIR/omarchy-theme-list" | grep -v "^${CURRENT_THEME}$" | shuf -n 1)

# 3. 新しいテーマが選ばれた場合のみ設定
if [ -n "$NEW_THEME" ]; then
    "$OMARCHY_BIN_DIR/omarchy-theme-set" "$NEW_THEME"
    echo "omarchyのテーマを「$NEW_THEME」に変更しました。"
else
    echo "警告: 新しいテーマを選択できませんでした。" >&2
    exit 1
fi

exit 0
```

**実行権限の付与:**
スクリプトを保存した後、以下のコマンドで実行権限を与えてください。
```shell
chmod +x /home/kei/.local/share/bin/omarchy_theme_changer.sh
```

---

## 2. systemd サービスユニット (`.service`)

スクリプトを実行するためのサービスユニットです。

**ファイル名:** `omarchy-theme.service`
**保存先:** `/home/kei/.config/systemd/user/omarchy-theme.service`

```ini
[Unit]
Description=Change omarchy theme randomly

[Service]
Type=oneshot
ExecStart=/home/kei/.local/share/bin/omarchy_theme_changer.sh
```

---

## 3. systemd タイマーユニット (`.timer`)

サービスを定期的に起動するためのタイマーユニットです。
`OnUnitActiveSec` の値を変更することで、実行間隔を自由に調整できます。（例: `10min`, `1h`, `45m`など）

**ファイル名:** `omarchy-theme.timer`
**保存先:** `/home/kei/.config/systemd/user/omarchy-theme.timer`

```ini
[Unit]
Description=Run omarchy theme changer periodically

[Timer]
# PC起動1分後に最初の処理を実行
OnBootSec=1min
# その後は30分ごとに実行
OnUnitActiveSec=30min
Unit=omarchy-theme.service

[Install]
WantedBy=timers.target
```

---

## 4. systemdタイマーの有効化と起動

以下のコマンドを実行して、作成したタイマーを有効化し、起動します。

1.  **systemdに新しいユニットを認識させる:**
    ```shell
    systemctl --user daemon-reload
    ```

2.  **タイマーを有効化し、すぐに起動する:**
    (`--now` をつけることで、PC再起動後も有効になり、かつ現在のセッションでも即時起動します)
    ```shell
    systemctl --user enable --now omarchy-theme.timer
    ```

---

## 5. 動作確認

以下のコマンドで、タイマーが正しく設定・実行されているか確認できます。

```shell
systemctl --user list-timers
```

`NEXT` 列に次回の実行時刻、`LEFT` 列に残り時間などが表示されます。
