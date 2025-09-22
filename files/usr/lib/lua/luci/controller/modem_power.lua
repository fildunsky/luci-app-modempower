module("luci.controller.modem_power", package.seeall)

local fs = require "nixio.fs"
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
  if not fs.access(VALUE) then return end
  entry({"admin","system","modem_power"}, call("action_index"), _("Modem Power"), 90)
  entry({"admin","system","modem_power","set"}, call("action_set")).leaf = true
end

function action_index()
  require "luci.template".render("modem_power/index", { state = read_value() })
end

function action_set()
  local v = http.formvalue("v")
  write_value(v)
  http.redirect(luci.dispatcher.build_url("admin/system/modem_power"))
end
