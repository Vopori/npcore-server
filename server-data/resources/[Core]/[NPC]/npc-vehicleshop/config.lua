Cfg = {}

Cfg.PlateLetters  = 3
Cfg.PlateNumbers  = 4
Cfg.PlateUseSpace = false

Cfg.SpawnVehicle = true  -- TRUE if you want spawn vehicle when buy

Cfg.TestDrive = true     -- TRUE if you want enable test drive
Cfg.TestDriveTime = 30   -- TIME in SEC

Cfg.Blips = {
    [1] = {
        blip = vector3(-56.49, -1096.58, 26.42),
        blipname = 'Simeons',
        blipsprite = 326,
        blipcolor = 3
    },
    [2] = {
        blip = vector3(-773.7, -1495.2, 2.6),
        blipname = 'Boat Shop',
        blipsprite = 427,
        blipcolor = 3
    }
}

Cfg.Npc = {
	[1] = {
		Model = 'cs_nigel',
		PType = 5,
		Pos = { x = -33.57, y = -1099.53, z = 25.42, h = 96.2 },
		category = 'pdm'
	}
}

Cfg.Shops = {
    [1] = {
        category = 'pdm', -- Change ["shop"] in hkb-core/shared.lua to match this for the vehicles you want
        coords = vector3(-33.57, -1099.53, 25.42),
		--coords = vector3(-56.49, -1096.58, 26.42), -- For Marker
        spawnvehicle = vector4(990.42, -3002.08, -39.63, 132.8), -- Display Point
        --spawnvehicle = vector4(978.19, -3001.99, -40.62, 89.5), -- Display Point
        cameracoords = vector3(984.7, -3005.0, -39.0), -- Where To Create Camera
        --cameracoords = vector3(974.1, -2997.94, -39.00), -- Where To Create Camera
        pointcamera = vector3(990.42, -3002.08, -39.63), -- Where To Point Camera
        buyspawn = vector4(-11.87, -1080.87, 25.71, 132.0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(-11.87, -1080.87, 26.71, 132.0)
        --testdrive = {
		--	{vector4(-11.87, -1080.87, 26.71, 132.0)},
		--	{vector4(-11.3, -1096.98, 25.67, 102.17)},
		--	{vector4(-14.93, -1107.99, 26.67, 103.49)},
		--}
    },
    [2] = {
        category = 'police',
        coords = vector3(454.6, -1017.4, 28.4),
        spawnvehicle = vector4(228.28, -992.3, -99.39, 204.73), -- Display Point
        cameracoords = vector3(227.41, -999.59, -99.0), -- Where To Create Camera
        pointcamera = vector3(228.28, -992.3, -99.39), -- Where To Point Camera
        buyspawn = vector4(-11.87, -1080.87, 25.71, 132.0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(-11.87, -1080.87, 25.71, 132.0) -- Where Vehicle Spawns on Test Drive
    },
    [3] = {
        category = 'ambulance',
        coords = vector3(0, 0, 0), -- Marker Point
        spawnvehicle = vector4(0, 0, 0, 0), -- Display Point
        cameracoords = vector3(0, 0, 0), -- Where To Create Camera
        pointcamera = vector3(0, 0, 0), -- Where To Point Camera
        buyspawn = vector4(0, 0, 0, 0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(0, 0, 0, 0) -- Where Vehicle Spawns on Test Drive
    },
    [4] = {
        category = 'mechanic',
        coords = vector3(0, 0, 0), -- Marker Point
        spawnvehicle = vector4(0, 0, 0, 0), -- Display Point
        cameracoords = vector3(0, 0, 0), -- Where To Create Camera
        pointcamera = vector3(0, 0, 0), -- Where To Point Camera
        buyspawn = vector4(0, 0, 0, 0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(0, 0, 0, 0) -- Where Vehicle Spawns on Test Drive
    },
    [5] = {
        category = 'motorcycle',
        coords = vector3(0, 0, 0), -- Marker Point
        spawnvehicle = vector4(0, 0, 0, 0), -- Display Point
        cameracoords = vector3(0, 0, 0), -- Where To Create Camera
        pointcamera = vector3(0, 0, 0), -- Where To Point Camera
        buyspawn = vector4(0, 0, 0, 0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(0, 0, 0, 0) -- Where Vehicle Spawns on Test Drive
    },
    [6] = {
        category = 'offroad',
        coords = vector3(0, 0, 0), -- Marker Point
        spawnvehicle = vector4(0, 0, 0, 0), -- Display Point
        cameracoords = vector3(0, 0, 0), -- Where To Create Camera
        pointcamera = vector3(0, 0, 0), -- Where To Point Camera
        buyspawn = vector4(0, 0, 0, 0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(0, 0, 0, 0) -- Where Vehicle Spawns on Test Drive
    },
    [7] = {
        category = 'boat',
        coords = vector3(-773.7, -1495.2, 2.6), -- Marker Point
        spawnvehicle = vector4(-801.36, -1504.19, -0.09, 290.76), -- Display Point
        cameracoords = vector3(-789.71, -1501.12, 4.59), -- Where To Create Camera
        pointcamera = vector3(-801.36, -1504.19, -0.09), -- Where To Point Camera
        buyspawn = vector4(-801.36, -1504.19, -0.09, 290.76), -- Where Vehicle Spawns on Buy
        testdrive = vector4(-801.36, -1504.19, -0.09, 290.76) -- Where Vehicle Spawns on Test Drive
    },
    [8] = {
        category = 'donator',
        coords = vector3(0, 0, 0), -- Marker Point
        spawnvehicle = vector4(0, 0, 0, 0), -- Display Point
        cameracoords = vector3(0, 0, 0), -- Where To Create Camera
        pointcamera = vector3(0, 0, 0), -- Where To Point Camera
        buyspawn = vector4(0, 0, 0, 0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(0, 0, 0, 0) -- Where Vehicle Spawns on Test Drive
    },
    [9] = {
        category = 'airplane',
        coords = vector3(0, 0, 0), -- Marker Point
        spawnvehicle = vector4(0, 0, 0, 0), -- Display Point
        cameracoords = vector3(0, 0, 0), -- Where To Create Camera
        pointcamera = vector3(0, 0, 0), -- Where To Point Camera
        buyspawn = vector4(0, 0, 0, 0), -- Where Vehicle Spawns on Buy
        testdrive = vector4(0, 0, 0, 0) -- Where Vehicle Spawns on Test Drive
    }
}

Cfg.ShowroomVehicles = {
    [1] = {
        coords = vector4(-45.65, -1093.66, 25.44, 119.6),
        defaultVehicle = 'adder',
        chosenVehicle = 'adder',
    },
    [2] = {
        coords = vector4(-48.27, -1101.86, 25.44, 294.5),
        defaultVehicle = 'schafter2',
        chosenVehicle = 'schafter2',
    },
    [3] = {
        coords = vector4(-39.6, -1096.01, 25.44, 118.4),
        defaultVehicle = 'fk8',
        chosenVehicle = 'fk8',
    },
    [4] = {
        coords = vector4(-51.21, -1096.77, 25.44, 254.5),
        defaultVehicle = 'vigero',
        chosenVehicle = 'vigero',
    },
    [5] = {
        coords = vector4(-40.18, -1104.13, 25.44, 338.5),
        defaultVehicle = 't20',
        chosenVehicle = 't20',
    },
    [6] = {
        coords = vector4(-42.48, -1094.92, 26.42, 125.25),
        defaultVehicle = 'r1',
        chosenVehicle = 'r1',
    },
    [7] = {
        coords = vector4(-50.66, -1093.05, 25.44, 222.5),
        defaultVehicle = 'akuma',
        chosenVehicle = 'akuma',
    },
    [8] = {
        coords = vector4(-44.28, -1102.47, 25.44, 298.5),
        defaultVehicle = 'daemon2',
        chosenVehicle = 'daemon2',
    }
}