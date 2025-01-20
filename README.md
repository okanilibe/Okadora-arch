# bazzite-arch

[![build-bazzite-arch](https://github.com/okanilibe/Okadora-arch/actions/workflows/build.yml/badge.svg)](https://github.com/okanilibe/Okadora-arch/actions/workflows/build.yml) 

Okadora-Arch is a [Arch Linux](https://archlinux.org/) based OCI designed for use exclusively in [distrobox](https://github.com/89luca89/distrobox). It can be used on any Linux distributon by following the usage section below.

## Usage

    distrobox-create --unshare-netns --nvidia --image ghcr.io/okanilibe/Okadora-arch --name Okadora-arch -Y

<sub>For the GNOME desktop environment, you may want to replace `ghcr.io/okanilibe/Okadora-arch` in the above command with `ghcr.io/okanilibe/Okadora-arch-gnome`, which comes with `xdg-desktop-portal-gtk`.</sub>

Okadora-Arch is built from [arch-distrobox](https://github.com/ublue-os/arch-distrobox), which ships with [paru](https://github.com/Morganamilo/paru) pre-installed, along with a modified [xdg-utils](https://github.com/KyleGospo/xdg-utils-distrobox-arch) that allows the container to open your host operating system's web browsers and file explorer.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/okanilibe/Okadora-arch
