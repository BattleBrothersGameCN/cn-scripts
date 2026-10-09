::Reforged.HooksMod.hook("scripts/skills/effects/taunted_effect", function ( q )
{
	q.m.DefenseModifier <- 0;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色正受其他角色嘲讽，更可能接近并攻击那些角色。";
			}

		}.create;
	};
	q.isHidden = function ()
	{
		return {
			function isHidden()
			{
				return ::MSU.isNull(this.getTauntSource());
			}

		}.isHidden;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();

				if (::MSU.isEqual(this.getContainer().getActor(), ::MSU.getDummyPlayer()))
				{
					local resolveFraction = ::new("scripts/skills/actives/taunt").m.DefenseModifierFraction;

					if (resolveFraction != 0)
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/melee_defense.png",
							text = ::Reforged.Mod.Tooltips.parseString("[近战|Concept.MeleeDefense]和[远程|Concept.RangeDefense]防御降低，降低值为[嘲讽者|Skill+taunt][决心|Concept.Bravery]的" + ::MSU.Text.colorizePct(resolveFraction) + " of the [$ $|Skill+taunt] [Resolve|Concept.Bravery]")
						});
					}
				}
				else if (!::MSU.isNull(this.getTauntSource()))
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/icons/special.png",
						text = "This character has been taunted by " + ::MSU.Text.colorNegative(this.getTauntSource().getName())
					});

					if (this.getMeleeDefenseModifier() != 0)
					{
						ret.push({
							id = 10,
							type = "text",
							icon = "ui/icons/melee_defense.png",
							text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.getMeleeDefenseModifier(), {
								AddSign = true
							}) + "[近战防御|Concept.MeleeDefense]")
						});
					}

					if (this.getRangedDefenseModifier() != 0)
					{
						ret.push({
							id = 11,
							type = "text",
							icon = "ui/icons/ranged_defense.png",
							text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.getRangedDefenseModifier(), {
								AddSign = true
							}) + "[远程防御|Concept.RangeDefense]")
						});
					}
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				__original(_properties);

				if (this.getTauntSource() != null)
				{
					_properties.MeleeDefense += this.getMeleeDefenseModifier();
					_properties.RangedDefense += this.getRangedDefenseModifier();
				}
			}

		}.onUpdate;
	};
	q.getTauntSource <- {
		function getTauntSource()
		{
			local ret = this.getContainer().getActor().getAIAgent().getForcedOpponent();
			return !::MSU.isNull(ret) && ret.isAlive() ? ret : null;
		}

	}.getTauntSource;
	q.getMeleeDefenseModifier <- {
		function getMeleeDefenseModifier()
		{
			return this.m.DefenseModifier;
		}

	}.getMeleeDefenseModifier;
	q.getRangedDefenseModifier <- {
		function getRangedDefenseModifier()
		{
			return this.m.DefenseModifier;
		}

	}.getRangedDefenseModifier;
});
