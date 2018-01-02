%define install_dir /opt/typora
%define apps_dir /usr/share/applications
%define _build_id_links none

Name:		typora
Version:	%{pkg_version}
Release:	0%{?dist}
Summary:	Minimal markdown editor.

Group:		Applications/Office
License:	Proprietary
URL:		https://typora.io
BuildArch:	%{arch}
Requires:   %{pkg_deps}

%description
Minimal markdown editor

%prep

%build

%install
mkdir -p "%{buildroot}%{install_dir}"
mkdir -p "%{buildroot}%{apps_dir}"
mv "%{downloaded_dir}"/* "%{buildroot}%{install_dir}" # Install the app
cp "%{desktop_file}" "%{buildroot}%{apps_dir}" # Install the desktop file
chmod +x "%{buildroot}%{install_dir}/"*.so
chmod +x "%{buildroot}%{install_dir}/%{exec_name}"

# Package the files
%files
%{install_dir}
%{apps_dir}/*

%post
xdg-mime install --mode system --novendor "%{install_dir}/typora.xml" # Install the MIME data
xdg-icon-resource install --context mimetypes --size 64 "%{mime_icon}" text-markdown # Install the file icon
xdg-icon-resource install --context mimetypes --size 256 "%{mime_icon_big}" text-markdown # Install the HD file icon
update-desktop-database # Update the desktop database

%preun
xdg-mime uninstall --mode system "%{install_dir}/typora.xml" # Remove the MIME data
xdg-icon-resource uninstall --context mimetypes --size 64 text-markdown # Remove the file icon
xdg-icon-resource uninstall --context mimetypes --size 256 text-markdown # Remove the HD file icon

