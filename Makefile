THEOS = /opt/theos
THEOS_DEVICE_IP = 192.168.10.2
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FPSTweak

FPSTweak_FILES = Tweak.xm
FPSTweak_FILES += FPSLabel.m

FPSTweak_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 SpringBoard"