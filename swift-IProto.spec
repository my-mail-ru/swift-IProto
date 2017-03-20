Name:          swift-IProto
Version:       %{__version}
Release:       %{!?__release:1}%{?__release}%{?dist}
Summary:       Swift implementation of iproto framed transport protocol

Group:         Development/Libraries
License:       MIT
URL:           https://github.com/my-mail-ru/%{name}
Source0:       https://github.com/my-mail-ru/%{name}/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
BuildRoot:     %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

BuildRequires: swift >= 3.0.2
BuildRequires: swift-packaging >= 0.6
BuildRequires: libiprotocluster-devel
BuildRequires: swiftpm(https://github.com/my-mail-ru/swift-BinaryEncoding.git) >= 0.2.0

%swift_find_provides_and_requires

%description
Implementation of iproto framed transport network protocol which is widely used among Mail.Ru Group's projects.
It is built around libiprotocluster as a thin wrapper and provides the same functionality.

%{?__revision:Built from revision %{__revision}.}


%prep
%setup -q
%swift_patch_package


%build
%swift_build


%install
rm -rf %{buildroot}
rm -f .build/release/libCIProto.so
%swift_install
%swift_install_devel


%clean
rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
%{swift_libdir}/*.so


%package devel
Summary:  Swift implementation of iproto framed transport protocol
Requires: %{name} = %{version}-%{release}
Requires: libiprotocluster-devel

%description devel
Implementation of iproto framed transport network protocol which is widely used among Mail.Ru Group's projects.
It is built around libiprotocluster as a thin wrapper and provides the same functionality.

%{?__revision:Built from revision %{__revision}.}


%files devel
%defattr(-,root,root,-)
%{swift_moduledir}/*.swiftmodule
%{swift_moduledir}/*.swiftdoc
%{swift_clangmoduleroot}/CIProto
