-- PinkFactory Corp.
-- by YuriHan.

local LinkedList = {}

function LinkedList:new()
	local linkedList = {head = nil,tail = nil}
	for i,v in pairs(self) do
		 linkedList[i] = v
	end
	linkedList.__index = self
	return linkedList
end

function LinkedList:addTail(obj)
	local item = {
		next = nil,
		prev = nil,
		object = obj}
	if not self.head then
		self.head = item        
	end
	if self.tail then
		self.tail.next = item
		item.prev = self.tail
	end
	self.tail = item
end

function LinkedList:addHead(obj)
	local item = {
		next = nil,
		prev = nil,
		object = obj}
	if self.head then
		item.next = self.head
		self.head.prev = item
	end
	self.head = item
	if not self.tail then
		self.tail = item
	end
end

function LinkedList:getHead()
	return self.head
end

function LinkedList:getTail()
	return self.tail
end

function LinkedList:isEmpty()
	if self.head == nil then
		return true
	else 
		return false
	end
end

-- 좋은 방법이 없을까...
function LinkedList:removeItem(item)
	local i = self:getHead()
	while i do
		if i == item then
			if item.prev then
				item.prev.next = item.next
			end
			if item.next then
				item.next.prev = item.prev
			end
			break
		end
		i = i.next
	end
	if self.head == item then
		self.head = item.next
	end
	if self.tail == item then
		self.tail = item.prev
	end
end

return LinkedList