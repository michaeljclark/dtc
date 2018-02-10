#!/bin/bash

set -eux

pkg_arch=x86_64
pkg_distro=centos
pkg_dir=$(realpath ./dtc_${PACKAGE_VERSION}_${pkg_arch}_${pkg_distro})

pkg_version=$(echo ${PACKAGE_VERSION} | cut -d- -f1)
pkg_release=$(echo ${PACKAGE_VERSION} | cut -d- -f2)

make
make install PREFIX=/usr/local DESTDIR=$pkg_dir

cat << EOF > dtc.spec
Name: dtc
Version: ${pkg_version}
Release: ${pkg_release}
Summary: Device Tree Compiler
License: GPLv2

%description
Device Tree Compiler (dtc) is a toolchain for working with
device tree source and binary files and also libfdt, a utility
library for reading and manipulating the binary format.

%prep

%build

%install
rsync -a ${pkg_dir}/ %buildroot/

%files
%defattr(0644, root,root)
%attr(0755, root,root) /usr/local/bin/*
%attr(0755, root,root) /usr/local/lib/libfdt-1.4.6.so
%attr(0755, root,root) /usr/local/lib/libfdt.so.1
%attr(0755, root,root) /usr/local/lib/libfdt.so
/usr/local/lib/libfdt.a
/usr/local/include/*
EOF

rpmbuild -bb dtc.spec
cp /root/rpmbuild/RPMS/${pkg_arch}/dtc-${PACKAGE_VERSION}.${pkg_arch}.rpm ./
