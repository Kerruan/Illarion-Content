--[[
Illarion Server

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local monsterId = 524

local base = require("monster.base.base")
local monstermagic = require("monster.base.monstermagic")
local raptors = require("monster.race_52_raptor.base")
local firefield = require("item.id_359_firefield")
local M = raptors.generateCallbacks()

local orgOnSpawn = M.onSpawn
function M.onSpawn(monster)
    if orgOnSpawn ~= nil then
        orgOnSpawn(monster)
    end

    base.setColor{monster = monster, target = base.SKIN_COLOR, red = 255, green = 100, blue = 100}
end

local magic = monstermagic()

magic.addFirecone{probability = 0.05,  damage = {from = 1250, to = 1500}, range = 6, angularAperture = 30,
    itemProbability = 0.1, quality = {from = 0, to = 1}}
magic.addFirecone{probability = 0.005,  damage = {from = 1400, to = 1800}, range = 3, angularAperture = 30,
    itemProbability = 0.05, quality = {from = 1, to = 2}}


firefield.setFlameImmunity(monsterId)

return magic.addCallbacks(M)