::Reforged.HooksMod.hook("scripts/skills/actives/throw_net", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.ActionPointCost = 5;
				this.m.MaxRange = 2;
				this.m.AIBehaviorID = ::Const.AI.Behavior.ID.ThrowNet;
			}

		}.create;
	};
	q.getTooltip = function ( __original )
	{
		return {
			function getTooltip()
			{
				local ret = __original();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("对目标施加[$ $|Skill+net_effect]效果")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.onVerifyTarget = function ( __original )
	{
		return {
			function onVerifyTarget( _originTile, _targetTile )
			{
				return __original(_originTile, _targetTile) && !_targetTile.getEntity().getCurrentProperties().IsImmuneToRoot && _targetTile.getEntity().getBaseProperties().Reach < ::Reforged.Reach.Default.NetImmune;
			}

		}.onVerifyTarget;
	};
	q.onNetSpawn = function ( __original )
	{
		return {
			function onNetSpawn( _data )
			{
				if (!_data.TargetEntity.isAlive() || !_data.TargetEntity.isPlacedOnMap())
				{
					return;
				}

				__original(_data);
			}

		}.onNetSpawn;
	};
});
