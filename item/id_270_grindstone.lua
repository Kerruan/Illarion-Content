require("content.craft.gemcutting")

module("item.id_270_grindstone", package.seeall)

function UseItem(User, SourceItem, ltstate)
    content.craft.gemcutting.gemcutting:showDialog(User, SourceItem)
end