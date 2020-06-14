# Not file targets.
.PHONY: help install install-scripts install-conf install-systemd

### Macros ###
SRCS_SCRIPTS	= $(wildcard usr/local/sbin/*)
SRCS_CONF	= $(filter-out %template, $(wildcard etc/restic_helper/*))
SRCS_SYSTEMD	= $(wildcard etc/systemd/system/*)

# Just set PREFIX in envionment, like
# $ PREFIX=/tmp/test make
DEST_SCRIPTS	= $(PREFIX)/usr/local/sbin
DEST_CONF	= $(PREFIX)/etc/restic_helper
DEST_SYSTEMD	= $(PREFIX)/etc/systemd/system

### Targets ###
# target: all - Default target.
all: install

# target: help - Display all targets.
help:
	@egrep "#\starget:" [Mm]akefile	| sed 's/\s-\s/\t\t\t/' | cut -d " " -f3- | sort -d

# target: install - Install all files
install: install-scripts install-conf install-systemd

# target: install-scripts - Install executables.
install-scripts:
	install -d $(DEST_SCRIPTS)
	install -m 0744 $(SRCS_SCRIPTS) $(DEST_SCRIPTS)

etc/restic_helper/config.sh:
	[ -f $(DEST_CONF)/config.sh ] || install -m 0600 etc/restic_helper/config.sh.template $(DEST_CONF)/config.sh

etc/restic_helper/restic_excludes.txt:
	[ -f $(DEST_CONF)/restic_excludes.txt ] || install -m 0600 etc/restic_helper/restic_excludes.txt $(DEST_CONF)/restic_excludes.txt

etc/restic_helper/restic_pw.txt:
	[ -f $(DEST_CONF)/restic_pw.txt ] || install -m 0600 etc/restic_helper/restic_pw.txt.template $(DEST_CONF)/restic_pw.txt

# target: install-conf - Install restic configuration files.
# will create these files locally only if they don't already exist
install-conf: | etc/restic_helper/config.sh etc/restic_helper/restic_pw.txt etc/restic_helper/restic_excludes.txt
	install -d $(DEST_CONF)
	install -m 0600 $(SRCS_CONF) $(DEST_CONF)

# target: install-systemd - Install systemd timer and service files
install-systemd:
	install -d $(DEST_SYSTEMD)
	install -m 0644 $(SRCS_SYSTEMD) $(DEST_SYSTEMD)
