# Kubernetes Installation
The Kubernetes path contains scripts and manifests which can be used to install kubernetes in multiple different ways. All the current ways are tested on Debian 11.
## Run After Clean Install

An installation script is located in the directory which will perform an installation of the binaries needed for a kubernetes host. Execute one of the following commands with root access rights in order to perform the installation after a clean install of the OS:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/geoffh1977/shared-utils/main/kubernetes/install.sh)"
```

*OR*

```bash
sh -c "$(wget https://raw.githubusercontent.com/geoffh1977/shared-utils/main/kubernetes/install.sh -O -)"
```

## KVM Virtual Machine Build

To build a virtual machine in a single step using network booting, execute the following command. It will perform an installation of Debian 11 with a Pre-seed file and automatically run the above script on the first boot of the operating system.

```bash
virt-install --name K8s_Master --memory 4096 --vcpus 2 --disk size=20 --location http://ftp.au.debian.org/debian/dists/bullseye/main/installer-amd64/ --os-variant debian10 --extra-args="url=https://raw.githubusercontent.com/geoffh1977/shared-utils/main/debian/preseed-k8s.cfg auto=true netcfg/get_hostname=k8s-master netcfg/get_domain=vm.harrison.lan" --noautoconsole
```

## Completing The Installation For Masters

In order to complete the installation after the script is complete. Access with the root user (or sudo) and run ```/root/k8s-setup/setup_k8s_master.sh```

*N.B. You may need to modify the file to change any defaults you don't want to use*
