
--[[--------------------------------------------------------------------------------
-- ModelSceneMain是主场景。刚打开游戏，以及退出战局后所看到的就是这个场景。
--
-- 主要职责和使用场景举例：
--   同上
--
-- 其他：
--  - 目前本类功能很少。预定需要增加的功能包括（在本类中直接实现，或通过添加新的类来实现）：
--    - 创建新战局
--    - 加入已有战局
--    - 配置技能
--    - 显示玩家形象、id、积分、排名、战绩
--]]--------------------------------------------------------------------------------

local ModelSceneMain = class("ModelSceneMain")

local Actor	                = require("global.actors.Actor")
local GameConstantFunctions = require("app.utilities.GameConstantFunctions")

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSceneMain:ctor(param)
	print('参数类型'..type(param))
	self.m_ActorConfirmBox = Actor.createWithModelAndViewName("ModelConfirmBox", nil, "ViewConfirmBox")
	self.m_ActorConfirmBox:getModel():setEnabled(false)

	--self.m_ActorWarList = Actor.createWithModelAndViewName("ModelWarList", mapListData, "ViewWarList", mapListData)
	--self.m_ActorWarList:getModel():setModelConfirmBox(self.m_ActorConfirmBox:getModel())

    if (self.m_View) then
        self:initView()
    end

    return self
end

function ModelSceneMain:initView()
    local view = self.m_View
    assert(view, "ModelSceneMain:initView() no view is attached to the owner actor of the model.")

	view:setViewConfirmBox(self.m_ActorConfirmBox:getView())
	--view:setViewWarList(   self.m_ActorWarList:getView())
		--:setGameVersion(GameConstantFunctions.getGameVersion())

    return self
end

return ModelSceneMain
