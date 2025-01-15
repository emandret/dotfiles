# Author: Edwy Mandret <emandret@student.42.fr>

SCRIPT_PATH := $(HOME)/Library/Scripts/keyremap.sh
PLIST_PATH := $(HOME)/Library/LaunchAgents/user.keyremap.plist

install:
	mkdir -p $$(dirname $(SCRIPT_PATH))
	mkdir -p $$(dirname $(PLIST_PATH))
	cp keyremap.sh $(SCRIPT_PATH) && chmod +x $(SCRIPT_PATH)
	sed -i '.bak' -e 's#@SCRIPT_PATH@#$(SCRIPT_PATH)#g' user.keyremap.plist
	mv user.keyremap.plist $(PLIST_PATH)
	mv user.keyremap.plist.bak user.keyremap.plist
	launchctl load -w $(PLIST_PATH)
	launchctl start user.keyremap

uninstall:
	rm -f $(SCRIPT_PATH)
	rm -f $(PLIST_PATH)
	launchctl remove user.keyremap

.PHONY: install uninstall
