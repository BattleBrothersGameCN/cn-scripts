this.rf_cover_ally_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_cover_ally";
		this.m.Name = "掩护盟友";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("掩护一名相邻盟友，在其回合中，使其可以无视[控制区|Concept.ZoneOfControl]移动一格。提供掩护时，你的近战技能、近战防御、远程技能、远程防御会减少。如果你被击晕、定身或不在接邻目标，掩护就会消失。");
		this.m.Icon = "skills/rf_cover_ally_skill.png";
		this.m.IconDisabled = "skills/rf_cover_ally_skill_sw.png";
		this.m.Overlay = "rf_cover_ally_skill";
		this.m.SoundOnHit = [
			"sounds/combat/shieldwall_01.wav",
			"sounds/combat/shieldwall_02.wav",
			"sounds/combat/shieldwall_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.RF_CoverAlly;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("目标获得[掩护下移动|Skill+rf_move_under_cover_skill]技能，使其可以无视[控制区|Concept.ZoneOfControl]移动" + ::MSU.Text.colorPositive(1) + "格，并无视[控制区|Concept.ZoneOfControl]")
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Will put the target first in the next [round\'s|Concept.Round] [turn|Concept.Turn] while under your cover")
			}
		]);

		if (this.getContainer().getActor().getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("[定身|Concept.Rooted]时无法使用"))
			});
		}

		if (this.getContainer().hasSkill("effects.rf_covering_ally"))
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("已经在为盟友[提供掩护|Skill+rf_covering_ally_effect]，无法使用"))
			});
		}

		return ret;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return this.skill.isUsable() && actor.isPlacedOnMap() && !actor.getCurrentProperties().IsRooted && !actor.getCurrentProperties().IsStunned && !this.getContainer().hasSkill("effects.rf_covering_ally") && ::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1, true).len() != 0;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();
		return this.getContainer().getActor().isAlliedWith(target) && !target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsRooted && !target.getSkills().hasSkill("effects.rf_covered_by_ally") && !target.getSkills().hasSkill("effects.rf_covering_ally");
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + " provides cover to " + ::Const.UI.getColorizedEntityName(target));

			if (this.m.SoundOnHit.len() != 0)
			{
				::Sound.play(this.m.SoundOnHit[::Math.rand(0, this.m.SoundOnHit.len() - 1)], ::Const.Sound.Volume.Skill * 1.2, _user.getPos());
			}
		}

		local coveredByAllyEffect = ::new("scripts/skills/effects/rf_covered_by_ally_effect");
		coveredByAllyEffect.setCoverProvider(_user);
		target.getSkills().add(coveredByAllyEffect);
		local coveringAllyEffect = ::new("scripts/skills/effects/rf_covering_ally_effect");
		coveringAllyEffect.setAlly(target);
		_user.getSkills().add(coveringAllyEffect);
		return true;
	}

});
