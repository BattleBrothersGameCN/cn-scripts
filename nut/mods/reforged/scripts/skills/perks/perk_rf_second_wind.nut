this.perk_rf_second_wind <- ::inherit("scripts/skills/skill", {
	m = {
		ActionPointsTarget = 4
	},
	function create()
	{
		this.m.ID = "perk.rf_second_wind";
		this.m.Name = ::Const.Strings.PerkName.RF_SecondWind;
		this.m.Description = "只要短暂休息一下，该角色就能重振精神再拼一把。";
		this.m.Icon = "ui/perks/perk_rf_second_wind.png";
		this.m.Overlay = "perk_rf_second_wind";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !::Tactical.isActive() || this.getContainer().getActor().isWaitActionSpent();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("[等待|Concept.Wait]会恢复[行动点数|Concept.ActionPoints]，使其达到" + ::MSU.Text.colorPositive(this.m.ActionPointsTarget) + "点总[行动点数|Concept.ActionPoints]")
		});
		return ret;
	}

	function onWaitTurn()
	{
		local actor = this.getContainer().getActor();
		local recoveredActionPoints = ::Math.min(this.m.ActionPointsTarget, actor.getActionPointsMax()) - actor.getActionPoints();

		if (recoveredActionPoints > 0)
		{
			actor.setActionPoints(actor.getActionPoints() + recoveredActionPoints);
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "恢复了" + ::MSU.Text.colorPositive(recoveredActionPoints) + "点行动点数");
			this.spawnIcon(this.m.Overlay, actor.getTile());
		}
	}

});
