::Reforged.InheritHelper <- {
	function slingItemSkill( _superName )
	{
		return {
			m = {},
			function create()
			{
				this[_superName].create();
				this.m.ID = ::MSU.String.replace(this.m.ID, "throw", "sling");
				this.m.Name = ::MSU.String.replace(this.m.Name, "投掷", "抛投");
				this.m.Description = ::MSU.String.replace(::MSU.String.replace(this.m.Description, "throw", "sling"), "投掷", "抛投");
				this.m.Order = ::Const.SkillOrder.UtilityTargeted + 1000;
				this.m.ActionPointCost = 5;
				this.m.FatigueCost = 25;
				this.m.MinRange = 2;
				this.m.MaxRange = 6;
				this.m.MaxLevelDifference = 4;
				this.m.IsRanged = true;
				this.m.IsHidden = true;
				this.m.ProjectileTimeScale = 1.0;
			}

			function isHidden()
			{
				local weapon = this.getContainer().getActor().getMainhandItem();

				if (weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
				{
					return false;
				}

				return this[_superName].isHidden();
			}

			function getTooltip()
			{
				local ret = this[_superName].getTooltip();
				ret.push({
					id = 8,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "平地上的射程为" + ::MSU.Text.colorPositive(this.getMaxRange()) + "格，向低处射击则会更远"
				});

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

			function onUse( _user, _targetTile )
			{
				local effectDelay = 1;

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
				{
					if (_user.getTile().getDistanceTo(_targetTile) >= ::Const.Combat.SpawnProjectileMinDist)
					{
						local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
						effectDelay = ::Tactical.spawnProjectileEffect(::Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					}
				}

				this.getItem().removeSelf();
				::Time.scheduleEvent(::TimeUnit.Virtual, effectDelay, this.onApply.bindenv(this), {
					Skill = this,
					User = _user,
					TargetTile = _targetTile
				});
			}

			function isUsable()
			{
				return !this.getContainer().getActor().isEngagedInMelee() && this[_superName].isUsable();
			}

			function onUpdate( _properties )
			{
				this[_superName].onUpdate(_properties);
				local weapon = this.getContainer().getActor().getMainhandItem();

				if (weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Sling))
				{
					this.m.MinRange = weapon.getRangeMin();
					this.m.MaxRange = weapon.getRangeMax();
				}
			}

		};
	}

};
