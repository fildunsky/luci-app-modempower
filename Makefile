# Copyright 2025 Fil Dunsky
# Licensed under the GNU General Public License v2

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-modempower
PKG_VERSION:=1.1
PKG_RELEASE:=1

PKG_MAINTAINER:=Fil Dunsky <filipp.dunsky@gmail.com>

LUCI_TITLE:=USB modem reboot via GPIO
LUCI_DEPENDS:=+luci
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=USB modem reboot via GPIO
  DEPENDS:=+luci-base
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
  Simple LuCI interface to switch send echo to proper gpio to switch off/on (reboot) USB power
endef

include $(TOPDIR)/feeds/luci/luci.mk
# call BuildPackage - OpenWrt buildroot signature

