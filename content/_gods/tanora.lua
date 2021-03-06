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

local class = require('base.class')
local baseelder = require("content._gods.baseelder")
local common = require('base.common')

local M = {}

M.Tanora = class(
    baseelder.BaseElder,
    function(self, ...)
        self:_init(...)
    end
)

function M.Tanora:_init(ordinal, elderOrdinal)
    baseelder.BaseElder._init(self, ordinal, elderOrdinal) -- call the base class constructor
    self.nameDe = "Tanora"
    self.nameEn = "Tanora"
    self.descriptionDe = "die G�ttin des Wassers"
    self.descriptionEn = "Goddess of water"
    self.devotionItems = {
        {id = 2554, number = 1}, -- pure water
        {id = 1053, number = 1}, -- divine voulge
        {id = 193, number = 1}, -- blue robe
    }
    self.sacrificeItems = {  -- array of tables defining groups of items for sacrificing
        {  -- FIXME
            id_set = common.setFromList({ -- set of item IDs
                2554, -- pure water
                2784, -- wand of water
            }),
            minimal_quality = 0, -- int in 1..9 - if present, item quality has to be greater or equal
            minimal_durability = 0, -- int in 0..99 - if present, item durability has to be greater or equal
            value_multiplier = 1, -- float -- the monetary value gets multiplied by this
        },
    }

end



return M