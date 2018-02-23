# Image Manipulation Service

_Doesn't work, go away if you like things that work._

Humble beginnings of a thing that is intended to provide an image analysis/manipulation pipeline in the form of an
extensible service. The image pipeline and the REST router are available to addins using `libpeas`.

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

### Memcached

Not sure if this will be used in the end.

```sh
sudo dnf install -y memcached libmemcached-devel
sudo systemctl enable memcached
sudo systemctl start memcached
```

### Couchbase

```sh
# XXX originally tried this:
# sudo dnf install couchdb libcouchbase-devel
# sudo systemctl enable couchdb
# sudo systemctl start couchdb
# XXX ran into limitations so switched to version outside of default fedora repos
wget https://packages.couchbase.com/releases/5.0.1/couchbase-server-community-5.0.1-centos7.x86_64.rpm
sudo dnf install couchbase-server-community-5.0.1-centos7.x86_64.rpm
```

Follow the section at _Set up Couchbase Server_ at [Couchbase](Couchbase).

* Go to `http://127.0.0.1:8091/ui/index.html`
* Click _Setup New Cluster_
* Enter "ims"
* For password use "notagoodpassword" _or something better_
* Do the bits to accept terms & conditions
* Click _Finish with Defaults_

_TODO: Make instructions on setting up using REST_

#### Testing

```sh
# There's probably a better way of testing a connection, change later
/opt/couchbase/bin/cbworkloadgen -n 127.0.0.1:8091 \
  --user=Administrator --password=notagoodpassword -b ims
# N1QL utility
/opt/couchbase/bin/cbq -u Administrator -p notagoodpassword \
  -e http://localhost:8091/pools
```

#### Bucket Setup

```sh
/opt/couchbase/bin/couchbase-cli bucket-create -u Administrator -p notagoodpassword \
  -c localhost:8091 --bucket-type couchbase --bucket ims --bucket-ramsize 2048
```

### GCouchbase

```sh
git clone https://github.com/geoffjay/gcouchbase.git
cd gcouchbase
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ..
make && sudo make install
```

### Ims

```sh
git clone https://github.com/geoffjay/ims.git
cd ims
export PKG_CONFIG_PATH=/usr/lib/pkgconfig/
meson --prefix=/usr _build
ninja -C _build
sudo ninja -C _build install
```


### Post Install / Pre Execution

Valum doesn't set the library path for the VSGI `.so` files that are needed so
this is necessary to execute `ims` once installed.

```bash
echo /usr/lib64/vsgi-0.4/servers | \
  sudo tee /etc/ld.so.conf.d/valum-x86_64.conf >/dev/null
sudo ldconfig
```

## Plugins

### Vala

### Python

<!-- Links -->

[Couchbase]: (https://developer.couchbase.com/documentation/server/5.0/install/init-setup.html)
