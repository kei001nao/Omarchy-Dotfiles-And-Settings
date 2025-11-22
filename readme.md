# Omarchy カスタマイズ（日本語対応）

---

## **0. アップデート**

```bash
sudo pacman -Syu
または、Omarchyメニュー（SUPER+Alt+Space）から [Update]→[Omarchy]
```

---

## **1. Firefoxインストール**

```bash
sudo pacman -S firefox firefox-i18n-ja
```

---

## **2. yayインストール**

Omarchyはインストール済みなので、必要なし

```bash
`sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

---

## **3. paruインストール**

```bash
yay -S paru
```

以降、AURパッケージインストールは、`yay`、`paru` どちらでも良い

---

## **4. いろいろインストール**

**ファイルマネージャー**
 GUI: `thunar` / TUI: `yazi`

**テキストエディター**
 GUI: `kate` / TUI: `nano` (NeoVimはインストール済み)

**日本語入力メソッド**`fcitx5`, `mozc`

**AI**`gemini-cli`

**その他**

Hyprland プラグインで必要なもの：`cmake` `cpio` `meson`

```bash
sudo pacman -S thunar file-roller gvfs tumbler poppler-glib thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-shares-plugin thunar-volman kate nano yazi unarchiver 7zip resvg cmake cpio meson fcitx5-im fcitx5-mozc npm nodejs
```

```bash
npm install -g @google/gemini-cli
```

thunarにGoogle Driveを表示させるツール
`tema`（Omarchy用のWallpaper Selector）

```bash
yay -S gnome-control-center gvfs-google tema-git
```

**thunarにGoogle Driveを表示させる方法：**

Gnome Control Center起動

```bash
env XDG_CURRENT_DESKTOP=GNOME gnome-control-center --verbose
```

Online Account で google を選んでサインインする
アクセスの許可をした後、thunar の Devices に Googleアカウント名のツリーが追加されていることを確認

---

## **5. Hyprland Plugins**

公式プラグインの`hyprexpo`と`hyprscrolling`をインストール

1. **アップデート:**
    
    ```bash
    hyprpm update
    ```
    
2. **インストール＆有効化:**
    
    ```bash
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprexpo
    hyprpm enable hyprscrolling
    ```
    

※ hyprlan.conf などに以下の記述を忘れないこと

```
exec-once = hyprpm reload -n
```

※ プラグインの記述は、プラグインの公式サイトを参照

---

## **6. 仮想マシン (QEMU/KVM)**

参照：[https://note.com/dreamy_clam206/n/n0dfbb225652e](https://note.com/dreamy_clam206/n/n0dfbb225652e)
※ hyprlockで正常動作しなかったので、最終的にはアンインストールした

1. **インストール:**
    
    ```
    sudo pacman -S qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm tuned ntfs-3g nftables bridge-utils openbsd-netcat libguestfs
    ```
    
    ★libosinfo iptables は入れない（すでに入っている）
    　ebtablesと競合する可能性あり
    
    自分をグループ libvirt, kvm に追加
    
    ```
    sudo usermod -aG libvirt,kvm $(whoami)
    ```
    
    もしグループがなかったら、追加する
    
    ```
    newgrp libvirt
    ```
    
    設定が終わったら、Reboot
    
2. **サービス起動:**
    
    ```
    sudo systemctl enable --now libvirtd.service
    ```
    
3. **ネットワークの確認＆NAT起動:**
特にWi-Fiの場合は、要確認
    1. ネットワーク確認
        
        ```
        sudo virsh net-list --all
        ```
        
    2. Wi-Fi (NAT) 起動
        
        ```
        sudo virsh net-start default
        sudo virsh net-autostart default
        ```
        
    
    このようになる
    
    ```
    ⋊> ~ sudo virsh net-list --all
    Name   State   Autostart  Persistent
    \----------------------------------------------
     default  inactive  no     yes
    
    ⋊> ~ sudo virsh net-start default
    Network default started
    
    ⋊> ~ sudo virsh net-autostart default
    Network default marked as autostarted
    
    ⋊> ~ sudo virsh net-list --all
     Name   State  Autostart  Persistent
    \--------------------------------------------
     default  active  yes     yes
    ```
    
    defaultのactive がともに yes になっていればOK
    
4. **iptableの確認**
network.confの修正
    
    ```
    sudo nano /etc/libvirt/network.conf
    ```
    
    修正：　firewall_backend = “iptables”
    
    最後の行をコメントアウト・修正する
    
5. **最終確認**
    
    ```
    sudo virt-host-validate qemu
    ```
    
    →Reboot
    
6. **Virtual Machine Manager 起動**　（virt-manager）
7. **ゲストOSインストール**
8. **ゲスト側インストール**（Arch系）
    
    ```
    sudo pacman -S spice-vdagent
    sudo systemctl enable spice-vdagentd.service
    sudo systemctl start spice-vdagentd.service
    ```
    
9. **ホスト側 virt-manager 設定**
Dislpay Spice　Type : Spice server　Listen Type : None
Video　Model: Virtio
10. **ゲスト側 hyprland設定**
    1. モニタースペック確認
        
        ```
        htprctl monitors
        ```
        
    2. monitor.congなどの修正
        
        ```
        nvim ~/.config/hypr
        ```
        

---

## **7. Githubへのアップロード**

1. **ブラウザからGithubへのログイン**
    
    Googleアカウントでログイン
    
2. **リポジトリの新規作成**
右上の＋アイコンから [New repository]
3. **設定＆作成**
・Repository name: リポジトリ名。 availableが表示されていたらOK
・Configuration:　Choose visibility : PublicかPrivateかを選択
あとは、そのままでも良い
    
    [Create repository]で作成
    
4. **ローカルでの作業 1**
・アップロードするファイルを入れるディレクトリを作成
・作成したディレクトリにアップロードするファイル・ディレクトリをコピー
5. **ローカルでの作業 2 (git)**
・アップロードするディレクトリをカレントにする
    
    ```
    cd /path/
    ```
    
    ・以下、gitの処理
    
    ```
    git init
    git add .
    git commit -m "first commit"
    git branch -M main
    git remote add origin https://github.com/*******/*****.git
    ```
    
    ※コミット時にメールアドレス、パスワードを設定するよう促された場合は、git config で追加すること
    
6. **AccessTokenの取得**
ブラウザでgithubにログイン → 右の自分のアイコン → [Settings] →
左下の[Developer settings] → 左の[Personal access tokens] → [Fine-grained tokens] →
右側の[Generate new token] →
    
    ・Token name: 
    ・Expilation: 期間は無制限にしないことが推奨
    ・Only select repository: どのリポジトリへのアクセスなのか。複数選択可
    ・Permissions:　Add permissions: Contents で Read and write
    
    →[Generate token]
    
    表示されたTokenをテキストファイルなどにコピー
    クラウドなどに保存しておくこと
    
7. **ファイルをアップロード**
アップロードするディレクトリをカレントにしてプッシュする
    
    ```
    cd /path/
    git push -u origin main
    ```
    
8. **更新**
    
    ```
    cd /path/
    git add .
    git commit -m "コメント"
    git push
    ```
    

---

## **8. Powertopによる省エネ設定**

1. **Powertopインストール**
    
    ```
    sudo pacman -S powertop
    ```
    
2. **キャリブレーション**
    
    ```
    sudo powertop --calibrate
    ```
    
3. **サービス作成**
/etc/systemd/system/powertop.service
    
    ```
    [Unit]
    Description=Powertop tunings
    
    [Service]
    ExecStart=/usr/bin/powertop --auto-tune
    RemainAfterExit=true
    
    [Install]
    WantedBy=multi-user.target
    ```
    
4. **サービス起動**
    
    ```
    sudo systemctl enable --now powertop.service
    ```
    
5. **確認**
    
    ```
    sudo powertop
    ```
    
    tab(または、[Shift]+tab)で結果を表示して、すべてGoodかどうかを確認
    
    ```
    PowerTOP 2.15     Overview   Idle stats   Frequency stats   Device stats   Tunable
    
    >> Good          Wireless Power Saving for interface wlan0
    >> Good          NMI watchdog should be turned off
    >> Good          VM writeback timeout
    ...
    ```