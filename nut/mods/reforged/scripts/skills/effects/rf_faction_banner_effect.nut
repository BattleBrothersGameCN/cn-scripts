this.rf_faction_banner_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_faction_banner";
		this.m.Name = "为了王国！";
		this.m.Description = "与其贵族家族光荣的战旗同在，该角色使命在身，蔑视危险向前推进。";
		this.m.Icon = "ui/perks/perk_28.png";
		this.m.IconMini = "perk_28_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = ::Reforged.Mod.Tooltips.parseString("只要有人执掌战旗且友方人数多于敌方，就不会因友军阵亡而受到[士气检定|Concept.Morale]")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = true;
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local numEnemies = 0;

		foreach( factionID, faction in ::Tactical.Entities.getAllInstances() )
		{
			if (factionID == actor.getFaction())
			{
				continue;
			}

			foreach( entity in faction )
			{
				if (!entity.isAlliedWith(actor))
				{
					numEnemies = numEnemies + faction.len();
					break;
				}
			}
		}

		local allies = ::Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		if (numEnemies >= allies.len())
		{
			return;
		}

		local myTile = actor.getTile();

		foreach( ally in allies )
		{
			if (!ally.isPlacedOnMap())
			{
				continue;
			}

			local mainhand = ally.getMainhandItem();

			if (mainhand != null && mainhand.getID() == "weapon.faction_banner")
			{
				_properties.IsAffectedByDyingAllies = false;
				this.m.IsHidden = false;
				return;
			}
		}
	}

});
