module("luci.controller.modem_power", package.seeall)

local fs   = require "nixio.fs"
local http = require "luci.http"

local VALUE = "/sys/class/gpio/modem_power/value"

local function read_value()
  local v = fs.readfile(VALUE)
  if not v then return nil end
  v = (v:gsub("%s+", ""))
  return (v == "1") and 1 or 0
end

local function write_value(v)
  if v == "0" or v == "1" then
    return fs.writefile(VALUE, v)
  end
end

function index()
  -- если файла нет, пункт меню не показываем
  if not fs.access(VALUE) then return end

  -- создаём корневой раздел "Modem", если его ещё нет
  local root = entry({"admin", "modem"}, firstchild(), _("Modem"), 50)
  root.dependent = false

  -- сама страница в Modem → Power
  entry({"admin", "modem", "power"}, call("action_index"), _("Power"), 30)
  entry({"admin", "modem", "power", "set"}, call("action_set")).leaf = true
end

function action_index()
  require "luci.template".render("modem_power/index", { state = read_value() })
end

function action_set()
  local v = http.formvalue("v")
  write_value(v)
  http.redirect(luci.dispatcher.build_url("admin/modem/power"))
end

