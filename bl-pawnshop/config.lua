Config = {}

Config.Job = 'brock_hard_pawn'
Config.CheckInterval = 5000
Config.pawnCoords = vec4(173.56, -1323.0, 29.36, 334.41)
Config.exporterPedCoords = vec4(155.8, -1314.37, 29.36, 237.0)
Config.exporterVanCoords = vec4(166.55, -1327.79, 29.08, 240.28)
Config.exprtDropOffCoords = vec3(1730.49, 3314.0, 41.22)
Config.exportDropOffPedCoords = vec4(1729.04, 3326.69, 41.22, 192.75)
Config.exportDropOffPed = 's_m_m_autoshop_02'
Config.exporterVanHash = 'bobcatxl'
Config.exporterPedHash = 's_m_m_autoshop_02'
Config.animDic = {'anim@amb@business@bgen@bgen_no_work@', 'stand_phone_phoneputdown_idle-noworkfemale'}

Config.Tray = { 
    label = 'Open Tray',
    stashLabel = 'Tray',
    coords = vec4(173.84, -1322.43, 29.36, 140.42),
    icon = 'fas fa-box-open',
    id = 'br_pawnshop_tray',
    slots = 15,
    weight = 800000,
    owner = nil,
    groups = nil
}

Config.BossStash = { 
    label = 'Open Stash',
    stashLabel = 'Boss Stash',
    coords = vector4(161.71, -1312.81, 28.63, 242.67),
    icon = 'fas fa-box-open',
    id = 'br_pawnshop_bossstash',
    slots = 25,
    weight = 5000000,
    owner = nil,
    groups = nil
}

Config.SellableItems = { 
    ["diamond_ring"] = 100,
    ["rolex"] = 200,
}
Config.ExporterSeller = {
    ["diamond_ring"] = 200,
    ["rolex"] = 400,
}

Config.Blips = { 
    {  
        enabled = true,
        sprite = 605,
        color =25,
        size = 1.0,
        name = 'Brock Hard Pawn',
        coords = vec4(175.06, -1321.72, 29.36, 284.59)
    },
}


Config.PawnBossInteraction = { -- Wouldnt Touch This Endless you read the dialog docs and using the dialog script
    enabled = false, -- Set to true if using https://github.com/ST4LTH-Development/dialog
    firstname = 'Brock',
    lastname = 'Lee',
    text = 'How are you? Im the manager around here. If you need anything let me know!',
    --rep = 10,
    buttons = {
        { 
            text = 'Id Like To Sell Some Stuff',
            event = 'bl_pawnshop:client:sellItems',
            server = false,
            close = true,
            
        },
        {
            text = 'How do i sell?',
            data = {
                text = 'All you do is go up to the counter and put your items in the tray!',
                buttons = {
                    {
                        text = 'Oh Ok Thanks!',
                        close = true,
                    },
                    {
                        text = 'Say Again?',
                        close = true,
                    }

                }
            }

        },
        { 
            text = 'I dont need anything sorry.',
            close = true
        },
    }
}
Config.ExporterInteraction = { -- Wouldnt Touch This Endless you read the dialog docs and using the dialog script
    enabled = false, -- Set to true if using https://github.com/ST4LTH-Development/dialog
    firstname = 'Porter',
    lastname = 'House',
    text = 'Hey there! Im in charge of shipping goods out of the city. Got anything for export?',
    --rep = 10,
    buttons = {
        { 
            text = 'Ive Got Goods to Export',
            event = 'bl_pawnshop:client:exporterVan', 
            server = false,
            close = true,
            
        },
        {
            text = 'How Does Exporting Work?',
            data = {
                text = 'Imma give you a mule to bring your goods to a certian location to meet with my guy',
                buttons = {
                    {
                        text = 'Oh Ok Thanks!',
                        close = true,
                    },
                    {
                        text = 'Say Again?',
                        close = true,
                    }

                }
            }

        },
        { 
            text = 'I dont need anything sorry.',
            close = true
        },
    }

}
