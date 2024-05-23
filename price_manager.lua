-- Load the config
Config = Config or {}

-- Function to adjust prices based on market fluctuations
function AdjustPrices()
    for item, price in pairs(Config.ItemPrices) do
        -- Generate a random percentage change
        local percentageChange = math.random(Config.PriceFluctuation.MinChange, Config.PriceFluctuation.MaxChange)
        
        -- Calculate the price change based on the percentage
        local priceChange = price * (percentageChange / 100)
        
        -- Apply the price change
        Config.ItemPrices[item] = price + priceChange
        
        -- Ensure price doesn't go below a certain threshold (e.g., 0)
        if Config.ItemPrices[item] < 0 then
            Config.ItemPrices[item] = 0
        end
        
        -- Optionally, print the new prices to the console for debugging
        print(string.format("New price for %s: %.2f (Change: %.2f%%)", item, Config.ItemPrices[item], percentageChange))
    end
end

-- Function to adjust prices based on demand
function AdjustPricesOnDemand(item, quantity)
    local priceIncrease = Config.ItemPrices[item] * (Config.DemandPricing.PriceIncreasePerItem / 100) * quantity
    Config.ItemPrices[item] = Config.ItemPrices[item] + priceIncrease

    -- Ensure price doesn't go below a certain threshold (e.g., 0)
    if Config.ItemPrices[item] < 0 then
        Config.ItemPrices[item] = 0
    end

    -- Optionally, print the new prices to the console for debugging
    print(string.format("New price for %s after demand: %.2f (Purchased: %d)", item, Config.ItemPrices[item], quantity))
end

-- Function to save prices to a file (Server-side only)
function SavePrices()
    local json = json.encode(Config.ItemPrices)
    SaveResourceFile(GetCurrentResourceName(), "prices.json", json, -1)
end

-- Function to load prices from a file (Server-side only)
function LoadPrices()
    local json = LoadResourceFile(GetCurrentResourceName(), "prices.json")
    if json then
        Config.ItemPrices = json.decode(json)
    end
end

-- Set up a timer to adjust prices at regular intervals
Citizen.CreateThread(function()
    while true do
        AdjustPrices()
        Citizen.Wait(Config.PriceFluctuation.Interval)
    end
end)

-- Save prices at regular intervals (Server-side only)
Citizen.CreateThread(function()
    while true do
        SavePrices()
        Citizen.Wait(Config.DemandPricing.SaveInterval)  -- Save every configured interval
    end
end)
