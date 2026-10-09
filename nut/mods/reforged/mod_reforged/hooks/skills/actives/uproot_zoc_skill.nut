::Reforged.HooksMod.hook("scripts/skills/actives/uproot_zoc_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.SoundOnHitHitpoints = [
					"sounds/combat/break_free_roots_00.wav",
					"sounds/combat/break_free_roots_01.wav",
					"sounds/combat/break_free_roots_02.wav",
					"sounds/combat/break_free_roots_03.wav"
				];
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("从地上升起带刺的粗壮根系，攻击试图[离开|Concept.ZoneOfControl]你的人！");
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultTooltip();
				ret.extend([
					{
						id = 10,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("命中时，使目标陷入[$ $|Skill+staggered_effect]和[$ $|Skill+rooted_effect]")
					},
					{
						id = 11,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("不会伤害或影响其他树人")
					}
				]);
				return ret;
			}

		}.getTooltip;
	};
	q.onTargetHit = function ()
	{
		return {
			function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
			{
				if (_skill == this && _targetEntity.isAlive() && _targetEntity.getType() != ::Const.EntityType.Schrat && _targetEntity.getType() != ::Const.EntityType.SchratSmall)
				{
					_targetEntity.getSkills().add(::new("scripts/skills/effects/rooted_effect"));
					local breakFree = ::new("scripts/skills/actives/break_free_skill");
					breakFree.setDecal("roots_destroyed");
					breakFree.m.Icon = "skills/active_75.png";
					breakFree.m.IconDisabled = "skills/active_75_sw.png";
					breakFree.m.Overlay = "active_75";
					breakFree.m.SoundOnUse = this.m.SoundOnHitHitpoints;
					_targetEntity.getSkills().add(breakFree);
					_targetEntity.raiseRootsFromGround("bust_roots", "bust_roots_back");
				}
			}

		}.onTargetHit;
	};
	q.onQueryTooltip = function ( __original )
	{
		return {
			function onQueryTooltip( _skill, _tooltip )
			{
				if (_skill.getID() == "actives.uproot")
				{
					_tooltip.push({
						id = 100,
						type = "text",
						icon = "ui/icons/special.png",
						text = ::Reforged.Mod.Tooltips.parseString("[借机攻击|Concept.ZoneOfControl]成功时，将目标[$ $|Skill+rooted_effect]")
					});
				}
			}

		}.onQueryTooltip;
	};
});
