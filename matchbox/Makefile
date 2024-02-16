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
	mkdir -p $(DESTDIR)/var/lib/matchbox
	mkdir -p $(DESTDIR)/lib/systemd/system
	mkdir -p $(DESTDIR)/etc/matchbox
	cp $(TMP)/matchbox/matchbox $(DESTDIR)/usr/bin/matchbox
	cp matchbox.sh $(DESTDIR)/usr/bin/matchbox-wrapper
	cp validate.sh $(DESTDIR)/var/lib/matchbox/validate
	cp matchbox.service $(DESTDIR)/lib/systemd/system/matchbox.service
	cp matchbox.conf $(DESTDIR)/etc/matchbox/matchbox.conf
	cp -R $(TMP)/matchbox/scripts $(DESTDIR)/var/lib/matchbox/scripts