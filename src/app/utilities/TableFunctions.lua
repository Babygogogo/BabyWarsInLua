
local TableFunctions = {}

function TableFunctions.appendList(list1, list2, additionalItem)
    assert(type(list1) == "table", "TableFunctions.appendList() the param list1 is invalid.")
    assert((type(list2) == "table") or (list2 == nil), "TableFunctions.appendList() the param list2 is invalid.")

    local length1, length2 = #list1, #(list2 or {})
    for i = 1, length2 do
        list1[length1 + i] = list2[i]
    end

    if (length2 > 0) then
        list1[length1 + length2 + 1] = additionalItem
    end
end

function TableFunctions.clone(t)
    local clonedTable = {}
    for k, v in pairs(t) do
        clonedTable[k] = v
    end

    return clonedTable
end

return TableFunctions
