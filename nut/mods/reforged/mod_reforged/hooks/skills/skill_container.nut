::Reforged.HooksMod.hook("scripts/skills/skill_container", function ( q )
{
	q.onDamageReceived = function ( __original )
	{
		return {
			function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
			{
				local damage = _damageArmor + ::Math.min(_damageHitpoints, this.getActor().getHitpoints());
				__original(_attacker, _damageHitpoints, _damageArmor);

				if (_attacker != null && damage > 0)
				{
					local t = this.getActor().m.RF_DamageReceived;

					if (!(_attacker.getFaction() in t))
					{
						t[_attacker.getFaction()] <- {
							Total = 0.0
						};
					}

					if (!(_attacker.getID() in t[_attacker.getFaction()]))
					{
						t[_attacker.getFaction()][_attacker.getID()] <- 0.0;
					}

					t.Total += damage;
					t[_attacker.getFaction()].Total += damage;
					t[_attacker.getFaction()][_attacker.getID()] += damage;
				}
			}

		}.onDamageReceived;
	};
	q.update = function ( __original )
	{
		return {
			function update()
			{
				__original();

				if (!this.m.IsUpdating && this.getActor().isAlive())
				{
					this.onSkillsUpdated();
				}
			}

		}.update;
	};
	q.onSkillsUpdated <- {
		function onSkillsUpdated()
		{
			this.callSkillsFunctionWhenAlive("onSkillsUpdated", null, false);
		}

	}.onSkillsUpdated;
	q.onQueryTooltip = function ( __original )
	{
		return {
			function onQueryTooltip( _skill, _tooltip )
			{
				local ret = __original(_skill, _tooltip);
				local warnings = [];

				for( local i = _tooltip.len() - 1; i >= 0; i-- )
				{
					local entry = _tooltip[i];

					if (("icon" in entry) && (entry.icon == "ui/icons/warning.png" || entry.icon == "ui/tooltips/warning.png"))
					{
						warnings.push(_tooltip.remove(i));
					}
				}

				_tooltip.extend(warnings);
				return ret;
			}

		}.onQueryTooltip;
	};
	q.onCostsPreview = function ( __original )
	{
		return {
			function onCostsPreview( _costsPreview )
			{
				__original(_costsPreview);
				local actor = this.getActor();

				if (actor.getPreviewMovement() != null)
				{
					_costsPreview.fatiguePreview += actor.RF_getZOCEvasionFatigue();
				}
			}

		}.onCostsPreview;
	};
});
