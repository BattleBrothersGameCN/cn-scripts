local generalPage = ::Reforged.Mod.ModSettings.addPage("将军", "将军");
generalPage.addTitle("General_Title_Misc", "杂项");
generalPage.addEnumSetting("CraftingBlueprintVisibility", "One Ingredient Available", [
	"总是",
	"拥有一种原料",
	"拥有所有原料",
	"原版"
], "何时展示配方", "剥制师处的制造配方会在符合设定条件时显示出来。\n请注意，一些个别配方（如蛇油）仍会受其特殊规则限制而不会展示。\n\n“原版”意味着其显示行为会和原版游戏相同。");
generalPage.addBooleanSetting("ConfirmSkillUse", false, "确认技能使用", "若勾选，一些点击后立即使用的技能（如盾墙、集结部队）会需要选择角色自己作为目标。这使你可以预览技能的行动点数和疲劳消耗，比较各个技能的使用收益。按住\'确认使用技能\'快捷键（默认为ctrl）来跳过这一步骤，直接使出技能。\n\n若反选，这些技能会像原版一样立即被使用，按住快捷键则会使使用技能需要确认，方便预览技能效果。");
generalPage.addDivider("MiscDivider1");
generalPage.addTitle("General_Title_Contracts", "合同");
generalPage.addEnumSetting("SkipContractsToScreen", "Disabled", [
	"禁用",
	"谈判",
	"概览"
], "跳过合同直接", "使你可以在打开定居点的合同时跳过一些特定界面，节省一些时间。\n\n禁用：和原版行为一致，你需要点击推进合同流程的每个界面。\n\n谈判：跳过剧情导入界面直接进入谈判。\n\n概览：直接跳到最后选择接受或拒绝合同界面。选择此项时，你将无法手动进行合同谈判。");
generalPage.addRangeSetting("AutoNegotiateAttempts", 0, 0, 10, 1, "自动尝试谈判", "在点进定居点的合同时，自动进行此栏填入的数字次的报价谈判。该过程会在发布方拒绝要求（如不愿提高报价）或谈判失败后立即终止。");
local tooltipsPage = ::Reforged.Mod.ModSettings.addPage("信息栏", "信息栏");
tooltipsPage.addTitle("Tooltips_Title_CharacterScreen", "角色界面");
tooltipsPage.addBooleanSetting("CharacterScreen_ShowAttributeProjection", true, "显示属性预期", "若启用，角色的角色背景提示栏会显示预期的属性值，即你将每次属性升级都投入该项属性会得到的最终属性值。");
tooltipsPage.addBooleanSetting("CharacterScreen_ShowBaseAttributeRangesHiring", true, "显示基础属性范围(雇佣)", "若启用，当你在雇佣界面将鼠标悬停在背景图标上时，会显示每个背景的基础属性最大和最小值。");
tooltipsPage.addEnumSetting("CharacterScreen_ShowBaseAttributeRangesRegular", "Only New Recruits", [
	"总是",
	"仅新兵",
	"从不"
], "显示基础属性范围(常规)", "符合设定条件时，若查看其对应背景的提示栏，会显示该背景的基础属性最大和最小值。若设置为“仅新兵”，进行一次升级，该信息便不再显示。");
tooltipsPage.addDivider("Tooltips_Divider1");
tooltipsPage.addTitle("Tooltips_Title_TacticalTooltips", "战斗中的角色");
tooltipsPage.addEnumSetting("TacticalTooltip_Values", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示数值", "显示生命和护甲等的具体数值，替换模糊的情景化文字描述。");
tooltipsPage.addEnumSetting("TacticalTooltip_Attributes", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示属性", "在战术提示栏中显示实体的近战攻击、近战防御等属性。");
tooltipsPage.addEnumSetting("TacticalTooltip_Effects", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示效果", "在战术提示栏中显示实体的状态效果。");
tooltipsPage.addEnumSetting("TacticalTooltip_Perks", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示特技", "在战术提示栏中显示实体的特技。");
tooltipsPage.addEnumSetting("TacticalTooltip_EquippedItems", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示装备物品", "在战术提示栏中显示实体装备的物品。");
tooltipsPage.addEnumSetting("TacticalTooltip_BagItems", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示背包物品", "在战术提示栏中显示实体背包中的物品。");
tooltipsPage.addEnumSetting("TacticalTooltip_ActiveSkills", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示主动技能", "在战术提示栏中显示实体能使用的所有技能。");
tooltipsPage.addRangeSetting("TacticalTooltip_CollapseEffectsWhenX", 5, 0, 20, 1, "精简显示效果时机", "若效果的数量少于该值，这些内容会单占一行带图标显示。否则，为节省空间，这些内容会被显示为一个文本块。");
tooltipsPage.addRangeSetting("TacticalTooltip_CollapsePerksWhenX", 5, 0, 20, 1, "精简显示特技时机", "若特技的数量少于该值，这些内容会单占一行带图标显示。否则，为节省空间，这些内容会被显示为一个文本块。");
tooltipsPage.addRangeSetting("TacticalTooltip_CollapseActivesWhenX", 5, 0, 20, 1, "精简显示主动技能时机", "若主动技能的数量少于该值，这些内容会单占一行带图标显示。否则，为节省空间，这些内容会被显示为一个文本块。");
tooltipsPage.addBooleanSetting("TacticalTooltip_CollapseAsText", false, "精简显示为文本", "若勾选此选项，精简显示会显示技能名称，反之则会显示图标。");
tooltipsPage.addBooleanSetting("TacticalTooltip_ShowStatusPerkAndEffect", true, "显示状态特技和效果", "某些特技同时也是状态效果。通常情况下，除非条件满足，这些效果不会显示。若勾选此选项，在效果显示时（如效果生效时），对应特技还会显示在特技栏中。若反选此选项，在效果显示时，对应特技不再显示在特技栏中。勾选此选项有助于节省提示栏空间。");
tooltipsPage.addBooleanSetting("TacticalTooltip_HeaderForEmptyCategories", false, "显示空类别标题栏");
tooltipsPage.addDivider("Tooltips_Divider2");
tooltipsPage.addTitle("Tooltips_Title_MovementPreview", "移动预览");
tooltipsPage.addEnumSetting("TacticalTooltip_MovementPreviewHitchances", "All", [
	"所有人",
	"仅AI",
	"仅玩家",
	"无"
], "显示预测命中率", "进行移动预览时，显示移动到鼠标悬停地格后的命中和被命中概率。");
tooltipsPage.addRangeSetting("TacticalTooltip_CollapseHitchanceThreshold", 5, 0, 100, 1, "折叠命中率阈值", "进行移动预览时，预测命中率小于等于此概率的敌人会在提示栏中被折叠为一行显示。");
local debugPage = ::Reforged.Mod.ModSettings.addPage("除错及开发", "除错及开发");
debugPage.addBooleanSetting("Debug_onAnySkillExecutedFully", true, "onAnySkillExecutedFully", "启用onAnySkillExecutedFully模块的除错日志").addBeforeChangeCallback(function ( _newValue )
{
	return ::Reforged.Mod.Debug.setFlag(::Reforged.DebugFlag.onAnySkillExecutedFully, _newValue);
});
debugPage.addBooleanSetting("Debug_AIAgentFixes", false, "AIAgentFixes", "启用AIAgentFixes模块的除错日志").addBeforeChangeCallback(function ( _newValue )
{
	return ::Reforged.Mod.Debug.setFlag(::Reforged.DebugFlag.AIAgentFixes, _newValue);
});
debugPage.addTitle("Title_DevOptions", "开发选项");
debugPage.addBooleanSetting("Dev_SpawnsInfo", false, "队伍生成信息", "若勾选，启用世界地图上一系列关于队伍战力、生成天数的各类信息。");
::Reforged.Mod.Keybinds.addSQKeybind("Tactical_WaitRound", "h", ::MSU.Key.State.Tactical, function ()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen())
	{
		return false;
	}
	else
	{
		::Tactical.TurnSequenceBar.RF_onWaitTurnAllButtonPressed();
		return true;
	}
}, "令所有角色等待回合");
::Reforged.Mod.Keybinds.addSQKeybind("Tactical_PauseAI", "ctrl+space", ::MSU.Key.State.Tactical, function ()
{
	if (!::Tactical.isActive() || this.m.MenuStack.hasBacksteps() || this.isInCharacterScreen())
	{
		return false;
	}
	else
	{
		local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();

		if (::Tactical.State.isPaused() || activeEntity == null || !activeEntity.isPlayerControlled())
		{
			::Tactical.State.setPause(!::Tactical.State.isPaused());
		}

		return true;
	}
}, "暂停战术战斗");
::Reforged.Mod.Keybinds.addSQKeybind("ConfirmSkillUseKeybind", "ctrl", ::MSU.Key.State.Tactical, function ()
{
	return true;
}, "确认技能使用", null, "用于开关一些点击后立即使用的技能（如盾墙、集结部队）确认步骤的按键。根据你在\'确认技能使用\'选项中的设置不同，该快捷键使你可以预览技能的行动点数和疲劳消耗，或是跳过确认步骤。");
::Reforged.Mod.Keybinds.addSQKeybind("ToggleReforgedDevMode", "ctrl+tab", ::MSU.Key.State.All, function ()
{
	::Reforged.__toggleDevMode();
	return true;
}, "开关重铸开发模式", null, "用于开关重铸的开发模式，一次启用/关闭多个开发模式设置。");
