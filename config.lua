
Config = {}

-- Initial item prices
Config.ItemPrices = {
    ["item1"] = 100,
    ["item2"] = 150,
    ["item3"] = 200
}

-- Fluctuation parameters (as percentages)
Config.PriceFluctuation = {
    MinChange = -5,  -- minimum price change in percentage
    MaxChange = 5,   -- maximum price change in percentage
    Interval = 60000  -- interval for price change in milliseconds (e.g., 60000 = 1 minute)
}

-- Demand-based pricing parameters
Config.DemandPricing = {
    PriceIncreasePerItem = 2,  -- increase price by 2% for each item bought
    SaveInterval = 300000  -- save prices every 5 minutes
}
