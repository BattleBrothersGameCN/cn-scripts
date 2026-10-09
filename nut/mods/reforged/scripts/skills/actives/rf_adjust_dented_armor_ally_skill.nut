this.rf_adjust_dented_armor_ally_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_adjust_dented_armor_ally";
		this.m.Name = "整修盟友护甲";
		this.m.Description = "整修盟友凹损的护甲";
		this.m.Icon = "skills/rf_adjust_dented_armor_ally_skill.png";
		this.m.IconDisabled = "skills/rf_adjust_dented_armor_ally_skill_sw.png";
		this.m.Overlay = "rf_adjust_dented_armor_ally_skill";
		this.m.SoundOnUse = [
			"sounds/ambience/settlement/fortification_armor_weapons_00.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_01.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_02.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_03.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_04.wav",
			"sounds/ambience/settlement/fortification_armor_weapons_05.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("移除[护甲凹损|Skill+rf_dented_armor_effect]效果")
		});

		if (this.getContainer().getActor().isEngagedInMelee())
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
			});
		}

		return ret;
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap())
		{
			local myTile = actor.getTile();

			for( local i = 0; i < 6; i++ )
			{
				if (myTile.hasNextTile(i))
				{
					local tile = myTile.getNextTile(i);

					if (::Math.abs(tile.Level - myTile.Level) <= 1 && tile.IsOccupiedByActor && !tile.getEntity().isEngagedInMelee() && actor.isAlliedWith(tile.getEntity()) && tile.getEntity().getSkills().hasSkill("effects.rf_dented_armor"))
					{
						return false;
					}
				}
			}
		}

		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.m.Container.getActor().isAlliedWith(target))
		{
			return false;
		}

		if (target.getSkills().hasSkill("effects.rf_dented_armor"))
		{
			return true;
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnIcon("rf_adjust_dented_armor_ally_skill", _targetTile);
		target.getSkills().removeByID("effects.rf_dented_armor");
		target.setDirty(true);
		return true;
	}

});
