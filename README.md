# khadas edge-2 minimal nixos image

necessary firmware blobs are extracted from [base images](https://dl.khadas.com/products/oowow/images/armbian/edge2/), otherwise wifi and gpu driver wont work

note: this has to be built on an aarch64 system.
sd image from cross compiling fails to boot!

build using:
```sh
nix build .#images.edge2-native
```

this took me forever to get running.

thank you to [NixOS on ARM matrix group](https://matrix.to/#/#nixos-on-arm:nixos.org)