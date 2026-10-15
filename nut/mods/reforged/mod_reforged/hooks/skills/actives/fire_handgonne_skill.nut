::Reforged.HooksMod.hook("scripts/skills/actives/fire_handgonne_skill", function ( q )
{
	q.m.AdditionalAccuracy = 10;
	q.m.AdditionalHitChance = -10;
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getDefaultTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "命中至多6个目标"
				});
				local rangedTooltip = this.getRangedTooltip();
				rangedTooltip[rangedTooltip.len() - 1].text += "。命中率不受射击线上的物体或角色影响";
				ret.extend(rangedTooltip);
				local ammo = this.getAmmo();

				if (ammo > 0)
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/icons/ammo.png",
						text = "剩余" + ::MSU.Text.colorPositive(ammo) + "发"
					});
				}
				else
				{
					ret.push({
						id = 8,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("需要装备非空火药包")
					});
				}

				if (!this.getItem().isLoaded())
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::MSU.Text.colorNegative("射击前须装填")
					});
				}

				if (this.getContainer().getActor().isEngagedInMelee())
				{
					ret.push({
						id = 9,
						type = "text",
						icon = "ui/tooltips/warning.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorNegative("角色[陷入近战|Concept.ZoneOfControl]，无法使用"))
					});
				}

				return ret;
			}

		}.getTooltip;
	};
	q.onAnySkillUsed = function ()
	{
		return {
			function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				if (_skill == this)
				{
					_properties.RangedSkill += this.m.AdditionalAccuracy;
					_properties.HitChanceAdditionalWithEachTile += this.m.AdditionalHitChance;
				}
			}

		}.onAnySkillUsed;
	};
	q.getAffectedTiles = function ( __original )
	{
		return {
			function getAffectedTiles( _targetTile )
			{
				if (_targetTile.getDistanceTo(this.getContainer().getActor().getTile()) != 2 || !this.getContainer().hasSkill("effects.rf_take_aim"))
				{
					return __original(_targetTile);
				}

				local ret = [
					_targetTile
				];
				local ownTile = this.getContainer().getActor().getTile();
				local addTiles = function ( _tile, _startDir, _forwardDir, _num )
				{
					local currDir = _startDir;

					for( local i = 0; i < _num && _tile.hasNextTile(currDir); i++ )
					{
						_tile = _tile.getNextTile(currDir);

						if (::Math.abs(_tile.Level - ownTile.Level) <= this.m.MaxLevelDifference)
						{
							ret.push(_tile);
						}

						currDir = _forwardDir;
					}
				};
				local dir = ownTile.getDirectionTo(_targetTile);
				addTiles(_targetTile, dir, dir, 2);
				local left = dir - 1 < 0 ? 5 : dir - 1;
				addTiles(_targetTile, left, dir, 3);
				local right = dir + 1 > 5 ? 0 : dir + 1;
				addTiles(_targetTile, right, dir, 3);
				return ret;
			}

		}.getAffectedTiles;
	};
});
