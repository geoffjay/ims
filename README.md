# Image Manipulation Service

_Doesn't work, go away if you like things that work._

Humble beginnings of a thing that is intended to provide an image analysis/manipulation pipeline in the form of an
extensible service. The image pipeline and the REST route provider are available to addins using `libpeas`.

## Installation

For now just manually installing dependencies that need tweaks.

### Valum/VSGI

```sh
git clone https://github.com/geoffjay/valum.git
cd valum
# don't bother with the docs, valadoc doesn't have a 0.38 driver yet
sed -i 's/subdir(\'docs\')//'
meson --prefix=/usr _build
ninja -C _build
sudo ninja -C _build install
```

### Ims

```sh
git clone https://github.com/geoffjay/ims.git
cd ims
meson --prefix=/usr _build
ninja -C _build
sudo ninja -C _build install
```

## Plugins

### Python
