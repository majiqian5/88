TARGET = iphone:clang:16.5:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/tweak.mk

TWEAK_NAME = LockPlayerMini

LockPlayerMini_FILES = Hooks/Tweak.xm
LockPlayerMini_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
LockPlayerMini_FRAMEWORKS = UIKit CoreGraphics

BUNDLE_NAME = lockplayerPrefs
lockplayerPrefs_FILES = Preferences/lockplayerPrefs/RootListController.m
lockplayerPrefs_CFLAGS = -fobjc-arc
lockplayerPrefs_PRIVATE_FRAMEWORKS = Preferences
lockplayerPrefs_INSTALL_PATH = /Library/PreferenceBundles
lockplayerPrefs_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/aggregate.mk
