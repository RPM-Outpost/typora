![typora icon](typora-icon.png)

# Typora rpm
Unofficial RPM package for the markdown editor [Typora](https://typora.io).

## How to use
Open a terminal and run `./create-package.sh x64` to create a 64 bits package. Replace `x64` by `ia32` to create a 32 bits package.

**Warning**: The path where you run the script must **not** contain any special character like é, ü, etc. This is a limitation of the rpm tools.

## Features
- Downloads the latest version of Typora from the official website
- Creates a ready-to-use RPM package
- Sets Typora as the default markdown editor
- Adds Typora to the applications' list with a nice HD icon
- Supports Fedora (26, 27), OpenSUSE (Leap) and Mageia (untested on Mageia)

## Screenshot
![beautiful screenshot](screenshot.png)
