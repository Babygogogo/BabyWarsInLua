
local ViewReplayManager = class("ViewReplayManager", cc.Node)

local AuxiliaryFunctions    = requireBW("src.app.utilities.AuxiliaryFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local MENU_TITLE_Z_ORDER          = 1
local BUTTON_BACK_Z_ORDER         = 1
local BUTTON_CONFIRM_Z_ORDER      = 1
local BUTTON_FIND_Z_ORDER         = 1
local EDIT_BOX_WAR_NAME_Z_ORDER   = 1
local MENU_LIST_VIEW_Z_ORDER      = 1
local WAR_FIELD_PREVIEWER_Z_ORDER = 1
local MENU_BACKGROUND_Z_ORDER     = 0

local BACKGROUND_NAME      = "c03_t01_s01_f01.png"
local BACKGROUND_CAPINSETS = {x = 4, y = 6, width = 1, height = 1}
local BACKGROUND_OPACITY   = 180

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height - 60
local MENU_BACKGROUND_POS_X  = 30
local MENU_BACKGROUND_POS_Y  = 30

local MENU_TITLE_WIDTH      = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT     = 60
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - MENU_TITLE_HEIGHT
local MENU_TITLE_FONT_COLOR = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE  = 35

local BUTTON_BACK_WIDTH      = MENU_BACKGROUND_WIDTH
local BUTTON_BACK_HEIGHT     = 50
local BUTTON_BACK_POS_X      = MENU_BACKGROUND_POS_X
local BUTTON_BACK_POS_Y      = MENU_BACKGROUND_POS_Y
local BUTTON_BACK_FONT_COLOR = {r = 240, g = 80, b = 56}

local BUTTON_FIND_WIDTH  = 110
local BUTTON_FIND_HEIGHT = BUTTON_BACK_HEIGHT
local BUTTON_FIND_POS_X  = BUTTON_BACK_POS_X
local BUTTON_FIND_POS_Y  = BUTTON_BACK_POS_Y + BUTTON_BACK_HEIGHT

local EDIT_BOX_WAR_NAME_WIDTH  = 110
local EDIT_BOX_WAR_NAME_HEIGHT = BUTTON_FIND_HEIGHT
local EDIT_BOX_WAR_NAME_POS_X  = BUTTON_FIND_POS_X + BUTTON_FIND_WIDTH - MENU_BACKGROUND_POS_X
local EDIT_BOX_WAR_NAME_POS_Y  = BUTTON_FIND_POS_Y - MENU_BACKGROUND_POS_Y
local EDIT_BOX_TEXTURE_NAME    = "c03_t06_s01_f01.png"
local EDIT_BOX_CAPINSETS       = {x = 1, y = EDIT_BOX_WAR_NAME_HEIGHT - 5, width = 1, height = 1}
local EDIT_BOX_FONT_SIZE       = 25

local BUTTON_CONFIRM_WIDTH  = display.width - MENU_BACKGROUND_WIDTH - 90
local BUTTON_CONFIRM_HEIGHT = 60
local BUTTON_CONFIRM_POS_X  = display.width - BUTTON_CONFIRM_WIDTH - 30
local BUTTON_CONFIRM_POS_Y  = MENU_BACKGROUND_POS_Y

local MENU_LIST_VIEW_WIDTH               = MENU_BACKGROUND_WIDTH
local MENU_LIST_VIEW_HEIGHT_WITHOUT_FIND = MENU_TITLE_POS_Y - BUTTON_BACK_POS_Y - BUTTON_BACK_HEIGHT
local MENU_LIST_VIEW_HEIGHT_WITH_FIND    = MENU_LIST_VIEW_HEIGHT_WITHOUT_FIND - BUTTON_FIND_HEIGHT
local MENU_LIST_VIEW_POS_X               = MENU_BACKGROUND_POS_X
local MENU_LIST_VIEW_POS_Y_WITHOUT_FIND  = BUTTON_BACK_POS_Y + BUTTON_BACK_HEIGHT
local MENU_LIST_VIEW_POS_Y_WITH_FIND     = MENU_LIST_VIEW_POS_Y_WITHOUT_FIND + BUTTON_FIND_HEIGHT
local MENU_LIST_VIEW_ITEMS_MARGIN        = 10

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 50
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 25
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

local WAR_NAME_INDICATOR_FONT_SIZE     = 15
local WAR_NAME_INDICATOR_FONT_COLOR    = {r = 240, g = 80, b = 56}
local WAR_NAME_INDICATOR_OUTLINE_WIDTH = 1

local BUTTON_COLOR_ENABLED  = {r = 255, g = 255, b = 255}
local BUTTON_COLOR_DISABLED = {r = 160, g = 160, b = 160}

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function setButtonEnabled(button, enabled)
    button:setEnabled(enabled)
    if (enabled) then
        button:setColor(BUTTON_COLOR_ENABLED)
    else
        button:setColor(BUTTON_COLOR_DISABLED)
    end
end

local function createWarNameIndicator(warID)
    local indicator = cc.Label:createWithTTF(AuxiliaryFunctions.getWarNameWithWarId(warID), ITEM_FONT_NAME, WAR_NAME_INDICATOR_FONT_SIZE)
    indicator:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_WIDTH, ITEM_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

        :setTextColor(WAR_NAME_INDICATOR_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, WAR_NAME_INDICATOR_OUTLINE_WIDTH)

    return indicator
end

local function createViewMenuItem(item)
    local label = cc.Label:createWithTTF(item.name, ITEM_FONT_NAME, ITEM_FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)

        :setDimensions(ITEM_WIDTH, ITEM_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)

        :setTextColor(ITEM_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                item.callback()
            end
        end)

    view:setCascadeColorEnabled(true)
        :getRendererNormal():addChild(label)

    if (item.warID) then
        view:getRendererNormal():addChild(createWarNameIndicator(item.warID))
    end

    return view
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function initMenuBackground(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(BACKGROUND_NAME, BACKGROUND_CAPINSETS)
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)
        :setOpacity(BACKGROUND_OPACITY)

    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

local function initMenuListView(self)
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y_WITHOUT_FIND)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT_WITHOUT_FIND)
        :setItemsMargin(MENU_LIST_VIEW_ITEMS_MARGIN)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

local function initMenuTitle(self)
    local title = cc.Label:createWithTTF("", ITEM_FONT_NAME, MENU_TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_TITLE_POS_X, MENU_TITLE_POS_Y)

        :setDimensions(MENU_TITLE_WIDTH, MENU_TITLE_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(MENU_TITLE_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_MenuTitle = title
    self:addChild(title, MENU_TITLE_Z_ORDER)
end

local function initEditBoxWarName(self)
    local background = cc.Scale9Sprite:createWithSpriteFrameName(EDIT_BOX_TEXTURE_NAME, EDIT_BOX_CAPINSETS)
    local editBox    = ccui.EditBox:create(cc.size(EDIT_BOX_WAR_NAME_WIDTH, EDIT_BOX_WAR_NAME_HEIGHT), background, background, background)
    editBox:ignoreAnchorPointForPosition(true)
        :setFontSize(EDIT_BOX_FONT_SIZE)
        :setFontColor({r = 0, g = 0, b = 0})

        :setPlaceholderFontSize(EDIT_BOX_FONT_SIZE)
        :setPlaceholderFontColor({r = 0, g = 0, b = 0})
        :setPlaceHolder(LocalizationFunctions.getLocalizedText(58))

        :setMaxLength(6)
        :setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        :setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)

    -- The EditBox automatically opens up the soft keyboard when it is set visible (WTF?). To elinimate that, use an empty node to contain it.
    local container = cc.Node:create()
    container:ignoreAnchorPointForPosition(true)
        :setPosition(EDIT_BOX_WAR_NAME_POS_X, EDIT_BOX_WAR_NAME_POS_Y)
        :addChild(editBox)

    self.m_ContainerForEditBoxWarName = container
    self.m_EditBoxWarName             = editBox
    self.m_MenuBackground:addChild(container, EDIT_BOX_WAR_NAME_Z_ORDER)
end

local function initButtonBack(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_BACK_WIDTH, BUTTON_BACK_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(BUTTON_BACK_FONT_COLOR)
        :setTitleText(getLocalizedText(1, "Back"))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonBackTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonExit = button
    self:addChild(button, BUTTON_BACK_Z_ORDER)
end

local function initButtonConfirm(self)
    local button = ccui.Button:create()
    button:loadTextureNormal("c03_t01_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(BACKGROUND_CAPINSETS)
        :setContentSize(BUTTON_CONFIRM_WIDTH, BUTTON_CONFIRM_HEIGHT)

        :setZoomScale(-0.05)
        :setOpacity(180)

        :ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_CONFIRM_POS_X, BUTTON_CONFIRM_POS_Y)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(ITEM_FONT_COLOR)

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonConfirmTouched()
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonConfirm = button
    self:addChild(button, BUTTON_CONFIRM_Z_ORDER)
end

local function initButtonFind(self)
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_FIND_POS_X, BUTTON_FIND_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(BUTTON_FIND_WIDTH, BUTTON_FIND_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(MENU_TITLE_FONT_COLOR)
        :setTitleText(getLocalizedText(57))

        :addTouchEventListener(function(sender, eventType)
            if ((eventType == ccui.TouchEventType.ended) and (self.m_Model)) then
                self.m_Model:onButtonFindTouched(self.m_EditBoxWarName:getText())
            end
        end)

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    self.m_ButtonFind = button
    self:addChild(button, BUTTON_FIND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewReplayManager:ctor()
    initMenuBackground(self)
    initMenuListView(  self)
    initMenuTitle(     self)
    initEditBoxWarName(self)
    initButtonBack(    self)
    initButtonConfirm( self)
    initButtonFind(    self)

    return self
end

function ViewReplayManager:setViewWarFieldPreviewer(view)
    assert(self.m_ViewWarFieldPreviewer == nil, "ViewReplayManager:setViewWarFieldPreviewer() the view has been set already.")
    self.m_ViewWarFieldPreviewer = view
    self:addChild(view, WAR_FIELD_PREVIEWER_Z_ORDER)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewReplayManager:setMenuTitle(text)
    self.m_MenuTitle:setString(text)

    return self
end

function ViewReplayManager:setMenuItems(items)
    assert(#items > 0, "ViewReplayManager:setMenuItems() the items are empty.")
    local listView = self.m_MenuListView
    listView:removeAllChildren()

    for _, item in ipairs(items) do
        listView:pushBackCustomItem(createViewMenuItem(item))
    end

    return self
end

function ViewReplayManager:appendMenuItems(items)
    assert(#items > 0, "ViewReplayManager:appendMenuItems() the items are empty.")
    local listView = self.m_MenuListView
    for _, item in ipairs(items) do
        listView:pushBackCustomItem(createViewMenuItem(item))
    end

    return self
end

function ViewReplayManager:removeAllMenuItems()
    self.m_MenuListView:removeAllChildren()

    return self
end

function ViewReplayManager:setButtonFindVisible(visible)
    if (visible) then
        self.m_MenuListView:setPositionY(MENU_LIST_VIEW_POS_Y_WITH_FIND)
            :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT_WITH_FIND)
    else
        self.m_MenuListView:setPositionY(MENU_LIST_VIEW_POS_Y_WITHOUT_FIND)
            :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT_WITHOUT_FIND)
    end

    self.m_ButtonFind                :setVisible(visible)
    self.m_ContainerForEditBoxWarName:setVisible(visible)

    return self
end

function ViewReplayManager:setButtonConfirmText(text)
    self.m_ButtonConfirm:setTitleText(text)

    return self
end

function ViewReplayManager:setButtonConfirmVisible(visible)
    self.m_ButtonConfirm:setVisible(visible)

    return self
end

function ViewReplayManager:disableButtonConfirmForSecs(secs)
    self.m_ButtonConfirm:setEnabled(false)
        :stopAllActions()
        :runAction(cc.Sequence:create(
            cc.DelayTime:create(secs),
            cc.CallFunc:create(function()
                self.m_ButtonConfirm:setEnabled(true)
            end)
        ))

    return self
end

function ViewReplayManager:enableButtonConfirm()
    self.m_ButtonConfirm:stopAllActions()
        :setEnabled(true)

    return true
end

return ViewReplayManager
