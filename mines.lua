mines = {
    lights_amt = 8
}

function mines.enter(x)
    mines.x = x

    if not mines[x] then mines[x] = mines.generate() end
    mines[x]:eachEntity(function (ent)
        if ent.supertype == 'player' then mines[x]:despawn(ent) end
    end)
    mines[x]:spawn(currentmap.player)
    mines[x].player = currentmap.player
    mines[x].player.map = mines[x]
    mines[x].player.pos:set(12, -20)
    mines[x].player.vel:set(0, 1)

    currentmap = mines[x]

    mines.lighting = jam.gfx.addEffect('pre', { 'lighting',
        ambient = { 'vec', 0.0, 0.0, 0.0, 0.2 },
        light_positions = table.fill(mines.lights_amt, { 0.0, 0.0, 0.5 }),
        light_colors = table.fill(mines.lights_amt, { 1.0, 1.0, 0.0, 1.0 }) })
    mines.lights = {}
end

function mines.exit()
    jam.gfx.removeEffect('pre', mines.lighting)
end

function mines.light(x, y, intensity, r, g, b, a)
    local mine = mines[mines.x]
    table.insert(mines.lights, {
        position = { x - mine.scroll.x, y - mine.scroll.y, intensity },
        color = { r, g, b, a }
    })
end

function mines.update_lighting()
    table.clear(mines.lighting.light_positions)
    table.clear(mines.lighting.light_colors)

    for _, l in pairs(mines.lights) do
        table.insert(mines.lighting.light_positions, l.position)
        table.insert(mines.lighting.light_colors, l.color)
    end

    while #mines.lighting.light_positions < mines.lights_amt do
        table.insert(mines.lighting.light_positions, { 0.0, 0.0, 0.0 })
        table.insert(mines.lighting.light_colors, { 0.0, 0.0, 0.0, 0.0 })
    end

    table.clear(mines.lights)
end

function mines.generate(x)
    local map = Map:new({
        mine = {
            x = x
        }
    }, 12, 60)
    map:each(1, function (x, y, tile)
        tile.id = 19
    end)
    map:setArea(1, 1, 2, 1, 1, 3)
    map:setArea(1, 1, 3, 2, 2, 2)

    map:newlayer(2)
    map:each(2, function (x, y, tile)
        if map:get(1, x, y).id ~= 1 then
            if y > 0 and chance(0.05) then tile.id = 65 end
            if y > 12 then
                if chance(0.03) then tile.id = 66 end
                if chance(0.03) then tile.id = 67 end
                if y > 24 then
                    if chance(0.025) then tile.id = 68 end
                    if y > 36 then
                        if chance(0.01) then tile.id = 69 end
                        if chance(0.01) then tile.id = 70 end
                    end
                end
            end
        end
    end)
    -- greenium crystal
    do
        local x, y = love.math.random(1, map.width), love.math.random(42, map.height)
        map:set(71, 2, x, y)
    end
    maps.autoprocess(map)
    return map
end
