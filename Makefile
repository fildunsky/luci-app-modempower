# Copyright 2025 Fil Dunsky
# Licensed under the GNU General Public License v2

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-modempower
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_MAINTAINER:=Fil Dunsky <filipp.dunsky@gmail.com>

include $(INCLUDE_DIR)/package.mk

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

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

define Package/$(PKG_NAME)/postinst
endef

define Package/$(PKG_NAME)/prerm
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

