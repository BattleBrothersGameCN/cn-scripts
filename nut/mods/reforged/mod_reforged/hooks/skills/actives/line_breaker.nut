::Reforged.HooksMod.hook("scripts/skills/actives/line_breaker", function ( q )
{
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "铲除敌人，摧毁阵线。";
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.getDefaultUtilityTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "将目标击退，移动到其位置"
				});
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("额外施加" + ::MSU.Text.colorNegative("10") + "点[疲劳值|Concept.Fatigue]")
				});

				if (this.getContainer().getActor().getCurrentProperties().IsRooted)
				{
					ret.push({
						id = 20,
						type = "text",
						icon = "ui/icons/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("被[定身|Concept.Rooted]时无法使用"))
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.isUsable = function ( __original )
	{
		return {
			function isUsable()
			{
				return __original() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
			}

		}.isUsable;
	};
	q.findTileToKnockBackTo = function ()
	{
		return {
			function findTileToKnockBackTo( _userTile, _targetTile )
			{
				local getValidTileInDir = function ( _dir )
				{
					if (_targetTile.hasNextTile(_dir))
					{
						local tile = _targetTile.getNextTile(_dir);

						if (tile.IsEmpty && (tile.Level <= _targetTile.Level || tile.Level - _targetTile.Level == 1))
						{
							return tile;
						}
					}

					return null;
				};
				local dir = _userTile.getDirectionTo(_targetTile);
				local knockToTile = getValidTileInDir(dir);

				if (knockToTile != null)
				{
					return knockToTile;
				}

				local altdir = dir - 1 >= 0 ? dir - 1 : 5;
				knockToTile = getValidTileInDir(altdir);

				if (knockToTile != null)
				{
					return knockToTile;
				}

				altdir = dir + 1 <= 5 ? dir + 1 : 0;
				knockToTile = getValidTileInDir(altdir);

				if (knockToTile != null)
				{
					return knockToTile;
				}

				return null;
			}

		}.findTileToKnockBackTo;
	};
	q.onFollow = function ( __original )
	{
		return {
			function onFollow( _tag )
			{
				if (::Time.getVirtualSpeed() > 2)
				{
					::Time.scheduleEvent(::TimeUnit.Virtual, 100, __original, _tag);
				}
				else
				{
					__original(_tag);
				}
			}

		}.onFollow;
	};
});
