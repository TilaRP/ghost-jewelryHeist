Config = {}

-- policias necessarios para fazer assalto
Config.PoliciasNecessarios = 4

-- tempo ate se poder fazer outro assalto
Config.Timeout = 300 * 1000

-- tempo para notificar a policia
Config.TempoNotificarPolicia = 10000

-- dinheiro do saque
Config.SaqueMin = 5000
Config.SaqueMax = 12000

-- local para iniciar o assalto
Config.IniciarAssalto = {x = -629.78, y = -236.47, z = 38.06}

-- local para roubar a caixa
Config.RoubarCaixa = {x = -622.26, y = -229.95, z = 38.06}

-- tempo para roubar vitrine
Config.TempoRoubarVitrine = 5000

-- tempo para roubar a caixa
Config.TempoRoubarCaixa = 7500

-- vitrines assaltaveis
Config.Vitrines = {
    {x = -626.67,  y = -238.58,  z = 38.06, h = 215.44, roubada = false},
    {x = -625.65,  y = -237.82 , z = 38.06, h = 215.44, roubada = false},

    {x = -626.81,  y = -235.36 , z = 38.06, h = 32.34, roubada  = false},
    {x = -625.78,  y = -234.57,  z = 38.06, h = 32.34, roubada  = false},
    {x = -627.99,  y = -233.91,  z = 38.06, h = 215.44, roubada = false},
    {x = -626.93,  y = -233.13 , z = 38.06, h = 215.44, roubada = false},

    {x = -620.23,  y = -234.46,  z = 38.06, h = 215.44, roubada = false},
    {x = -619.20,  y = -233.72,  z = 38.06, h = 215.44, roubada = false},

    {x = -617.54,  y = -230.56,  z = 38.06, h = 305.14, roubada = false},
    {x = -618.31,  y = -229.49,  z = 38.06, h = 305.14, roubada = false},
    {x = -619.66,  y = -227.63,  z = 38.06, h = 305.14, roubada = false},
    {x = -620.45,  y = -226.57,  z = 38.06, h = 305.14, roubada = false},

    {x = -623.87,  y = -227.06,  z = 38.06, h = 32.34, roubada  = false},
    {x = -624.92,  y = -227.8,   z = 38.06, h = 32.34, roubada  = false},

    {x = -623.15 , y = -232.97 , z = 38.06, h = 305.14, roubada = false},
    {x = -622.57 , y = -233.60,  z = 38.06, h = 305.14, roubada = false},

    {x = -620.91 , y = -233.88 , z = 38.06, h = 32.34, roubada  = false},
    {x = -620.16 , y = -233.37 , z = 38.06, h = 32.34, roubada  = false},
    {x = -619.37 , y = -232.87 , z = 38.06, h = 32.34, roubada  = false},

    {x = -619.16 , y = -231.17 , z = 38.06, h = 121.66, roubada = false},
    {x = -619.73 , y = -230.43 , z = 38.06, h = 121.66, roubada = false},
    {x = -620.98 , y = -228.53 , z = 38.06, h = 121.66, roubada = false},
    {x = -621.57 , y = -227.86 , z = 38.06, h = 121.66, roubada = false},

    {x = -623.21 , y = -227.6 ,  z = 38.06, h = 215.44, roubada = false},
    {x = -623.95 , y = -228.15 , z = 38.06, h = 215.44, roubada = false},
    {x = -624.73 , y = -228.69 , z = 38.06, h = 215.44, roubada = false},

    {x = -624.94 , y = -230.38 , z = 38.06, h = 305.14, roubada = false},
    {x = -624.43 , y = -231.04 , z = 38.06, h = 305.14, roubada = false}
}