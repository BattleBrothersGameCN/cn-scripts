::Reforged.HooksMod.hook("scripts/skills/actives/throw_dirt_skill", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色口袋里藏着不少沙子，随时可以投向某人。";
				this.m.Order = ::Const.SkillOrder.UtilityTargeted;
			}

		}.create;
	};
	q.onVerifyTarget = function ( __original )
	{
		return {
			function onVerifyTarget( _originTile, _targetTile )
			{
				return __original(_originTile, _targetTile) && !_targetTile.getEntity().getSkills().hasSkill("effects.distracted");
			}

		}.onVerifyTarget;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultUtilityTooltip();
				local distractedEffect = ::new("scripts/skills/effects/distracted_effect");
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("对目标施加[$ $|Skill+distracted_effect]效果"),
					children = distractedEffect.getTooltip().slice(2)
				});
				return ret;
			}

		}.getTooltip;
	};
});
