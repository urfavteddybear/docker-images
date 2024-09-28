## Features ✨

 - Multi-language
 - ISO downloader
 - KVM acceleration
 - Web-based viewer

 ## Usage 🐳

Via Docker Compose:

```yaml
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "win11"
    devices:
      - /dev/kvm
    cap_add:
      - NET_ADMIN
    ports:
      - 8006:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    stop_grace_period: 2m
```

Via Docker CLI:

```bash
docker run -it --rm -p 8006:8006 --device=/dev/kvm --cap-add NET_ADMIN --stop-timeout 120 dockurr/windows
```

Via Kubernetes:

```shell
kubectl apply -f kubernetes.yml
```

## FAQ 💬

### How do I use it?

  Very simple! These are the steps:
  
  - Start the container and connect to [port 8006](http://localhost:8006) using your web browser.

  - Sit back and relax while the magic happens, the whole installation will be performed fully automatic.

  - Once you see the desktop, your Windows installation is ready for use.
  
  Enjoy your brand new machine, and don't forget to star this repo!

### How do I select the Windows version?

  By default, Windows 11 will be installed. But you can add the `VERSION` environment variable to your compose file, in order to specify an alternative Windows version to be downloaded:

  ```yaml
  environment:
    VERSION: "win11"
  ```

  Select from the values below:
  
  | **Value** | **Version**              | **Size** |
  |---|---|---|
  | `win11`   | Windows 11 Pro           | 6.4 GB   |
  | `win11e`  | Windows 11 Enterprise    | 5.8 GB   |
  | `win10`   | Windows 10 Pro           | 5.7 GB   |
  | `ltsc10`  | Windows 10 LTSC          | 4.6 GB   |
  | `win10e`  | Windows 10 Enterprise    | 5.2 GB   |
  ||||
  | `win8`    | Windows 8.1 Pro          | 4.0 GB   |
  | `win8e`   | Windows 8.1 Enterprise   | 3.7 GB   |
  | `win7`    | Windows 7 Enterprise     | 3.0 GB   |
  | `vista`   | Windows Vista Enterprise | 3.0 GB   |
  | `winxp`   | Windows XP Professional  | 0.6 GB   |
  ||||
  | `2025`    | Windows Server 2025      | 5.0 GB   |
  | `2022`    | Windows Server 2022      | 4.7 GB   |
  | `2019`    | Windows Server 2019      | 5.3 GB   |
  | `2016`    | Windows Server 2016      | 6.5 GB   |
  | `2012`    | Windows Server 2012      | 4.3 GB   |
  | `2008`    | Windows Server 2008      | 3.0 GB   |
  | `2003`    | Windows Server 2003      | 0.6 GB   |

  ### How do I change the storage location?

  To change the storage location, include the following bind mount in your compose file:

  ```yaml
  volumes:
    - /var/win:/storage
  ```

  Replace the example path `/var/win` with the desired storage folder.

### How do I change the size of the disk?

  To expand the default size of 64 GB, add the `DISK_SIZE` setting to your compose file and set it to your preferred capacity:

  ```yaml
  environment:
    DISK_SIZE: "256G"
  ```
  
> [!TIP]
> This can also be used to resize the existing disk to a larger capacity without any data loss.

### How do I share files with the host?

  Open 'File Explorer' and click on the 'Network' section, you will see a computer called `host.lan`. Double-click it and it will show a folder called `Data`, which can be binded to any folder on your host via the compose file:

  ```yaml
  volumes:
    -  /home/user/example:/shared
  ```

  The example folder `/home/user/example` will be available as ` \\host.lan\Data`.
  
> [!TIP]
> You can map this path to a drive letter in Windows, for easier access.

### How do I install a custom image?

  In order to download an unsupported ISO image that is not selectable from the list above, specify the URL of that ISO in the `VERSION` environment variable, for example:
  
  ```yaml
  environment:
    VERSION: "https://example.com/win.iso"
  ```

  Alternatively, you can also skip the download and use a local file instead, by binding it in your compose file in this way:
  
  ```yaml
  volumes:
    - /home/user/example.iso:/custom.iso
  ```

  Replace the example path `/home/user/example.iso` with the filename of your desired ISO file, the value of `VERSION` will be ignored in this case.

### How do I run a script after installation?

  To run your own script after installation, you can create a file called `install.bat` and place it in a folder together with any additional files it needs (software to be installed for example). Then bind that folder in your compose file like this:

  ```yaml
  volumes:
    -  /home/user/example:/oem
  ```

  The example folder `/home/user/example` will be copied to `C:\OEM` during installation and the containing `install.bat` will be executed during the last step.

### How do I perform a manual installation?

  It's best to stick to the automatic installation, as it adjusts various settings to prevent common issues when running Windows inside a virtual environment.

  However, if you insist on performing the installation manually, add the following environment variable to your compose file:

  ```yaml
  environment:
    MANUAL: "Y"
  ```

### How do I change the amount of CPU or RAM?

  By default, the container will be allowed to use a maximum of 2 CPU cores and 4 GB of RAM.

  If you want to adjust this, you can specify the desired amount using the following environment variables:

  ```yaml
  environment:
    RAM_SIZE: "8G"
    CPU_CORES: "4"
  ```

### How do I configure the username and password?

  By default, a user called `Docker` is created during the installation, with an empty password.

  If you want to use different credentials, you can change them in your compose file:

  ```yaml
  environment:
    USERNAME: "bill"
    PASSWORD: "gates"
  ```

  ### How do I assign an individual IP address to the container?

  By default, the container uses bridge networking, which shares the IP address with the host. 

  If you want to assign an individual IP address to the container, you can create a macvlan network as follows:

  ```bash
  docker network create -d macvlan \
      --subnet=192.168.0.0/24 \
      --gateway=192.168.0.1 \
      --ip-range=192.168.0.100/28 \
      -o parent=eth0 vlan
  ```
  
  Be sure to modify these values to match your local subnet. 

  Once you have created the network, change your compose file to look as follows:

  ```yaml
  services:
    windows:
      container_name: windows
      ..<snip>..
      networks:
        vlan:
          ipv4_address: 192.168.0.100

  networks:
    vlan:
      external: true
  ```
 
  An added benefit of this approach is that you won't have to perform any port mapping anymore, since all ports will be exposed by default.

> [!IMPORTANT]  
> This IP address won't be accessible from the Docker host due to the design of macvlan, which doesn't permit communication between the two. If this is a concern, you need to create a [second macvlan](https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/#host-access) as a workaround.

### How can Windows acquire an IP address from my router?

  After configuring the container for [macvlan](#how-do-i-assign-an-individual-ip-address-to-the-container), it is possible for Windows to become part of your home network by requesting an IP from your router, just like a real PC.

  To enable this mode, add the following lines to your compose file:

  ```yaml
  environment:
    DHCP: "Y"
  devices:
    - /dev/vhost-net
  device_cgroup_rules:
    - 'c *:* rwm'
  ```

> [!NOTE]  
> In this mode, the container and Windows will each have their own separate IPs.

### How do I add multiple disks?

  To create additional disks, modify your compose file like this:
  
  ```yaml
  environment:
    DISK2_SIZE: "32G"
    DISK3_SIZE: "64G"
  volumes:
    - /home/example:/storage2
    - /mnt/data/example:/storage3
  ```

### How do I pass-through a disk?

  It is possible to pass-through disk devices directly by adding them to your compose file in this way:

  ```yaml
  devices:
    - /dev/sdb:/disk1
    - /dev/sdc:/disk2
  ```

  Use `/disk1` if you want it to become your main drive, and use `/disk2` and higher to add them as secondary drives.

### How do I pass-through a USB device?

  To pass-through a USB device, first lookup its vendor and product id via the `lsusb` command, then add them to your compose file like this:

  ```yaml
  environment:
    ARGUMENTS: "-device usb-host,vendorid=0x1234,productid=0x1234"
  devices:
    - /dev/bus/usb
  ```

> [!IMPORTANT]
> If the device is a USB disk drive, please wait until after the installation is completed before connecting it. Otherwise the installation may fail, as the order of the disks can get rearranged.

### How do I verify if my system supports KVM?

  To verify that your system supports KVM, run the following commands:

  ```bash
  sudo apt install cpu-checker
  sudo kvm-ok
  ```

  If you receive an error from `kvm-ok` indicating that KVM acceleration can't be used, please check whether:

  - the virtualization extensions (`Intel VT-x` or `AMD SVM`) are enabled in your BIOS.

  - you are running an operating system that supports them, like Linux or Windows 11 (macOS and Windows 10 do not unfortunately).

  - you enabled "nested virtualization" if you are running the container inside a virtual machine.

  - you are not using a cloud provider, as most of them do not allow nested virtualization for their VPS's.

  If you didn't receive any error from `kvm-ok` at all, but the container still complains that `/dev/kvm` is missing, it might help to add `privileged: true` to your compose file (or `--privileged` to your `run` command), to rule out any permission issue.

## Disclaimer ⚖️
*The product names, logos, brands, and other trademarks referred to within this project are the property of their respective trademark holders. This project is not affiliated, sponsored, or endorsed by Microsoft Corporation.*

*Big thanks to [Dockur](https://github.com/dockur) for making this project possible.*