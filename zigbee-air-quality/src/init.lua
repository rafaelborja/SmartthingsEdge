-- Copyright 2021 SmartThings
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local capabilities = require "st.capabilities"
local ZigbeeDriver = require "st.zigbee"
local device_management = require "st.zigbee.device_management"
local defaults = require "st.zigbee.defaults"
local clusters = require "st.zigbee.zcl.clusters"
local constants = require "st.zigbee.constants"
local RelativeHumidity = clusters.RelativeHumidity


local zigbee_humidity_driver = {
  supported_capabilities = {
    capabilities.relativeHumidityMeasurement,
    capabilities.temperatureMeasurement,
    capabilities.tvocMeasurement,
    capabilities.carbonDioxideMeasurement,
  },
  sub_drivers = { require("plant-link"), require("plaid-systems") },
}

defaults.register_for_default_handlers(zigbee_humidity_driver, zigbee_humidity_driver.supported_capabilities)
local driver = ZigbeeDriver("zigbee-humidity-sensor", zigbee_humidity_driver)
driver:run()


-- Crie o cluster tuya
-- //    #             cmd | status | transId | dp | DataType | fn | len | Data
-- //    #              01     00        00     0x12     02        00   04    00000101   257   --- Temperature
-- //    #              01     00        00     0x13     02        00   04    0000018d   397   --- Humidity  Confirmed
-- //    #              01     00        01     0x16     02        00   04    00000002     2   --- 0.002 ppm Formaldéhyde détécté
-- //    #              01     00        01     0x15     02        00   04    00000001     1   --- VOC 0.1 ppm - Confirmed
-- //    #              01     00        01     0x02     02        00   04    00000172   370   --- CO2 - Confirmed
-- private getCLUSTER_TUYA() { 0xEF00 }
-- private getSETDATA() { 0x00 }
-- private getSETTIME() { 0x24 }