
local ModelReplayController = class("ModelReplayController")

local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")

local getLocalizedText = LocalizationFunctions.getLocalizedText

--------------------------------------------------------------------------------
-- The private callback functions on script events.
--------------------------------------------------------------------------------
local function onEvtWarCommandMenuUpdated(self, event)
    local menu = self.m_ModelWarCommandMenu
    self.m_View:setVisible((not menu:isEnabled()) and (not menu:isHiddenWithHideUI()))
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function ModelReplayController:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback functions on start running/script events.
--------------------------------------------------------------------------------
function ModelReplayController:onStartRunning(modelSceneWar)
    self.m_ModelSceneWar       = modelSceneWar
    self.m_ModelWarCommandMenu = SingletonGetters.getModelWarCommandMenu(modelSceneWar)
    SingletonGetters.getScriptEventDispatcher(modelSceneWar)
        :addEventListener("EvtWarCommandMenuUpdated", self)

    return self
end

function ModelReplayController:onEvent(event)
    local eventName = event.name
    if (eventName == "EvtWarCommandMenuUpdated") then
        onEvtWarCommandMenuUpdated(self, event)
    end

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelReplayController:onButtonNextTurnTouched()
    local modelSceneWar = self.m_ModelSceneWar
    if (not modelSceneWar:canFastForwardForReplay()) then
        SingletonGetters.getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(11, "NoMoreNextTurn"))
    else
        modelSceneWar:setAutoReplay(false)
            :fastForwardForReplay()
        self:setButtonPlayVisible(true)
    end

    return self
end

function ModelReplayController:onButtonPreviousTurnTouched()
    local modelSceneWar = self.m_ModelSceneWar
    if (not modelSceneWar:canFastRewindForReplay()) then
        SingletonGetters.getModelMessageIndicator(modelSceneWar):showMessage(getLocalizedText(11, "NoMorePreviousTurn"))
    else
        modelSceneWar:setAutoReplay(false)
            :fastRewindForReplay()
        self:setButtonPlayVisible(true)
    end

    return self
end

function ModelReplayController:onButtonPlayTouched()
    self.m_ModelSceneWar:setAutoReplay(true)
    self:setButtonPlayVisible(false)

    return self
end

function ModelReplayController:onButtonPauseTouched()
    self.m_ModelSceneWar:setAutoReplay(false)
    self:setButtonPlayVisible(true)

    return self
end

function ModelReplayController:setButtonPlayVisible(visible)
    if (self.m_View) then
        self.m_View:setButtonPlayVisible(visible)
            :setButtonPauseVisible(not visible)
    end

    return self
end

return ModelReplayController
