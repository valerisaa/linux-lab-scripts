Name:           count-files
Version:        2.0
Release:        1%{?dist}
Summary:        Bash script for directory file statistics

License:        MIT
URL:            https://github.com/valeri/linux-lab-scripts
Source0:        %{name}-%{version}.tar.gz
Source1:        count_files.1
Source2:        count-files.conf

BuildArch:      noarch
Requires:       bash
Requires:       coreutils
Requires:       findutils

%description
A Bash script that displays file system statistics for a selected directory.
It counts regular files, directories and symbolic links, and calculates
the total size of found files. Version 2.0 also displays the largest file
and its size in bytes.

%prep
%setup -q

%install
mkdir -p %{buildroot}%{_bindir}
install -m 755 count_files.sh %{buildroot}%{_bindir}/count_files
mkdir -p %{buildroot}%{_mandir}/man1
install -m 644 %{SOURCE1} %{buildroot}%{_mandir}/man1/count_files.1
mkdir -p %{buildroot}%{_sysconfdir}
install -m 644 %{SOURCE2} %{buildroot}%{_sysconfdir}/count-files.conf

%pre
if [ "$1" -eq 1 ]; then
    echo "count-files: preparing for installation..."
else
    echo "count-files: preparing for update..."
fi

%post
touch /var/log/count_files.log
chmod 644 /var/log/count_files.log
echo "count-files installed successfully. Help: man count_files"

%files
%{_bindir}/count_files
%{_mandir}/man1/count_files.1*
%{_sysconfdir}/count-files.conf
%ghost /var/log/count_files.log

%changelog
* Wed Oct 07 2026 Valeriia Temchur <v.a.temchur@gmail.com> - 1.0-1
- Initial package release
- Added man page, configuration file and %%pre, %%post scripts
* Wed Oct 07 2026 Valeriia Temchur <v.a.twmchur@gmail.com> - 2.0-1
- Added detection of the largest file in the selected directory.
