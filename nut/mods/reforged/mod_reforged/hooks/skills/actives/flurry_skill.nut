::Reforged.HooksMod.hook("scripts/skills/actives/flurry_skill", function ( q )
{
	q.m.NumAttacks <- 6;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = ::Reforged.Mod.Tooltips.parseString("一记捉摸不定的近战钝击攻击，造成六次伤害，平均分配到所有接邻敌人身上。");
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				return this.skill.getDefaultTooltip();
			}

		}.getTooltip;
	};
	q.onUse = function ()
	{
		return {
			function onUse( _user, _targetTile )
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnHit), 1.0, _targetTile.Pos);
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_user) + "朝它周围胡乱地挥击。");
				local ownTile = _user.getTile();
				local maxLevelDifference = this.m.MaxLevelDifference;
				local tag = {
					User = _user,
					TargetEntities = ::MSU.Tile.getNeighbors(ownTile).filter(function ( _, _t )
					{
						return _t.IsOccupiedByActor && ::Math.abs(_t.Level - ownTile.Level) <= maxLevelDifference && !_user.isAlliedWith(_t.getEntity());
					}).map(function ( _t )
					{
						return _t.getEntity();
					}),
					CurrentIndex = 0,
					NumAttacks = this.m.NumAttacks,
					Callback = this.RF_doFlurry.bindenv(this)
				};
				this.getContainer().setBusy(true);
				this.RF_doFlurry(tag);
				return true;
			}

		}.onUse;
	};
	q.RF_doFlurry <- {
		function doFlurry( _tag )
		{
			if (!_tag.User.isAlive())
			{
				return;
			}

			local targetEntity = _tag.TargetEntities[_tag.CurrentIndex];

			if (!targetEntity.isAlive() || !targetEntity.isAttackable())
			{
				_tag.TargetEntities.remove(_tag.CurrentIndex--);
			}
			else
			{
				this.spawnAttackEffect(targetEntity.getTile(), ::Const.Tactical.AttackEffectChop);
				this.attackEntity(_tag.User, targetEntity);
				_tag.NumAttacks--;
			}

			if (_tag.NumAttacks == 0 || _tag.TargetEntities.len() == 0)
			{
				this.getContainer().setBusy(false);
			}
			else
			{
				if (++_tag.CurrentIndex >= _tag.TargetEntities.len())
				{
					_tag.CurrentIndex = 0;
				}

				::Time.scheduleEvent(::TimeUnit.Virtual, 200, _tag.Callback, _tag);
			}
		}

	}.doFlurry;
});
