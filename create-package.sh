#!/bin/bash
# Author: TheElectronWill

source terminal-colors.sh # Adds color variables
source common-functions.sh # Adds utilities functions
source basic-checks.sh # Checks that rpmbuild is available and that the script isn't started as root

rpm_dir="$PWD/RPMs"
work_dir="$PWD/work"

archive_name='Typora-linux.tar.gz'

mime_spec='typora.xml'
mime_spec_file="$PWD/$mime_spec"
desktop_model="$PWD/typora.desktop"
spec_file="$PWD/typora.spec"

desktop_file="$work_dir/typora.desktop"
archive_file="$work_dir/$archive_name"

downloaded_dir="$work_dir/typora"
exec_name='Typora'
exec_file="$downloaded_dir/$exec_name"

# Checks that the version is given as a parameter.
if [[ $# -ne 1 || $1 != "x64" && $1 != "ia32" ]]; then
	disp "${red}Wrong or missing parameters!$reset"
	echo 'Usage: create-package.sh x64/ia32'
	exit
fi
arch="$1"
download_url="https://typora.io/linux/Typora-linux-$arch.tar.gz"
if [[ $arch == "x64" ]]; then
	rpm_arch="x86_64"
else
	rpm_arch="i686"
fi

# Downloads the typora zip archive.
download_typora() {
	echo 'Downloading Typora for linux...'
	wget -q --show-progress "$download_url" -O "$archive_file"
}

manage_dir "$work_dir" 'work'
manage_dir "$rpm_dir" 'RPMs'
cd "$work_dir"

# Downloads typora if needed.
if [ -e "$archive_name" ]; then
	echo "Found the archive \"$archive_name\"."
	ask_yesno 'Use this archive instead of downloading a new one?'
	case "$answer" in
		y|Y)
			echo 'Existing archive selected.'
			;;
		*)
			rm "$archive_name"
			echo 'Existing archive removed.'
			download_typora
	esac
else
	download_typora
fi

# Extracts the archive:
echo
if [ ! -d "$downloaded_dir" ]; then
	mkdir "$downloaded_dir"
fi
extract "$archive_name" "$downloaded_dir" "--strip 1" # --strip 1 gets rid of the top archive's directory

echo 'Analysing the files...'
infos_path='resources/app/package.json'
infos_file="$downloaded_dir/$infos_path"
#
icon_path="resources/app/asserts/icon"
icon_file="/opt/typora/$icon_path/icon_512x512.png"
mime_icon256_file="/opt/typora/$icon_path/icon_256x256.png"
mime_icon64_file="/opt/typora/$icon_path/icon_32x32@2x.png"
#
version_line=$(cat "$infos_file" | grep "version" -m 1)
version_number=$(echo "$version_line" | cut -d'"' -f4)
#
echo " -> Infos path: $infos_path"
echo " -> Icons path: $icon_path"
echo " -> Version: $version_number"


echo 'Creating the .desktop file...'
cp "$mime_spec_file" "$downloaded_dir"
cp "$desktop_model" "$desktop_file"
sed -e "s}@version}$version_number}; s}@icon}$icon_file}; s}@exe}$exec_name}" "$desktop_model" > "$desktop_file"

arch=$rpm_arch
disp "${yellow}Creating the RPM package for $rpm_arch (this may take a while)..."
rpmbuild -bb --quiet --nocheck "$spec_file" --define "_topdir $work_dir" --define "_rpmdir $rpm_dir"\
	--define "arch $arch" --define "downloaded_dir $downloaded_dir" --define "desktop_file $desktop_file"\
	--define "version_number $version_number" --define "exec_name $exec_name"\
	--define "mime_icon $mime_icon64_file" --define "mime_icon_big $mime_icon256_file"

disp "${bgreen}Done!${reset_font}"
disp "The RPM package is located in the \"RPMs/$arch\" folder."
disp '----------------'

ask_remove_dir "$work_dir"
ask_installpkg
