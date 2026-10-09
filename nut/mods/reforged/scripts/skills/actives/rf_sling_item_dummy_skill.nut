this.rf_sling_item_dummy_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_sling_item_dummy";
		this.m.Name = "抛投物品";
		this.m.Description = "使用你的投石索，抛出背包中的炸弹、罐子、瓶子等物品。";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;
		this.m.IsHidden = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "攻击范围和你装备的投石索相等"
		});
		return ret;
	}

});
