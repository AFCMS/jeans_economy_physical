local ids = {
    [10] = "jeans_economy_physical:coin10",
    [50] = "jeans_economy_physical:paper50",
    [100] = "jeans_economy_physical:paper100",
    [200] = "jeans_economy_physical:paper200",
    [500] = "jeans_economy_physical:paper500",
    [1000] = "jeans_economy_physical:paper1000"
}
local creative_mode_cache = minetest.settings:get_bool("creative_mode")

function is_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end

for i, v in pairs(ids) do
    local label = "Coins"

    if i == 1 then
        label = "Coin"
    end

    minetest.register_craftitem(
		v,{
		description = i .. " " .. label,
		inventory_image = v:gsub(":", "_") .. ".png",
		on_use = function(itemstack, player, pointed_thing)
			local player_name = player:get_player_name()
			local value = jeans_economy.get_account(player_name) + i
			local msg = "You get +"..i.." Minegeld"
			jeans_economy.set_account(player_name, value)
			minetest.chat_send_player(player_name, msg)
			if not is_creative(player:get_player_name()) then
				itemstack:take_item()
			end
		return itemstack
		end
	})

    if i ~= 1 then -- If paper
        -- Because why not
        minetest.register_craft(
            {
                type = "fuel",
                recipe = v,
                burntime = 1
            }
        )
    end
end
