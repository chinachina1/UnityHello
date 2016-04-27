--------------------------------------------------------------------------------
--      Copyright (c) 2015 - 2016 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--      Use, modification and distribution are subject to the "MIT License"
--------------------------------------------------------------------------------
local rawget = rawget
local uTime = UnityEngine.Time

local _Time = 
{	
	deltaTime			= 0,
	fixedDeltaTime 	 	= 0,
	maximumDeltaTime	= 0.3333333,
	fixedTime			= 0,
	frameCount			= 1,	
	realtimeSinceStartup=0,
	time 				= 0,
	timeScale			= 1,
	timeSinceLevelLoad	= 0,
	unscaledDeltaTime	= 0,	
	unscaledTime		= 0,	
}

local _set = {}

function _set.fixedDeltaTime(v)
	_Time.fixedDeltaTime = v
	uTime.fixedDeltaTime = v
end

function _set.maximumDeltaTime(v)
	_Time.maximumDeltaTime = v
	uTime.maximumDeltaTime = v
end

function _set.timeScale(v)
	_Time.timeScale = v
	uTime.timeScale = v
end

function _set.captureFramerate(v)
	_Time.captureFramerate = v
	uTime.captureFramerate = v
end

_Time.__index = function(t, k)
	local var = rawget(_Time, k)
	
	if var then
		return var
	end

	return uTime.__index(uTime, k)	
end

_Time.__newindex = function(t, k, v)
	func = rawget(_set, k)

	if func then
		return func(v)
	end

	error(string.format("Property or indexer `UnityEngine.Time.%s' cannot be assigned to (it is read only)", k))	
end

local Time = {}

function Time:SetDeltaTime(deltaTime, unscaledDeltaTime)	
	_Time.deltaTime = deltaTime	
	_Time.unscaledDeltaTime = unscaledDeltaTime

	_Time.time = _Time.time + deltaTime
	_Time.timeSinceLevelLoad = _Time.timeSinceLevelLoad + deltaTime	
	_Time.unscaledTime = _Time.unscaledTime + unscaledDeltaTime 	
end

function Time:SetFixedDelta(fixedDeltaTime)	
	_Time.deltaTime = fixedDeltaTime
	_Time.fixedDeltaTime = fixedDeltaTime

	_Time.fixedTime = _Time.fixedTime + fixedDeltaTime
end

function Time:SetFrameCount()
	_Time.frameCount = _Time.frameCount + 1
end

function Time:SetTimeScale(scale)
	local last = _Time.timeScale
	_Time.timeScale = scale
	uTime.timeScale = scale
	return last
end

UnityEngine.Time = Time
setmetatable(Time, _Time)
return Time