
--[[--------------------------------------------------------------------------------
-- ModelUnitInfo是战局场景里的unit的简要属性框（即场景下方的小框）。
--
-- 主要职责和使用场景举例：
--   - 构造和显示unit的简要属性框。
--   - 自身被点击时，呼出unit的详细属性页面。
--
-- 其他：
--  - 本类所显示的是光标所指向的unit的信息（通过event获知光标指向的是哪个unit）
--]]--------------------------------------------------------------------------------

local ModelUnitInfo = class("ModelUnitInfo")

local GridIndexFunctions  = requireBW("src.app.utilities.GridIndexFunctions")
local VisibilityFunctions = requireBW("src.app.utilities.VisibilityFunctions")
local SingletonGetters    = requireBW("src.app.utilities.SingletonGetters")

local getModelFogMap         = SingletonGetters.getModelFogMap
local getModelUnitMap        = SingletonGetters.getModelUnitMap
local getPlayerIndexLoggedIn = SingletonGetters.getPlayerIndexLoggedIn

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function isModelUnitVisible(self, modelUnit)
    if (self.m_IsWarReplay) then
        return true
    else
        return VisibilityFunctions.isUnitOnMapVisibleToPlayerIndex(
            self.m_ModelWar,
            modelUnit:getGridIndex(),
            modelUnit:getUnitType(),
            (modelUnit.isDiving) and (modelUnit:isDiving()),
            modelUnit:getPlayerIndex(),
            self.m_PlayerIndexLoggedIn
        )
    end
end

local function updateWithModelUnitMap(self)
    local modelWar     = self.m_ModelWar
    local modelUnitMap = self.m_ModelUnitMap
    local modelUnit    = modelUnitMap:getModelUnit(self.m_CursorGridIndex)
    if ((not modelUnit)                                                       or
        (self.m_ModelWarCommandMenu:isEnabled())                              or
        (self.m_ModelWarCommandMenu:isHiddenWithHideUI())                     or
        ((self.m_ModelChatManager) and (self.m_ModelChatManager:isEnabled())) or
        (not isModelUnitVisible(self, modelUnit)))                            then
        self.m_View:setVisible(false)
    else
        local shouldShowLoadedUnits = (self.m_IsWarReplay) or (not self.m_ModelFogMap:isFogOfWarCurrently()) or (self.m_ModelPlayerManager:isSameTeamIndex(modelUnit:getPlayerIndex(), self.m_PlayerIndexLoggedIn))
        local loadedModelUnits      = (shouldShowLoadedUnits) and (modelUnitMap:getLoadedModelUnitsWithLoader(modelUnit)) or (nil)
        self.m_ModelUnitList        = {modelUnit, unpack(loadedModelUnits or {})}

        self.m_View:updateWithModelUnit(modelUnit, loadedModelUnits)
            :setVisible(true)
    end
end

--------------------------------------------------------------------------------
-- The callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtChatManagerUpdated(self, event)
    updateWithModelUnitMap(self)
end

local function onEvtModelUnitMapUpdated(self, event)
    updateWithModelUnitMap(self)
end

local function onEvtGridSelected(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtMapCursorMoved(self, event)
    self.m_CursorGridIndex = GridIndexFunctions.clone(event.gridIndex)
    updateWithModelUnitMap(self)
end

local function onEvtWarCommandMenuUpdated(self, event)
    updateWithModelUnitMap(self)
end

local function onEvtPlayerIndexUpdated(self, event)
    self.m_View:updateWithPlayerIndex(event.playerIndex)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelUnitInfo:ctor(param)
    self.m_CursorGridIndex = {x = 1, y = 1}

    return self
end

function ModelUnitInfo:setModelUnitDetail(model)
    assert(self.m_ModelUnitDetail == nil, "ModelUnitInfo:setModelUnitDetail() the model has been set.")
    self.m_ModelUnitDetail = model

    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelUnitInfo:onStartRunning(modelWar)
    self.m_ModelWar            = modelWar
    self.m_IsWarReplay         = SingletonGetters.isTotalReplay(         modelWar)
    self.m_ModelFogMap         = SingletonGetters.getModelFogMap(        modelWar)
    self.m_ModelPlayerManager  = SingletonGetters.getModelPlayerManager( modelWar)
    self.m_ModelUnitMap        = SingletonGetters.getModelUnitMap(       modelWar)
    self.m_ModelWarCommandMenu = SingletonGetters.getModelWarCommandMenu(modelWar)
    if (not self.m_IsWarReplay) then
        self.m_PlayerIndexLoggedIn = SingletonGetters.getPlayerIndexLoggedIn(modelWar)
        self.m_ModelChatManager    = SingletonGetters.getModelChatManager(modelWar)
    end

    SingletonGetters.getScriptEventDispatcher(modelWar)
        :addEventListener("EvtChatManagerUpdated",    self)
        :addEventListener("EvtGridSelected",          self)
        :addEventListener("EvtMapCursorMoved",        self)
        :addEventListener("EvtModelUnitMapUpdated",   self)
        :addEventListener("EvtPlayerIndexUpdated",    self)
        :addEventListener("EvtWarCommandMenuUpdated", self)

    self.m_View:updateWithPlayerIndex(SingletonGetters.getModelTurnManager(modelWar):getPlayerIndex())
    updateWithModelUnitMap(self)

    return self
end

function ModelUnitInfo:onEvent(event)
    local eventName = event.name
    if     (eventName == "EvtChatManagerUpdated")    then onEvtChatManagerUpdated(   self, event)
    elseif (eventName == "EvtGridSelected")          then onEvtGridSelected(         self, event)
    elseif (eventName == "EvtMapCursorMoved")        then onEvtMapCursorMoved(       self, event)
    elseif (eventName == "EvtModelUnitMapUpdated")   then onEvtModelUnitMapUpdated(  self, event)
    elseif (eventName == "EvtPlayerIndexUpdated")    then onEvtPlayerIndexUpdated(   self, event)
    elseif (eventName == "EvtWarCommandMenuUpdated") then onEvtWarCommandMenuUpdated(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelUnitInfo:onPlayerTouch(index)
    if (self.m_ModelUnitDetail) then
        self.m_ModelUnitDetail:updateWithModelUnit(self.m_ModelUnitList[index])
            :setEnabled(true)
    end

    return self
end

return ModelUnitInfo
