::Reforged.HooksMod.hook("scripts/skills/racial/serpent_racial", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Name = "大蛇";
				this.m.Icon = "ui/orientation/serpent_orientation.png";
				this.m.Description = "该角色是一条大蛇";
				this.m.IsHidden = false;

				if (this.isType(::Const.SkillType.Perk))
				{
					this.removeType(::Const.SkillType.Perk);
				}
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.extend([
					{
						id = 12,
						type = "text",
						icon = "ui/icons/campfire.png",
						text = ::MSU.Text.colorNegative("33%") + " less burning damage received"
					},
					{
						id = 20,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不受[$ $|Skill+night_effect]惩罚影响")
					},
					{
						id = 23,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("免疫[$ $|Skill+disarmed_effect]")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.onAdded = function ()
	{
		return {
			function onAdded()
			{
				local baseProperties = this.getContainer().getActor().getBaseProperties();
				baseProperties.IsAffectedByNight = false;
				baseProperties.IsImmuneToDisarm = true;
			}

		}.onAdded;
	};
	q.onUpdate = function ( __original )
	{
		return {
			function onUpdate( _properties )
			{
				local old_DamageReceivedFireMult = _properties.DamageReceivedFireMult;
				__original(_properties);
				_properties.DamageReceivedFireMult = old_DamageReceivedFireMult;
			}

		}.onUpdate;
	};
	q.onBeforeDamageReceived = function ()
	{
		return {
			function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
			{
				switch(_hitInfo.DamageType)
				{
				case null:
					break;

				case ::Const.Damage.DamageType.Burning:
					_properties.DamageReceivedRegularMult *= 0.66;
					break;
				}
			}

		}.onBeforeDamageReceived;
	};
});
