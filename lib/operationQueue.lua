-- PinkFactory Corp.
-- by YuriHan.

local OperationQueue = {}

function OperationQueue:new()
	local linkedlist = require'lib.linkedlist'
	local inst = {list = linkedlist:new(),maxConcurrentCount = 5,status = "stop"}
	for i,v in pairs(self) do
		inst[i] = v
	end
	inst.__index = self
	return inst
end

function OperationQueue:addOperation(...)
	for i=1,arg.n do		
		self.list:addTail(arg[i])
	end
end
function OperationQueue:start(cbFinished)
	if self.status == "running" then
		return
	end
	self.status = "running"
	self.timer = timer.performWithDelay(100, function()
		if self.status == "stop" then
			return
		end
		local oper = self.list:getHead()		
		-- 남은 작업 없으면
		if oper == nil then			
			self:stop()
			-- 콜백 있으면 실행.
			if cbFinished ~= nil then cbFinished() end
			return
		end
		local running = 0
		while oper do			
			local cond = (function()				
				-- 코루틴 끝남.
				if coroutine.status(oper.object._oper) == 'dead' then
					-- 비동기일 경우 끝났는지 따로 확인.
					if oper.object.isFinished ~= nil then
						if oper.object.isFinished(oper.object) == false then
							return 
						end
					end
					-- 콜백함수 있으면 호출.
					if oper.object.cbFinished ~= nil then
						oper.object.cbFinished(oper.object)
					end
					-- 큐에서 제거.
					self.list:removeItem(oper)
					return			
				end
				-- 코루틴 실행
				coroutine.resume(oper.object._oper,oper.object)
				running = running+1
				-- 실행중인 operation 갯수가 최대 갯수와 같으면 루프 종료.
				if running == self.maxConcurrentCount then
					return 'break'
				end
			end)()
			if cond == 'break' then
				oper = nil
			else
				oper = oper.next
			end
		end
	end, 0)
end

function OperationQueue:stop( ... )
	if self.status == "stop" then
		return
	end
	self.status = "stop"
	timer.cancel(self.timer)
end

-- function OperationQueue:createOperation(obj,run[,isFinished[,cbFinished]])
-- auto insert..
function OperationQueue:createOperation(obj,run,cbFinished,isFinished)
	obj = obj or {}
	obj._oper = coroutine.create(run)
	obj.cbFinished = cbFinished or nil 
	obj.isFinished = isFinished or nil
	self:addOperation(obj)
	return obj
end

return OperationQueue