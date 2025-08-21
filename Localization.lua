-- Localization.lua
-- Provides localized buff names and a simple accessor.

ProcDocLocalization = ProcDocLocalization or {}

local LOCALE = GetLocale and GetLocale() or "enUS"

-- Buff name translations (keys are stable English identifiers)
-- Only buff names used by ProcDoc are listed here.
ProcDocLocalization.strings = {
	-- Warlock
	["Shadow Trance"]       = { enUS = "Shadow Trance",       zhCN = "暗影冥思" }, -- Nightfall proc buff name varies; fallback to enUS if mismatched

	-- Mage
	["Clearcasting"]        = { enUS = "Clearcasting",        zhCN = "节能施法" },
	["Netherwind Focus"]    = { enUS = "Netherwind Focus",    zhCN = "灵风专注" },
	["Temporal Convergence"] = { enUS = "Temporal Convergence", zhCN = "时空汇聚" },
	["Flash Freeze"]        = { enUS = "Flash Freeze",        zhCN = "急速冷却" },
	["Arcane Rupture"]      = { enUS = "Arcane Rupture",      zhCN = "奥术溃烈" },
	["Hot Streak"]          = { enUS = "Hot Streak",          zhCN = "炽热连击" },

	-- Druid
	["Nature's Grace"]      = { enUS = "Nature's Grace",      zhCN = "自然之赐" },
	["Tiger's Fury"]        = { enUS = "Tiger's Fury",        zhCN = "猛虎之怒" },
	["Astral Boon"]         = { enUS = "Astral Boon",         zhCN = "星界恩泽" },
	["Natural Boon"]        = { enUS = "Natural Boon",        zhCN = "自然恩泽" },
	["Arcane Eclipse"]      = { enUS = "Arcane Eclipse",      zhCN = "奥术月蚀" },
	["Nature Eclipse"]      = { enUS = "Nature Eclipse",      zhCN = "自然月蚀" },

	-- Shaman
	["Nature's Swiftness"]  = { enUS = "Nature's Swiftness",  zhCN = "自然迅捷" },
	["Stormstrike"]         = { enUS = "Stormstrike",         zhCN = "风暴打击" },
	["Flurry"]              = { enUS = "Flurry",              zhCN = "乱舞" },

	-- Hunter
	["Quick Shots"]         = { enUS = "Quick Shots",         zhCN = "快速射击" },
	["Lacerate"]            = { enUS = "Lacerate",            zhCN = "割裂" },
	["Baited Shot"]         = { enUS = "Baited Shot",         zhCN = "诱饵射击" },

	-- Warrior
	["Enrage"]              = { enUS = "Enrage",              zhCN = "狂怒" },
	["Overpower"]           = { enUS = "Overpower",           zhCN = "压制" },
	["Execute"]             = { enUS = "Execute",             zhCN = "斩杀" },
	["Counterattack"]       = { enUS = "Counterattack",       zhCN = "反击" },
	["Revenge"]             = { enUS = "Revenge",             zhCN = "复仇" },

	-- Priest
	["Resurgence"]          = { enUS = "Resurgence",          zhCN = "复苏" },
	["Enlightened"]         = { enUS = "Enlightened",         zhCN = "启迪" },
	["Searing Light"]       = { enUS = "Searing Light",       zhCN = "灼热之光" },
	["Shadow Veil"]         = { enUS = "Shadow Veil",         zhCN = "暗影帷幕" },
	["Spell Blasting"]      = { enUS = "Spell Blasting",      zhCN = "法术冲击" },

	-- Paladin
	["Daybreak"]            = { enUS = "Daybreak",            zhCN = "破晓" },
	["Hammer of Wrath"]     = { enUS = "Hammer of Wrath",     zhCN = "愤怒之锤" },

	-- Rogue
	["Remorseless"]         = { enUS = "Remorseless",         zhCN = "冷酷" },
	["Tricks of the Trade"] = { enUS = "Tricks of the Trade", zhCN = "嫁祸诀窍" },
	["Riposte"]             = { enUS = "Riposte",             zhCN = "还击" },
	["Surprise Attack"]     = { enUS = "Surprise Attack",     zhCN = "突袭" },

	-- Mage action
	["Arcane Surge"]        = { enUS = "Arcane Surge",        zhCN = "奥术涌动" },

	-- Settings UI / Messages
	["Options"]                         = { enUS = "Options",                         zhCN = "选项" },
	["SavedVariables loaded."]          = { enUS = "SavedVariables loaded.",          zhCN = "已加载保存变量。" },
	["minAlpha"]                        = { enUS = "minAlpha",                        zhCN = "最小透明度" },
	["maxAlpha"]                        = { enUS = "maxAlpha",                        zhCN = "最大透明度" },
	["pulseSpeed"]                      = { enUS = "pulseSpeed",                      zhCN = "跳动速度" },
	["minScale"]                        = { enUS = "minScale",                        zhCN = "最小缩放" },
	["maxScale"]                        = { enUS = "maxScale",                        zhCN = "最大缩放" },
	["topOffset"]                       = { enUS = "topOffset",                       zhCN = "顶部偏移" },
	["sideOffset"]                      = { enUS = "sideOffset",                      zhCN = "侧边偏移" },
	["ProcDoc DB Dump"]                 = { enUS = "ProcDoc DB Dump",                 zhCN = "ProcDoc 数据库信息" },
	["DB not initialized yet."]         = { enUS = "DB not initialized yet.",         zhCN = "数据库尚未初始化。" },
	["isMuted"]                         = { enUS = "isMuted",                         zhCN = "静音" },
	["disableTimers"]                   = { enUS = "disableTimers",                   zhCN = "禁用计时" },
	["Min Transparency:"]               = { enUS = "Min Transparency:",               zhCN = "最小透明度：" },
	["Max Transparency:"]               = { enUS = "Max Transparency:",               zhCN = "最大透明度：" },
	["Min Size:"]                       = { enUS = "Min Size:",                       zhCN = "最小尺寸：" },
	["Max Size:"]                       = { enUS = "Max Size:",                       zhCN = "最大尺寸：" },
	["Pulse Speed:"]                    = { enUS = "Pulse Speed:",                    zhCN = "脉冲速度：" },
	["Top Offset:"]                     = { enUS = "Top Offset:",                     zhCN = "顶部偏移：" },
	["Side Offset:"]                    = { enUS = "Side Offset:",                    zhCN = "侧边偏移：" },
	["Mute All Proc Sounds"]            = { enUS = "Mute All Proc Sounds",            zhCN = "静音全部触发音效" },
	["Disable Timers"]                  = { enUS = "Disable Timers",                  zhCN = "禁用计时器" },
	["Proc Animations to Show for %s"]  = { enUS = "Proc Animations to Show for %s",  zhCN = "为 %s 显示的触发动画" },
	["Test Proc"]                       = { enUS = "Test Proc",                       zhCN = "测试触发" },
	["Hide All"]                        = { enUS = "Hide All",                        zhCN = "全部隐藏" },
	["Close"]                           = { enUS = "Close",                           zhCN = "关闭" },
	["Sounds are now muted."]           = { enUS = "Sounds are now muted.",           zhCN = "已静音音效。" },
	["Sounds are now unmuted."]         = { enUS = "Sounds are now unmuted.",         zhCN = "已取消静音。" },
	["Timers disabled."]                = { enUS = "Timers disabled.",                zhCN = "计时器已禁用。" },
	["Timers enabled."]                 = { enUS = "Timers enabled.",                 zhCN = "计时器已启用。" },
	["All test buff alerts hidden."]    = { enUS = "All test buff alerts hidden.",    zhCN = "已隐藏所有测试警示。" },
	["Options opened"]                  = { enUS = "Options opened",                  zhCN = "已打开选项" },
	["Loaded. Tracking procs for %s. Type %s for options."] = {
		enUS = "Loaded. Tracking procs for %s. Type %s for options.",
		zhCN = "已加载。正在追踪 %s 的触发。输入 %s 打开选项。"
	},
	["Test proc refreshed with updated offsets."] = {
		enUS = "Test proc refreshed with updated offsets.",
		zhCN = "已用新偏移刷新测试触发。"
	},
}

-- Accessor: returns a localized string, fallback to enUS or the key itself.
ProcDocLocalization.L = function (key)
	local entry = ProcDocLocalization.strings and ProcDocLocalization.strings[key]
	if not entry then return key end
	return entry[LOCALE] or entry.enUS or key
end