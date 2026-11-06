ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0

include $(THEOS_MAKE_PATH)/tweak.mk

TWEAK_NAME = LockPlayerMini
LockPlayerMini_FILES = Hooks/Tweak.xm
LockPlayerMini_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
