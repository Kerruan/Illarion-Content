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

local pressing = require("craft.intermediate.pressing")
local wood = require("item.general.wood")
local skillTransfer = require("base.skillTransfer")

local M = {}

M.LookAtItem = wood.LookAtItem

function M.UseItem(User, SourceItem, ltstate)
    if skillTransfer.skillTransferInformCookingHerbloreFarming(User) then
        return
    end
    pressing.pressing:showDialog(User, SourceItem)
end

return M