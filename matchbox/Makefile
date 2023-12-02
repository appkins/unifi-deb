TMP := "/tmp"

VERSION := "0.10.0"
ARCH := "arm64"

DOWNLOAD_URL := "https://github.com/poseidon/matchbox/releases/download/v$(VERSION)/matchbox-v$(VERSION)-linux-$(ARCH).tar.gz"

.PHONY: all clean install matchbox

all: matchbox

clean:
	rm -rf $(TMP)/matchbox

matchbox:
	mkdir -p $(TMP)/matchbox
	curl -s -L $(DOWNLOAD_URL) | tar -xzvf - -C $(TMP)/matchbox --strip-component 1

install:
	mkdir -p $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/usr/lib/matchbox
	cp $(TMP)/matchbox/matchbox $(DESTDIR)/usr/bin/matchbox
	cp -R $(TMP)/matchbox/scripts $(DESTDIR)/usr/lib/matchbox/scripts

package:
	@dpkg-buildpackage -b