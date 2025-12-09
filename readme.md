# maccha - omarchy theme & dotfiles

This repository contains personal desktop environment settings for Omarchy (Arch Linux & Hyprland).

## Screenshots

![Screenshot 1](./assets/2025-12-09-024443_hyprshot.png)

![Screenshot 2](./assets/2025-12-09-024739_hyprshot.png)

## Installation

1.  **Clone the repository:**
    
    ```bash
    git clone https://github.com/kei001nao/Omarchy-Dotfiles-And-Settings.git ~/.dotfiles
    ```
    
2.  **Run the installer:**
    The installer will install packages, copy configuration files.
    
    ```bash
    cd ~/.dotfiles/install
    chmod +x install.sh
    ./install.sh
    ```
    *Note: Review the package lists (`pkglist.txt`, `aur_pkglist.txt`) in the `install` directory before running the script if you wish to customize the installed applications.*

## Key Components

This setup utilizes the following key components and configurations:

*   **Base Theme & Waybar:** [omarchy-oxford-theme](https://github.com/HANCORE-linux/omarchy-oxford-theme)
*   **Ghostty Shader:** [Cursor shaders for ghostty](https://github.com/sahaj-b/ghostty-cursor-shaders)
*   **File Managers:** Thunar, Yazi
*   **Editors:** Kate, nano, VSCode
*   **Hyprland Plugins:** Hyprscrolling, Hyprexpo
*   **Hyprland Extensions:** Pyprland
*   **Blue Light Filter:** sunsetr
*   **Input Method:** fcitx5, mozc

## What the Installer Does

The `install.sh` script automates the following tasks:

-   **Installs Packages:** Installs all packages listed in `pkglist.txt` (from official repositories) and `aur_pkglist.txt` (from the AUR).
-   **Copies Configuration:** All configuration files and directories are copied to your home directory (`~/`).
-   **Backs Up Existing Files:** Any existing files that would be overwritten are backed up to `~/setup_backup_YYYY-MM-DD`.

## Manual Configuration

This section describes the manual setup required after running the installer.

### Firefox Customization

To apply custom styles (`userChrome.css`) to Firefox, you must run a separate script **after** starting Firefox at least once.

1.  **Start Firefox:** Launch Firefox normally to create a user profile.
2.  **Run the Firefox setup script:**
    
    ```bash
    cd ~/.dotfiles/install
    chmod +x setup-firefox.sh
    ./setup-firefox.sh
    ```

### Hyprland Plugins Installation

Install and enable official plugins `hyprexpo` and `hyprscrolling`.

1.  **Update :**
    
    ```bash
    hyprpm update
    ```
    
2.  **Install & Enable Plugins:**
    
    ```bash
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm enable hyprexpo
    hyprpm enable hyprscrolling
    ```

*Note: Don't forget to add the following line to your `hyprland.conf` or similar configuration file:*

```toml
exec-once = hyprpm reload -n
```
*For more details on plugins, refer to the official plugin website.*

### Thunar Google Drive Integration

To display Google Drive in Thunar:

1.  **Launch Gnome Control Center:**
    
    ```bash
    env XDG_CURRENT_DESKTOP=GNOME gnome-control-center --verbose
    ```
    
2.  **Add Google Account:** In Gnome Control Center, go to "Online Accounts", select "Google", and sign in.

3.  **Verify:** After granting access, confirm that a tree with your Google account name has been added under "Devices" in Thunar.


### KVM/QEMU (virt-manager) Setup

This is a guide to setting up KVM/QEMU with `virt-manager`.

1.  **Installation**

    Install the necessary packages:
    ```bash
    sudo pacman -S qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm tuned ntfs-3g nftables bridge-utils openbsd-netcat libguestfs
    ```
    *Note: `libosinfo` and `iptables` are often pre-installed. They are omitted here to avoid potential conflicts with `ebtables`.*

    Add your user to the `libvirt` and `kvm` groups:
    ```bash
    sudo usermod -aG libvirt,kvm $(whoami)
    ```
    *Note: If the `libvirt` group does not exist, you may need to re-login for the group changes to apply. You can verify groups with `cat /etc/group | cut -d: -f 1` and apply group changes to your current session with `newgrp libvirt`.*

    **Reboot** after completing this step.

2.  **Start the Service**

    Enable and start the `libvirtd` service:
    ```bash
    sudo systemctl enable --now libvirtd.service
    ```

3.  **Network Configuration (NAT)**

    Especially for Wi-Fi connections, ensure the default network is active.

    Check network status:
    ```bash
    sudo virsh net-list --all
    ```

    Start the default network and set it to autostart:
    ```bash
    sudo virsh net-start default
    sudo virsh net-autostart default
    ```
    
    Verify that the `default` network is `active` and `autostart` is `yes`:
    ```
    $ sudo virsh net-list --all
     Name      State    Autostart   Persistent
    --------------------------------------------
     default   active   yes         yes
    ```

4.  **Firewall Backend Configuration**

    Edit `/etc/libvirt/network.conf` to use the `iptables` backend.
    ```bash
    sudo nano /etc/libvirt/network.conf
    ```
    Find and modify the following line (uncomment if necessary):
    ```
    firewall_backend = "iptables"
    ```

5.  **Final Validation**

    Run the host validation tool:
    ```bash
    sudo virt-host-validate qemu
    ```
    **Reboot** your system again.

6.  **Launch Virtual Machine Manager**

    You can now start `virt-manager`.

7.  **Guest OS Installation**

    Proceed with installing your guest OS in `virt-manager`.

8.  **Guest OS Setup (Arch-based)**

    Inside the Arch-based guest, install the SPICE agent for better integration:
    ```bash
    sudo pacman -S spice-vdagent
    sudo systemctl enable --now spice-vdagentd.service
    ```

9.  **Host `virt-manager` Settings (for Guest)**

    For optimal performance, configure the guest's hardware in `virt-manager`:
    -   **Display Spice** -> Type: `Spice server`, Listen Type: `None`
    -   **Video** -> Model: `Virtio`

10. **Guest OS Hyprland Configuration**

    Inside the guest, adjust your Hyprland configuration for the virtual monitor.

    Check the monitor specifications:
    ```bash
    hyprctl monitors
    ```

    Edit your monitor configuration file accordingly (e.g., `~/.config/hypr/monitors.conf`):
    ```bash
    nvim ~/.config/hypr/monitors.conf
    ```
