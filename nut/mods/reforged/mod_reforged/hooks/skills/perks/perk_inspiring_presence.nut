::Reforged.HooksMod.hook("scripts/skills/perks/perk_inspiring_presence", function ( q )
{
	q.m.IsForceEnabled <- false;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色是战场上鼓舞人心的存在。";
				this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
				this.m.Icon = "ui/perks/perk_rf_inspiring_presence.png";
				this.m.IconMini = "perk_rf_inspiring_presence_mini";
			}

		}.create;
	};
	q.isHidden = function ()
	{
		return {
			function isHidden()
			{
				return !this.isEnabled();
			}

		}.isHidden;
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
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("若某个友军角色在其[回合|Concept.Turn]开始时接邻该角色，在其[陷入近战|Concept.ZoneOfControl]或是接邻[陷入近战|Concept.ZoneOfControl]的角色时，获得[$ $|Skill+rf_inspiring_presence_buff_effect]效果。")
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("本[特技|Concept.Perk]只对同阵营的友军生效")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.isEnabled <- {
		function isEnabled()
		{
			if (this.m.IsForceEnabled)
			{
				return true;
			}

			local weapon = this.getContainer().getActor().getMainhandItem();

			if (weapon != null && weapon.getID().find("banner") != null)
			{
				return true;
			}

			return false;
		}

	}.isEnabled;
	q.onCombatStarted = function ()
	{
		return {
			function onCombatStarted()
			{
			}

		}.onCombatStarted;
	};
});
