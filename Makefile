ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = M7MD

# Framework-lər
M7MD_FRAMEWORKS = IOKit UIKit Foundation Security QuartzCore CoreGraphics CoreText AVFoundation Accelerate GLKit SystemConfiguration GameController JRMemory

# Kitabxanalar
M7MD_LIBRARIES = c++ objc z

# Yollar və bayraqlar
M7MD_CFLAGS = -w -fobjc-arc -std=gnu++14 -fno-rtti -fno-exceptions -DNDEBUG -I/opt/theos/include -I.
M7MD_CCFLAGS = -w -std=gnu++14 -fno-rtti -fno-exceptions -DNDEBUG -Wno-module-import-in-extern-c

M7MD_LDFLAGS += -F$(THEOS_PROJECT_DIR) -framework JRMemory
M7MD_LDFLAGS += -L$(THEOS_PROJECT_DIR)/API -lAPIClient

# Yalnız kompilyasiya olunan mənbə faylları (.m, .mm, .cpp)
M7MD_FILES = $(wildcard View/*.mm) \
             $(wildcard View/*.m) \
             $(wildcard CustomView/*.m) \
             $(wildcard utils/*.cpp) \
             $(wildcard utils/*.m) \
             $(wildcard imgui/*.mm) \
             $(wildcard imgui/*.cpp) \
             $(wildcard ESP/*.mm) \
             $(wildcard ESP/*.cpp) \
             $(wildcard SDK/*.cpp) \
             $(wildcard NSURL+hook/*.m) \
             $(wildcard MBProgressHUD/*.m) \
             $(wildcard FCFileManager/*.m) \
             $(wildcard NSEtcHosts/*.m) \
             $(wildcard ZXURLProtocol/*.m) \
             $(wildcard EtcHostsURLProtocol/*.m) \
             $(wildcard NSObject+URL/*.m) \
             $(wildcard ViewController/*.m) \
             $(wildcard ZXHttpIPGet/*.m) \
             $(wildcard NSURLSession+ZXHttpProxy/*.m) \
             $(wildcard DBLOCKRASHID/*.m) \
             $(wildcard main/*.m) \
             $(wildcard 旁路/*.mm)

M7MD_RESOURCE_FILES = bypass.lua skin.lua
M7MD_INSTALL_PATH = /Library/Application Support/M7MD/

include $(THEOS_MAKE_PATH)/tweak.mk
