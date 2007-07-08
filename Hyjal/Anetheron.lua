﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Anetheron"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Anetheron",

	engage_trigger = "You are defenders of a doomed world! Flee here, and perhaps you will prolong your pathetic lives!",

	inferno = "Inferno",
	inferno_desc = "Approximate Inferno cooldown timers.",
	inferno_trigger = "begins to perform Inferno.$",
	inferno_message = "Casting Inferno!",
	inferno_warning = "Inferno Soon!",
	inferno_bar = "~Inferno Cooldown",

	swarm = "Carrion Swarm",
	swarm_desc = "Approximate Carrion Swarm cooldown timers.",
	swarm_trigger1 = "Pestilence upon you!",
	swarm_trigger2 = "The swarm is eager to feed.",
	swarm_message = "Swarm! - Next in ~11sec",
	swarm_bar = "~Swarm Cooldown",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Vous défendez un monde condamné ! Fuyez, si vous voulez avoir une chance de faire durer vos vies pathétiques !", -- à vérifier

	inferno = "Inferno",
	inferno_desc = "Temps de recharge approximatif pour l'Inferno.",
	inferno_trigger = "commence à exécuter Inferno.$",
	inferno_message = "Incante un inferno !",
	inferno_warning = "Inferno imminent !",
	inferno_bar = "~Cooldown Inferno",

	swarm = "Vol de charognards",
	swarm_desc = "Temps de recharge approximatif pour le Vol de charognards.",
	swarm_trigger1 = "La Peste soit sur vous !", -- à vérifier
	swarm_trigger2 = "L'essaim est affamé.", -- à vérifier
	swarm_message = "Essaim ! - Prochain dans ~11 sec.",
	swarm_bar = "~Cooldown Essaim",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "멸망에 처한 세계의 수호자들이여, 구차한 목숨이라도 건지려면 어서 달아나라!",

	inferno = "불지옥",
	inferno_desc = "대략적인 불지옥 대기시간 타이머입니다.",
	inferno_trigger = "불지옥 사용을 시작합니다.$",
	inferno_message = "불지옥 시전 중!",
	inferno_warning = "잠시 후 불지옥!",
	inferno_bar = "~불지옥 대기시간",

	swarm = "흡혈박쥐 떼",
	swarm_desc = "대략적인 흡혈박쥐 떼 대기시간 타이머입니다.",
	swarm_trigger1 = "역병에 뒤덮이리라!",
	swarm_trigger2 = "박쥐들이 많이 굶주렸구나.",
	swarm_message = "박쥐 떼! - 다음은 약 11초 이내",
	swarm_bar = "~박쥐 떼 대기시간",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ihr verteidigt eine verlorene Welt! Flieht! Vielleicht verl\195\164ngert dies Euer erb\195\164rmliches Leben!",

	inferno = "Inferno",
	inferno_desc = "gesch\195\164tzte Inferno Cooldown Timer.",
	inferno_trigger = "beginnt Inferno zu wirken.$",
	inferno_message = "zaubert Inferno!",
	inferno_warning = "Inferno bald!",
	inferno_bar = "~Inferno Cooldown",

	swarm = "Aasschwarm",
	swarm_desc = "gesch\195\164tzte Aasschwarm Cooldown Timer.",
	swarm_trigger1 = "M\195\182ge die Pest \195\188ber Euch kommen!",
	swarm_trigger2 = "Der Schwarm ist hungrig!",
	swarm_message = "Aasschwarm! - N\195\164chster in ~11sec",
	swarm_bar = "~Aasschwarm Cooldown",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"inferno", "swarm", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AnethInf", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync)
	if sync == "AnethInf" and self.db.profile.inferno then
		self:Message(L["inferno_message"], "Important", nil, "Alert")
		self:DelayedMessage(45, L["inferno_warning"], "Positive")
		self:Bar(L["inferno_bar"], 50, "Spell_Fire_Incinerate")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.swarm and (msg == L["swarm_trigger1"] or msg == L["swarm_trigger2"]) then
		self:Message(L["swarm_message"], "Attention")
		self:Bar(L["swarm_bar"], 11, "Spell_Shadow_CarrionSwarm")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["inferno_trigger"]) then
		self:Sync("AnethInf")
	end
end