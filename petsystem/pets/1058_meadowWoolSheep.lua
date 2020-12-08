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

local M = require("petsystem.pets.base")
local base = require("petsystem.base")

local dog = require("petsystem.pets.1056_gynkeseGuardDog").petProperties

M.petProperties = {

    monsterId = 1058,
    nameDe = "Weidenwollschaf",
    nameEn = "Meadow Wool Sheep",
    descriptionDe = "A cheerful sheep, praised for its fluffy wool.",
    descriptionEn = "Ein fröhliches Schaf. Beliebt für seine fluffige Wolle.",
    downEmotes = {english = "#me setzt sich auf den Boden.", german = "#me setzt sich auf den Boden."},
    tooFarAwayCry = "M���������h!",
    validCommands = {[base.follow] = true, [base.heel] = true, [base.down] = true, [base.nearBy] = true, [base.stray] = true},
    colour = colour(255, 255, 255),
    priceInGold = 15

}

return M