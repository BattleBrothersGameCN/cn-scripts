this.return_favor_effect <- ::inherit("scripts/skills/skill", {
	m = {
		StunChance = 10,
		DazeChance = 50,
		StaggerChance = 75
	},
	function create()
	{
		this.m.ID = "effects.return_favor";
		this.m.Name = "以眼还眼";
		this.m.Description = "该角色会对相邻攻击者未命中的近战攻击进行猛烈回击。";
		this.m.Icon = "skills/rf_return_favor_effect.png";
		this.m.IconMini = "rf_return_favor_effect_mini";
		this.m.Overlay = "rf_return_favor_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("所有所有未命中该角色的相邻攻击者有" + ::MSU.Text.colorPositive(this.m.StunChance + "%") + "概率被[$ $|Skill+stunned_effect]，" + ::MSU.Text.colorPositive(this.m.DazeChance + "%") + "概率被[$ $|Skill+dazed_effect]以及" + ::MSU.Text.colorPositive(this.m.StaggerChance + "%") + "概率被[$ $|Skill+staggered_effect]")
		});
		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon != null && !weapon.isItemType(::Const.Items.ItemType.MeleeWeapon))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::MSU.Text.colorNegative("需要赤手空拳或持有近战武器")
			});
		}

		return ret;
	}

	function onMissed( _attacker, _skill )
	{
		if (!_skill.isRanged())
		{
			local actor = this.getContainer().getActor();
			local weapon = actor.getMainhandItem();

			if (weapon != null && !weapon.isItemType(::Const.Items.ItemType.MeleeWeapon))
			{
				return;
			}

			local distance = _attacker.getTile().getDistanceTo(actor.getTile());

			if (distance == 1 || weapon != null && weapon.getRangeMax() >= distance)
			{
				local r = ::Math.rand(1, 100);

				if (r <= this.m.StunChance && !_attacker.getCurrentProperties().IsImmuneToStun)
				{
					local effect = ::new("scripts/skills/effects/stunned_effect");
					effect.addTurns(1);
					_attacker.getSkills().add(effect);

					if (!actor.isHiddenToPlayer() && _attacker.getTile().IsVisibleForPlayer)
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "击晕了" + ::Const.UI.getColorizedEntityName(_attacker) + "持续1回合");
					}
				}
				else if (r <= this.m.DazeChance && !_attacker.getCurrentProperties().IsImmuneToDaze)
				{
					_attacker.getSkills().add(::new("scripts/skills/effects/dazed_effect"));

					if (!actor.isHiddenToPlayer() && _attacker.getTile().IsVisibleForPlayer)
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "茫然了" + ::Const.UI.getColorizedEntityName(_attacker) + "持续1回合");
					}
				}
				else if (r <= this.m.StaggerChance)
				{
					_attacker.getSkills().add(::new("scripts/skills/effects/staggered_effect"));

					if (!actor.isHiddenToPlayer() && _attacker.getTile().IsVisibleForPlayer)
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "趔趄了" + ::Const.UI.getColorizedEntityName(_attacker) + "持续1回合");
					}
				}
			}
		}
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

});
