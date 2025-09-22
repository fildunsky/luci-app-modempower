module("luci.controller.modem_power", package.seeall)

local fs    = require "nixio.fs"
local util  = require "luci.util"
local sys   = require "luci.sys"

-- Путь к sysfs GPIO
local VALUE = "/sys/class/gpio/modem_power/value"

-- Длительность «выключающего» фронта (мс)
local PULSE_MS = 500

local function board_name()
  local b = fs.readfile("/tmp/sysinfo/board_name") or ""
  return util.trim(b):lower()
end

-- Определяем, какой уровень означает «питание ВКЛ» (on_level)
-- Приоритет: /etc/modem_power.onlevel -> по модели -> текущее значение (как запасной вариант)
local function detect_on_level()
  local override = fs.readfile("/etc/modem_power.onlevel")
  if override then
    override = util.trim(override)
    if override == "0" or override == "1" then
      return override
    end
  end

  local b = board_name()
  if b:find("wh3000") then
    -- Huasifei WH3000 Pro: ON = 0, импульс 1 -> 0
    return "0"
  elseif b:find("tr3000") then
    -- Cudy TR3000: ON = 1, импульс 0 -> 1
    return "1"
  end

  -- fallback: используем текущее значение как "включённый" уровень
  local v = fs.readfile(VALUE) or "1"
  v = (v:gsub("%s+", ""))
  if v ~= "0" and v ~= "1" then v = "1" end
  return v
end

local function write_value(v)
  if v == "0" or v == "1" then
    return fs.writefile(VALUE, v)
  end
end

-- Послать импульс: OFF (инверсный к on_level) -> пауза -> ON (on_level)
local function do_pulse()
  local on = detect_on_level()
  local off = (on == "1") and "0" or "1"

  -- неблокирующе в фоне, чтобы страница сразу вернулась
  sys.call(string.format("(echo %s > %q; usleep %d; echo %s > %q) >/dev/null 2>&1 &",
    off, VALUE, PULSE_MS * 1000, on, VALUE))
end

function index()
  if not fs.access(VALUE) then return end

  -- Корень меню "Modem" (если уже есть — просто объединится)
  local root = entry({"admin", "modem"}, firstchild(), _("Modem"), 50)
  root.dependent = false

  -- Единственная страница с кнопкой
  entry({"admin", "modem", "power"}, call("action_index"), _("Power"), 30)
  entry({"admin", "modem", "power", "reboot"}, call("action_reboot")).leaf = true
end

function action_index()
  require "luci.template".render("modem_power/index", {
    value_path = VALUE
  })
end

function action_reboot()
  do_pulse()
  luci.http.redirect(luci.dispatcher.build_url("admin/modem/power"))
end

