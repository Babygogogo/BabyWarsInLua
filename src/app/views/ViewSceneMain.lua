local ViewSceneMain = class("ViewSceneMain", cc.Scene)

local GameConstantFunctions = require("app.utilities.GameConstantFunctions")
local ViewWarCommandMenu = require("app.views.ViewWarCommandMenu")

local CONFIRM_BOX_Z_ORDER       = 99
local VERSION_INDICATOR_Z_ORDER = 2
local WAR_LIST_Z_ORDER          = 1
local BACKGROUND_Z_ORDER        = 0

--菜单项函数
local function buttonSinglePlay_onClicked()
	print('在这里写上单机游戏要做的事情')
end
local function buttonNetworkPlay_onClicked()
	print('在这里写上联网游戏要做的事情')
end
local function buttonAbout_onClicked()
	print('关于本游戏')
end

--------------------------------------------------------------------------------
--主界面构造函数
--------------------------------------------------------------------------------
function ViewSceneMain:ctor(param)
	--这是背景
	local background = cc.Sprite:createWithSpriteFrameName("c03_t05_s01_f01.png")
	background:move(display.center)
	self.m_Background = background
	self:addChild(background, BACKGROUND_Z_ORDER)
	--这是版本指示器
	local indicator = cc.Label:createWithTTF("", "res/fonts/msyhbd.ttc", 25)
	indicator:ignoreAnchorPointForPosition(true)
		:setPosition(display.width - 220, 10)
		:setDimensions(220, 40)
		:setTextColor({r = 255, g = 255, b = 255})
		:enableOutline({r = 0,  g = 0,   b = 0}, 2)
	self:addChild(indicator, VERSION_INDICATOR_Z_ORDER)
	--设置版本号
	indicator:setString("Version: " .. GameConstantFunctions.getGameVersion())
	--主菜单节点
	local mainMenu=cc.Node:create()
	--主菜单背景图
	local bg = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
	bg:ignoreAnchorPointForPosition(true)
	bg:setContentSize(250, display.height - 60)
	mainMenu:addChild(bg)
	--主菜单控件
	local listView = ccui.ListView:create()
	listView:setPosition(5, 6)
		:setContentSize(240, display.height - 46) -- 10/14 are the height/width of the edging of background
		:setItemsMargin(5)
		:setGravity(ccui.ListViewGravity.centerHorizontal)
		:setCascadeOpacityEnabled(true)
	mainMenu:addChild(listView)
	--主菜单节点
	mainMenu:setContentSize(250, display.height - 60)
		:setPosition(30, 30)
		:setCascadeOpacityEnabled(true)
		:setOpacity(180)
	self:addChild(mainMenu,1)
	--设置菜单项
	local mainMenuItem={
		{name='Single play',func=buttonSinglePlay_onClicked},
		{name='Network play',func=buttonSinglePlay_onClicked},
		{name='About',func=buttonAbout_onClicked}
	}
	for key,value in ipairs(mainMenuItem) do
		local button = ccui.Button:create()
		button:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)
			:setScale9Enabled(true)
			:setAnchorPoint(cc.p(0,0))
			:setPosition(10,mainMenu:getContentSize().height-45*key)
			:setContentSize(230,45)
			:setZoomScale(-0.05)
			:setTitleFontName("res/fonts/msyhbd.ttc")
			:setTitleFontSize(28)
			:setTitleColor({r=255,g=255,b=255})
			:setTitleText(value.name)
		button:getTitleRenderer():enableOutline({r=0,g=0,b=0},2)

		button:addTouchEventListener(function(sender, eventType)
			if (eventType == ccui.TouchEventType.ended) then
				--执行预设函数
				if(value.func)then
					value.func()
				end
			end
		end)
		mainMenu:addChild(button)
	end
	--构造完成
    return self
end

--其它公共函数
function ViewSceneMain:setViewConfirmBox(view)
    assert(self.m_ViewConfirmBox == nil, "ViewSceneMain:setViewConfirmBox() the view has been set already.")

    self.m_ViewConfirmBox = view
    self:addChild(view, CONFIRM_BOX_Z_ORDER)

    return self
end

function ViewSceneMain:setViewWarList(view)
    assert(self.m_ViewWarList == nil, "ViewSceneMain:setViewWarList() the view has been set already.")

    self.m_ViewWarList = view
    self:addChild(view, WAR_LIST_Z_ORDER)

    return self
end

return ViewSceneMain