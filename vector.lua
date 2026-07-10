local vector = {}

vector.copy = function(table)
    local result = {}
    for key, value in pairs(table) do
        result[key] = value
    end
    return result
end

vector.multiply = function(table, multiplier)
    for key, value in pairs(table) do
        table[key] = value * multiplier
    end
    return table
end

vector.divide = function(table, divisor)
    for key, value in pairs(table) do
        table[key] = value / divisor
    end
    return table
end

vector.add = function(result, table)
    for key, value in pairs(table) do
        if result[key] then
            result[key] = result[key] + value
            goto continue
        end
        result[key] = value
        ::continue::
    end
end

vector.linear_combine = function(result, table, multiplier)
    for key, value in pairs(table) do
        if result[key] then
            result[key] = result[key] + value * multiplier
            goto continue
        end
        result[key] = value
        ::continue::
    end
    return result
end