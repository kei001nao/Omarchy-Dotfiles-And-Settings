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
