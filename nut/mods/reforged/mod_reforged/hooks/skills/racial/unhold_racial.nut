::Reforged.HooksMod.hook("scripts/skills/racial/unhold_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "巨魔";
				this.m.Icon = "ui/orientation/unhold_01_orientation.png";
				this.m.IsHidden = false;
				this.addType(::Const.SkillType.StatusEffect);
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/health.png",
					text = ::Reforged.Mod.Tooltips.parseString("每个[回合|Concept.Turn]开始时，恢复相当于其[生命值|Concept.Hitpoints]上限" + ::MSU.Text.colorPositive("15%") + "的[生命值|Concept.Hitpoints]")
				});
				local actor = this.getContainer().getActor();

				if (::MSU.isKindOf(actor, "unhold_armored") || ::MSU.isKindOf(actor, "unhold_frost_armored") || ::MSU.isEqual(actor, ::MSU.getDummyPlayer()))
				{
					local roundsForInitiativeBonus = ::Tactical.isActive() ? (::Tactical.State.isScenarioMode() ? 3 : 2) : "几";
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString("[回合|Concept.Turn]顺序由" + ::MSU.Text.colorPositive("+40") + " [Initiative|Concept.Initiative] during the first " + roundsForInitiativeBonus + "[回合|Concept.Round]")
					});
				}

				ret.push({
					id = 20,
					type = "text",
					icon = "ui/icons/special.png",
					text = "免疫缴械"
				});
				ret.push({
					id = 21,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+rotation]")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onAdded = function ()
	{
		return {
			function onAdded()
			{
				local actor = this.getContainer().getActor();
				local baseProperties = actor.getBaseProperties();
				baseProperties.IsImmuneToDisarm = true;
				baseProperties.IsImmuneToRotation = true;

				if (::MSU.isKindOf(actor, "unhold_armored") || ::MSU.isKindOf(actor, "unhold_frost_armored"))
				{
					this.m.Name = "装甲" + this.m.Name;
				}
			}

		}.onAdded;
	};
	q.onTurnStart = function ( __original )
	{
		return {
			function onTurnStart()
			{
				__original();
				local bleed = this.getContainer().getSkillByID("effects.bleeding");

				if (bleed != null)
				{
					bleed.m.Stacks /= 2;

					if (bleed.m.Stacks == 0)
					{
						bleed.removeSelf();
					}

					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + "愈合了部分流着血的伤口");
				}
			}

		}.onTurnStart;
	};
});
