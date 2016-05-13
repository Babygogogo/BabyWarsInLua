
local WarScene_Test2 = {
    warField = {
        tileMap = {
            template = "FullTest",

            grids = {
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 5},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 18, y = 5},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 5},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 4},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 3},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 18, y = 3},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 3},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 2},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 17, y = 1},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 18, y = 1},
                    },
                    objectID = 107,
                },
                {
                    GridIndexable = {
                        gridIndex = {x = 19, y = 1},
                    },
                    objectID = 107,
                },
            },
        },

        unitMap = {
            template = "FullTest",

            grids = {
                -- There's a template map, so that the grids data is ignored even if it's not empty.
            },
        },
    },

    turn = {
        turnIndex   = 1,
        playerIndex = 1,
        phase       = "beginning",
    },

    players = {
        {
            account       = "babygogogo",
            nickname      = "Red Alice",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 1,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 2,
            },
            activeSkill2 = {
                energyRequirement = 3,
            },
        },
        {
            account       = "tester1",
            nickname      = "Blue Bob",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 2,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 4,
            },
            activeSkill2 = {
                energyRequirement = 6,
            },
        },
        {
            account       = "tester2",
            nickname      = "Yellow Cat",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 3,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 6,
            },
            activeSkill2 = {
                energyRequirement = 9,
            },
        },
        {
            account       = "tester3",
            nickname      = "Black Dog",
            fund          = 0,
            isAlive       = true,
            currentEnergy = 4,
            passiveSkill = {

            },
            activeSkill1 = {
                energyRequirement = 8,
            },
            activeSkill2 = {
                energyRequirement = 12,
            },
        },
    },

    weather = {
        current = "clear"
    },
}

return WarScene_Test2
