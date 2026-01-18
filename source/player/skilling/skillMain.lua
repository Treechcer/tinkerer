skills = {
    f = {},
    skillStatAdds = {
        foraging = function (lvl)
            player.atributes.foragingLuck = player.atributes.foragingLuck + (0.1 * lvl)
        end,
        crafting = function (lvl)
            --TODO implement crafting upgrades
        end,
        mining = function (lvl)
            player.atributes.miningLuck = player.atributes.miningLuck + (0.1 * lvl)
        end,
        walking = function (lvl)
            player.atributes.speed = 250 + lvl * 8
        end,
        engineering = function (lvl)
            --TODO implement engineering upgrades
        end,
        fighting = function (lvl)
            --TODO implement fighting upgrades
        end,
        defense = function (lvl)
            --TODO implement defense upgrades
        end,
        merchanting = function (lvl)
            --TODO implement merchanting upgrades
        end,
    }
}

function skills.f.addXP(skills)
    --skills is just table with name of skill (as key) and as value the XP value, it can have more skills
    for key, value in pairs(skills) do
        player.skills[key] = player.skills[key] + value 
    end
end

function skills.f.xpCountNext(lvl)
    --[[desmos calculator formula:

    y\ =\ \left\{0<x\ \le\ 10\right\}D\cdot\left(x^{2}+nx+b\right)\left(1+\frac{x}{\left(p\right)}\right)

    limit 0 - 10 is because 10 is max, it might change ofc

    ]]
    base = 25
    factor = 4
    diff = game.settings.difficulty
    exp = 3

    return diff * (lvl^2 + factor * lvl + base) * (1 + (lvl / exp))
end

function skills.f.addStatsAfterLVL(skill)
    skill.skillStatAdds[skill](player.skills[skill].lvl)
end

function skills.f.levelUp(skills)
    local function checkLVL(skill)
        local pSkill = player.skills[skill]

        if pSkill == nil then
            return false
        end

        if pSkill.xp < pSkill.xpForNextLvl then
            return false
        end
        local r = false
        
        while pSkill.xp >= pSkill.xpForNextLvl do
            pSkill.xp = pSkill.xp - pSkill.xpForNextLvl
            pSkill.lvl = pSkill.lvl + 1
            pSkill.xpForNextLvl = skills.f.xpCountNext(pSkill.lvl)
            r = true
            skills.f.addStatsAfterLVL(skill)
        end

        return r
    end

    for index, skill in ipairs(skills) do
        checkLVL(skill)
    end
end

return skills