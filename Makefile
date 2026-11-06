ARCHS = arm64 arm64e
TARGET = iphone:clang:15.0:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

# Tweak本体
TWEAK_NAME = LockPlayerMini
LockPlayerMini_FILES = Hooks/Tweak.m
LockPlayerMini_FRAMEWORKS = UIKit CoreFoundation QuartzCore
LockPlayerMini_CFLAGS = -fobjc-arc

# 设置面板 PreferenceBundle
BUNDLE_NAME = LockPlayerMiniPref
LockPlayerMiniPref_FILES = Preferences/lockplayerPrefs/RootVC.m
LockPlayerMiniPref_FRAMEWORKS = UIKit
LockPlayerMiniPref_CFLAGS = -fobjc-arc
LockPlayerMiniPref_INSTALL_PATH = /var/jb/Library/PreferenceBundles

# 控制中心CC模块
BUNDLE_NAME += CCLockPlayerSwitch
CCLockPlayerSwitch_FILES = CC/CCLockPlayerSwitch.m
CCLockPlayerSwitch_FRAMEWORKS = UIKit ControlCenterUI
CCLockPlayerSwitch_CFLAGS = -fobjc-arc
CCLockPlayerSwitch_INSTALL_PATH = /var/jb/Library/ControlCenter/CCModules

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk
