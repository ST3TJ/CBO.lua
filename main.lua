ui.tab('CBO')
CBO = ui.groupbox('CBO', 'CBO')
custom_resolver = CBO:checkbox('Custom resolver')

function Custom_resolver()
    for i = 1, globals.max_players do
        ---@type player
        player = entity.get(i)

        if player ~= nil then
            if player:is_player() == true then
                if player:is_alive() == true then
                    animlayers = player:get_animlayers()

                    animlayers[1].weight = math.random()
                    animlayers[4].cycle = math.random()
                    animlayers[9].weight = math.random()
                    animlayers[11].cycle = math.random()
                    animlayers[11].weight = math.random()
                end
            end
        end
    end
end



client.add_callback('post_anim_update', function()
    if custom_resolver:get() == true then
        Custom_resolver()
    end
end)