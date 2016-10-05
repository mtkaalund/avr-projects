# avr-tools-build
Automate build and install of AVR compiler and toolchain

## build-avr.sh
This is a script for compiling the avr toolchain in a local directory.
At default this will download the source code for the following packages:
- Binutils	2.27
- GCC		6.2.0
- AVR libc	2.0.0
- GDB		7.11.1
- simAVR	1.3

## Need packages
On ubuntu and its variants
###For all packages
```Bash
sudo apt update
sudo apt install build-essential
```
###AVRdude
```Bash
sudo apt install autoconf automake autotools-dev debhelper dh-strip-nondeterminism flex libelf-dev libfile-stripnondeterminism-perl libfl-dev libftdi-dev libftdi1 libncurses5-dev libpotrace0 libptexenc1 libreadline-dev libreadline6-dev libsynctex1 libtexlua52 libtexluajit2 libtext-unidecode-perl libtinfo-dev libusb-dev libxml-libxml-perl libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-perl libzzip-0-13 po-debconf tex-common texinfo texlive-base texlive-binaries texlive-latex-base
```
###GCC
```Bash
sudo apt install autoconf automake autotools-dev debhelper dh-strip-nondeterminism flex libelf-dev libfile-stripnondeterminism-perl libfl-dev libftdi-dev libftdi1 libncurses5-dev libpotrace0 libptexenc1 libreadline-dev libreadline6-dev libsynctex1 libtexlua52 libtexluajit2 libtext-unidecode-perl libtinfo-dev libusb-dev libxml-libxml-perl libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-perl libzzip-0-13 po-debconf tex-common texinfo texlive-base texlive-binaries texlive-latex-base
```
###Binutils
```Bash
sudo apt install autoconf chrpath dejagnu expect flex libfl-dev libtext-unidecode-perl libxml-libxml-perl libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-perl quilt tcl-expect tex-common texinfo zlib1g-dev
```
###AVR-libc
```Bash
sudo apt install autoconf autoconf2.59 automake1.11 autotools-dev binutils-avr cm-super-minimal debhelper dh-strip-nondeterminism doxygen doxygen-latex gawk gcc-avr libclang1-3.6 libfile-stripnondeterminism-perl libllvm3.6v5 libobjc-5-dev libobjc4 libpotrace0 libptexenc1 libsynctex1 libtexlua52 libtexluajit2 libzzip-0-13 po-debconf preview-latex-style tex-common texlive-base texlive-binaries texlive-extra-utils texlive-font-utils texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures transfig
```
###GDB
```Bash
sudo apt install autoconf automake autotools-dev cdbs cm-super cm-super-minimal debhelper dejagnu dh-strip-nondeterminism dh-translations ecj ecj-gcj expect fastjar flex gccgo gccgo-6 gcj-5 gcj-5-jdk gcj-5-jre gcj-5-jre-headless gcj-5-jre-lib gcj-jdk gcj-jre gcj-jre-headless gobjc gobjc-5 intltool java-common libantlr-java libbabeltrace-ctf-dev libbabeltrace-dev libecj-java libecj-java-gcj libexpat1-dev libfile-stripnondeterminism-perl libfl-dev libgcj-bc libgcj-common libgcj16 libgcj16-awt libgcj16-dev libgo9 liblzma-dev libncurses5-dev libobjc-5-dev libobjc4 libpotrace0 libptexenc1 libpython3-dev libpython3.5-dev libreadline-dev libreadline6-dev libsynctex1 libtexlua52 libtexluajit2 libtext-unidecode-perl libtinfo-dev libtool libxml-libxml-perl libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-perl libzzip-0-13 pfb2t1c2pfb po-debconf python-pkg-resources python-scour python-six python3-dev python3.5-dev tcl-expect tex-common texinfo texlive-base texlive-binaries texlive-fonts-recommended texlive-latex-base texlive-latex-recommended zlib1g-dev
```
###or for all
If you got sources actived for apt, it can be done with
```Bash
sudo apt build-dep gdb binutil gcc avr-libc avrdude
```
and if not
```Bash
sudo apt install autoconf autoconf2.59 automake automake1.11 autotools-dev binutils-avr cdbs chrpath cm-super cm-super-minimal debhelper dejagnu dh-strip-nondeterminism dh-translations doxygen doxygen-latex ecj ecj-gcj expect fastjar flex gawk gcc-avr gccgo gccgo-6 gcj-5 gcj-5-jdk gcj-5-jre gcj-5-jre-headless gcj-5-jre-lib gcj-jdk gcj-jre gcj-jre-headless gobjc gobjc-5 intltool java-common libantlr-java libbabeltrace-ctf-dev libbabeltrace-dev libclang1-3.6 libecj-java libecj-java-gcj libelf-dev libexpat1-dev libfile-stripnondeterminism-perl libfl-dev libftdi-dev libftdi1 libgcj-bc libgcj-common libgcj16 libgcj16-awt libgcj16-dev libgo9 libllvm3.6v5 liblzma-dev libncurses5-dev libobjc-5-dev libobjc4 libpotrace0 libptexenc1 libpython3-dev libpython3.5-dev libreadline-dev libreadline6-dev libsynctex1 libtexlua52 libtexluajit2 libtext-unidecode-perl libtinfo-dev libtool libusb-dev libxml-libxml-perl libxml-namespacesupport-perl libxml-sax-base-perl libxml-sax-perl libzzip-0-13 pfb2t1c2pfb po-debconf preview-latex-style python-pkg-resources python-scour python-six python3-dev python3.5-dev quilt tcl-expect tex-common texinfo texlive-base texlive-binaries texlive-extra-utils texlive-font-utils texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures transfig zlib1g-dev
```
Please read the TODO.md
