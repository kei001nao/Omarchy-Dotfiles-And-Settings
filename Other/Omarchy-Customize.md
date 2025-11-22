# Omarchy カスタマイズ（日本語対応）

---

## 概要

この方法では、以下の3つのファイルを作成して連携させます。

1.  **テーマ変更スクリプト (`.sh`)**: 実行されるとテーマを一度だけランダムに変更する。
2.  **サービスユニット (`.service`)**: 上記のスクリプトを実行する役割を持つ。
3.  **タイマーユニット (`.timer`)**: サービスユニットを定期的に起動するタイマー。

---

## 0. アップデート

```shell
sudo pacman -Syu
または、Omarchyメニュー（SUPER+Alt+Space）から [Update]→[Omarchy]
```

------

## 1. Firefoxインストール

```shell
sudo pacman -S firefox firefox-i18n-ja
```

------

## 2. yayインストール

Omarchyはインストール済みなので、必要なし

```shell
`sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

---

## 3. paruインストール

```shell
yay -S paru
```

以降、AURパッケージインストールは、`yay`、`paru` どちらでも良い

---

## 4. fish インストール

シェルをfishに変更

```shell
yay -S fish
```



fishのインストールディレクトリを調べる

```shell
which fish
```



上記の結果でわかったディレクトリを指定する

※下記のコマンドは実際にインストールされたディレクトリを書いてるが、
　環境により、`-s`オプション以降の文字列は`which`の結果に変えること

```shell
chsh -s /usr/bin/fish
```

**PC再起動**



fishの確認（バージョン表示）

```shell
fish -v
```



starship対応

~/.config/fish/config.fish

```sh
if status is-interactive
   # Commands to run in interactive sessions can go here
   if command -v starship &>/dev/null
       starship init fish | source
   end
end
```

---

## 5. いろいろインストール

**ファイルマネージャー**
 GUI: `thunar` / TUI: `yazi`

**テキストエディター**
 GUI: `kate` / TUI: `nano` (NeoVimはインストール済み)

**日本語入力メソッド**
 `fcitx5`, `mozc`

**AI**
 `gemini-cli`

**その他**

　Hyprland プラグインで必要なもの：`cmake` `cpio` `meson`

```shell
sudo pacman -S thunar file-roller gvfs tumbler poppler-glib thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin thunar-shares-plugin thunar-volman kate nano yazi unarchiver 7zip resvg cmake cpio meson fcitx5-im fcitx5-mozc npm node.js
```

```shell
npm install -g @google/gemini-cli
```



thunarにGoogle Driveを表示させるツール
`tema`（Omarchy用のWallpaper Selector）

```bash
yay -S gnome-control-center gvfs-google tema-git
```



**thunarにGoogle Driveを表示させる方法：**

 Gnome Control Center起動

```shell
env XDG_CURRENT_DESKTOP=GNOME gnome-control-center --verbose
```

Online Account で google を選んでサインインする
アクセスの許可をした後、thunar の Devices に Googleアカウント名のツリーが追加されていることを確認



---

## 6. Hyprland Plugins

公式プラグインの`hyprexpo`と`hyprscrolling`をインストール 

1.  **アップデート:**
    
    ```shell
    hyprpm update
    ```
    
2.  **インストール＆有効化:**
    
    ```shell
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprexpo
    hyprpm enable hyprscrolling
    ```
    
    

※ hyprlan.conf などに以下の記述を忘れないこと

```config
exec-once = hyprpm reload -n
```

※ プラグインの記述は、プラグインの公式サイトを参照

---

## 7. hypridleの自動実行

autostart.conf で実行されているので 特に必要ない

```shell
systemctl --user enable --now hypridle.service
```

---

## 8. 指紋認証

※ hyprlockで正常動作しなかったので、最終的にはアンインストールした

1. **指紋センサー確認:**

   ```shell
   sudo pacman -S usbutils
   lsusb
   ```

2. **インストール:**
   ELAN製の場合は、以下のライブラリをインストールすること

   ```shell
   yay -S libfprint-elanmoc2-git
   sudo pacman -S fprint
   ```

3. **メニュー からセットアップ**（指紋登録など）
   Omarchyメニュー（SUPER+Alt+Space）から [Setup]→[Security]→[Fingerprint]

   からセットアップする。

---

## 9. カスタマイズ アプリ・ドットファイル

1. **Omarchy Cleaner** 
   [https://github.com/maxart/omarchy-cleaner](https://github.com/maxart/omarchy-cleaner)

   ```shell
   curl -fsSL https://raw.githubusercontent.com/maxart/omarchy-cleaner/main/omarchy-cleaner.sh | bash
   ```

2. **Adso's Omarchy's waybar**
   [https://github.com/adsovetzky/Adsovetzky-Omarchy-s-Waybar](https://github.com/adsovetzky/Adsovetzky-Omarchy-s-Waybar)

3. **天気（waybar）** 
   [https://github.com/wneessen/waybar-weather](https://github.com/wneessen/waybar-weather)

   ```shell
   yay -S waybar-weather
   ```

   または、

   [https://github.com/bjesus/wttrbar](https://github.com/bjesus/wttrbar)

   ```shell
   yay -S wttrbar
   ```

4. **Theme Hook**

   [https://github.com/imbypass/omarchy-theme-hook](https://github.com/imbypass/omarchy-theme-hook)

   ```shell
   curl -fsSL https://imbypass.github.io/omarchy-theme-hook/install.sh | bash
   ```

   Firefoxを再起動したくない場合は、
   **/.config/omarchy/hooks/theme-set.d/40-firefox.sh**
   のFirefoxを再起動するところをコメントアウト

5. **MDメモアプリ**

   [https://github.com/k4ditano/notnative-omarchy](https://github.com/k4ditano/notnative-omarchy)

   ```shell
   yay -S notnative-app-bin
   ```



---

## 10. 仮想マシン (QEMU/KVM)

参照：[https://note.com/dreamy_clam206/n/n0dfbb225652e](https://note.com/dreamy_clam206/n/n0dfbb225652e)
※ hyprlockで正常動作しなかったので、最終的にはアンインストールした

1. **インストール:**

   ```shell
   sudo pacman -S qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm tuned ntfs-3g nftables bridge-utils openbsd-netcat libguestfs
   ```

   ★libosinfo iptables は入れない（すでに入っている）
   　ebtablesと競合する可能性あり

   

   自分をグループ libvirt, kvm に追加

   ```shell
   sudo usermod -aG libvirt,kvm $(whoami)
   ```

   もしグループがなかったら、追加する

   ```shell
   newgrp libvirt
   ```

   設定が終わったら、Reboot

   

2. **サービス起動:**

   ```shell
   sudo systemctl enable --now libvirtd.service
   ```

   

3. **ネットワークの確認＆NAT起動:**
   特にWi-Fiの場合は、要確認

   1. ネットワーク確認

      ```shell
      sudo virsh net-list --all
      ```

   2. Wi-Fi (NAT) 起動

      ```shell
      sudo virsh net-start default
      sudo virsh net-autostart default
      ```

   このようになる

   ```shell
   ⋊> ~ sudo virsh net-list --all
   Name   State   Autostart  Persistent
   \----------------------------------------------
    default  inactive  no     yes
   
   ⋊> ~ sudo virsh net-start default
   Network default started
   
   ⋊> ~ sudo virsh net-autostart default
   Network default marked as autostarted
   
   ⋊> ~ sudo virsh net-list --all
    Name   State  Autostart  Persistent
   \--------------------------------------------
    default  active  yes     yes
   ```

   defaultのactive がともに yes になっていればOK
   

4. **iptableの確認**
   network.confの修正

   ```shell
   sudo nano /etc/libvirt/network.conf
   ```

   修正：　firewall_backend = “iptables”

   最後の行をコメントアウト・修正する
   

5. **最終確認**

   ```shell
   sudo virt-host-validate qemu
   ```

   →Reboot

   

6. **Virtual Machine Manager 起動**　（virt-manager）

7. **ゲストOSインストール**

8. **ゲスト側インストール**（Arch系）

   ```shell
   sudo pacman -S spice-vdagent
   sudo systemctl enable spice-vdagentd.service
   sudo systemctl start spice-vdagentd.service
   ```

9. **ホスト側 virt-manager 設定**
   Dislpay Spice
   　Type : Spice server
   　Listen Type : None
   Video
   　Model: Virtio

10. **ゲスト側 hyprland設定**

    1. モニタースペック確認

       ```shell
       htprctl monitors
       ```

    2. monitor.congなどの修正

       ```shell
       nvim ~/.config/hypr
       ```



---

## 11. Powertopによる省エネ設定

1. **Powertopインストール** 

   ```shell
   sudo pacman -S powertop
   ```

2. **キャリブレーション** 

   ```shell
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

   ```shell
   sudo systemctl enable --now powertop.service
   ```

5. **確認**

   ```shell
   sudo powertop
   ```

   tab(または、[Shift]+tab)で結果を表示して、すべてGoodかどうかを確認

   ```
   PowerTOP 2.15     Overview   Idle stats   Frequency stats   Device stats   Tunable
   
   >> Good          Wireless Power Saving for interface wlan0                   
   >> Good          NMI watchdog should be turned off
   >> Good          VM writeback timeout
   ...
   ```

   

---

## 12. Hyprland カスタマイズ

1. #### 

   - **Hyprlock - Custom Dlassy Music Lock Screen**[https://github.com/A3TH3Rr/Hyprlock-Dots](https://github.com/A3TH3Rr/Hyprlock-Dots)

     ```shell
     g.
     ```

     必要なし：

     ```shell
     s
     ```


   

   - **Hyprlock Configuration**
     [https://github.com/mahaveergurjar/Hyprlock-Dots](https://github.com/mahaveergurjar/Hyprlock-Dots)

     ```shell
     g
     ```

     hyprlock.conf
     以下を追加

     ```
     s
     ```

     bindings.conf
     以下のように設定

     ```
     #
     ```

   

   - **t**

     る
     

     /usr/share/tema/templates/hyprlock.conf
     （例）

     ```
     $
     ```

     ~/.config/hyprlock/layouts/layout●.conf　（使用するレイアウト）
     （例：layout6.conf）

     ```
     $
     
     ```

     
     

   ## 13. その他 カスタマイズ

   1. #### Hyprlock

      - **Hyprlock - Custom Dlassy Music Lock Screen**[https://github.com/A3TH3Rr/Hyprlock-Dots](https://github.com/A3TH3Rr/Hyprlock-Dots)

        ```shell
        git clone https://github.com/A3TH3Rr/Hyprlock.git
        cd hyprlock-glassy-music
        cp -r * ~/.config/hypr/
        cd ..
        ```

        必要なし：

        ```shell
        sudo pacman -S hyprlock playerctl imagemagick
        ```


      

      - **Hyprlock Configuration**
        [https://github.com/mahaveergurjar/Hyprlock-Dots](https://github.com/mahaveergurjar/Hyprlock-Dots)

        ```shell
        git clone https://github.com/mahaveergurjar/hyprlock-Dots.git
        cd hyprlock-Dots
        cp -r .config/hyprlock ~/.config/
        cp .config/hypr/hyprlock.conf ~/.config/hypr/
        ```

        hyprlock.conf
        以下を追加

        ```
        source = ~/.config/omarchy/current/theme/hyprlock.conf
        ```

        bindings.conf
        以下のように設定

        ```
        #ディスプレイを閉じたときにロック
        bindl=,switch:off:Lid Switch, exec,　$HOME/.config/hyprlock/scripts/hyprlock.sh
        # SUPER+Ctrl+L でロック
        unbind = SUPER CTRL, L
        bindd = SUPER CTRL, L, Screen Lock,  exec, $HOME/.config/hyprlock/scripts/hyprlock.sh
        ```

      

      - **temaのテンプレート修正＆Hyprlock Configurationのlayout.conf修正**

        temaで壁紙を切り替えたときにテーマ（色）をロック画面に反映させる
        

        /usr/share/tema/templates/hyprlock.conf
        （例）

        ```
        $primarycolor_1 = rgba({color1.strip}D9)
        $primarycolor_2 = rgba({color2.strip}D9)
        $primarycolor_3 = rgba({color3.strip}D9)
        $primarycolor_4 = rgba({color4.strip}D9)
        $primarycolor_5 = rgba({color5.strip}D9)
        $foregroundcolor = rgba({foreground.strip}D9)
        $backgroundcolor = rgba({background.strip}D9) 
        ```

        ~/.config/hyprlock/layouts/layout●.conf　（使用するレイアウト）
        （例：layout6.conf）

        ```
        $fn_splash=echo "$(hyprctl splash)"
        # $wall = $hyprlockDir/wallpapers/2.png
        
        # BACKGROUND
        background {
                 monitor =
                 path = ~/.config/omarchy/current/background
                 # path = $wall
                 ...
             }
        
        # TIME
        label {
                 monitor =
                 text = $TIME
                 color = $primarycolor_1    #$primary_4_rgba
                 font_size = 200 
                 ...
             }
        ...
        ```

        
        

   2. #### Kitty

      /.config/kitty/kitty.conf

      ```
      include ~/.config/omarchy/current/theme/kitty.conf
      
      # Font
         font_family CaskaydiaMono Nerd Font
         bold_font auto
         italic_font auto
         bold_italic_font auto
         font_size        12.0
         cursor_trail 1
         # background_opacity 1.0
      ```

      


   

   1. 
   2. 
