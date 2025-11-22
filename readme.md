# Omarchy カスタマイズ（日本語対応）

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

## 4. いろいろインストール

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

## 5. Hyprland Plugins

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

## 6. 仮想マシン (QEMU/KVM)

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

## 7. Powertopによる省エネ設定

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

   
