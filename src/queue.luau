--[[
	Scripter: FacelessDev (@julimaxx)
	Description: Generic Queue
	Last Review: 02/04/2026
	
	What this could be used for:
	Handling petitions in FIFO order <-- Main use
	Spawning in order (for idk a td game)
	Buffers where the order is important (with buffer I mean a variable to store temporal data)
	
]]--
--!strict

-- Interface
export type GenericQueue<T> = {
	Queue: {[number]: T},
	Push: (self: GenericQueue<T>, value: T) -> (),
	Pop: (self: GenericQueue<T>) -> T,
	Flush: (self: GenericQueue<T>) -> (),
	Size: (self: GenericQueue<T>) -> number,
	Empty: (self: GenericQueue<T>) -> boolean,
	PushRange: (self: GenericQueue<T>) -> (),
	Swap: (self: GenericQueue<T>, swapQueue: GenericQueue<T>) -> ()
}

local GenericQueueClass = {}
GenericQueueClass.__index = GenericQueueClass

function GenericQueueClass.new<T>(value: T): GenericQueue<T>
	local self = setmetatable({Queue = {}} :: GenericQueue<T>,GenericQueueClass)
	return self
end

function GenericQueueClass:Push<T>(value: T): ()
	self.Queue[#self.Queue+1] = value
end

function GenericQueueClass:Pop<T>(): T
	local value = self.Queue[1]
	table.remove(self.Queue)
	return value
end

function GenericQueueClass:Flush(): ()
	table.clear(self.Queue)
end

function GenericQueueClass:Size(): number
	return #self.Queue :: {}
end

function GenericQueueClass:Empty(): boolean
	return (#self.Queue :: {} == 0)
end

function GenericQueueClass:PushRange<T>(...: T): ()
	local self: GenericQueue<T> = self
	local params = {...}
	for _,param in ipairs(params) do
		self.Queue[#self.Queue+1] = param
	end
end

function GenericQueueClass:Swap<T>(swapQueue: GenericQueue<T>): ()
	local target,other
	if self:Size() > swapQueue:Size() then
		target = self.Queue
		other = swapQueue.Queue
	else
		target = swapQueue.Queue
		other = self.Queue
	end
	
	for i,v in ipairs(target) do
		local aux = v
		target[i] = other[i]
		other[i] = aux
	end
end

function GenericQueueClass:__len(): number
	return #self.Queue :: {}
end

function GenericQueueClass:__eq<T>(compQueue: any): boolean
	if self:Size() == compQueue:Size() and typeof(self) == typeof(compQueue) then
		for i,v in ipairs(self.Queue) do
			if self.Queue[i] ~= compQueue[i] then return false end
		end
		return true
	else
		return false
	end
end

return GenericQueueClass
