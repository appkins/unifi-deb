.PHONY: all package

all: package

package:
	mkdir -p .build
	env --chdir=matchbox bash -c 'dpkg-buildpackage -a arm64 -b -uc -us'
	mv matchbox_*.deb ./.build/
	mv matchbox_*.buildinfo ./.build/
	mv matchbox_*.changes ./.build/
	