::Reforged.HooksMod.hook("scripts/skills/effects/shieldwall_effect", function ( q )
{
	q.onTurnStart = function ( __original )
	{
		return {
			function onTurnStart()
			{
				__original();
				local actor = this.getContainer().getActor();
				local hasPerk = this.getContainer().hasSkill("perk.rf_shield_sergeant");

				foreach( ally in ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1, true) )
				{
					if (::Math.abs(ally.getTile().Level - actor.getTile().Level) <= 1 && ally.getSkills().hasSkill("actives.shieldwall") && (hasPerk || ally.getSkills().hasSkill("perk.rf_shield_sergeant")))
					{
						this.m.IsGarbage = false;

						if (!actor.isHiddenToPlayer())
						{
							::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "因" + ::Const.UI.getColorizedEntityName(hasPerk ? actor : ally) + "的盾阵军士特技维持住了盾墙");
						}

						return;
					}
				}
			}

		}.onTurnStart;
	};
});
