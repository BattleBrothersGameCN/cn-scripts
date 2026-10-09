::Reforged.HooksMod.hook("scripts/skills/effects/net_effect", function ( q )
{
	q.m.MeleeDefenseMult <- 0.75;
	q.m.RangedDefenseMult <- 0.55;
	q.m.InitiativeMult <- 0.55;
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/icons/action_points.png",
					text = ::MSU.Text.colorNegative("无法移动")
				});

				if (this.m.MeleeDefenseMult != 1.0)
				{
					ret.push({
						id = 10,
						type = "text",
						icon = "ui/icons/melee_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.MeleeDefenseMult) + "[近战防御|Concept.MeleeDefense]")
					});
				}

				if (this.m.RangedDefenseMult != 1.0)
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/ranged_defense.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.RangedDefenseMult) + "[远程防御|Concept.RangeDefense]")
					});
				}

				if (this.m.InitiativeMult != 1.0)
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(this.m.InitiativeMult) + "[主动值|Concept.Initiative]")
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onUpdate = function ()
	{
		return {
			function onUpdate( _properties )
			{
				_properties.IsRooted = true;
				_properties.MeleeDefenseMult *= this.m.MeleeDefenseMult;
				_properties.RangedDefenseMult *= this.m.RangedDefenseMult;
				_properties.InitiativeMult *= this.m.InitiativeMult;
			}

		}.onUpdate;
	};
});
