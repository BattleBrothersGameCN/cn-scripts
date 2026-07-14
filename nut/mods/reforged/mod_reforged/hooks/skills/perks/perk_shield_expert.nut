::Reforged.HooksMod.hook("scripts/skills/perks/perk_shield_expert", function ( q )
{
	q.m.FatigueBeforeMiss <- 0;
	q.onAdded = function ( __original )
	{
		return {
			function onAdded()
			{
				__original();
				local shield = this.getContainer().getActor().getOffhandItem();

				if (shield != null)
				{
					this.onEquip(shield);
				}
			}

		}.onAdded;
	};
	q.onEquip = function ()
	{
		return {
			function onEquip( _item )
			{
				if (_item.isItemType(::Const.Items.ItemType.Shield) && _item.getID().find("buckler") == null)
				{
					_item.addSkill(::new("scripts/skills/actives/rf_cover_ally_skill"));
				}
			}

		}.onEquip;
	};
	q.onBeingAttacked = function ()
	{
		return {
			function onBeingAttacked( _attacker, _skill, _properties )
			{
				this.m.FatigueBeforeMiss = this.getContainer().getActor().getFatigue();
			}

		}.onBeingAttacked;
	};
	q.onMissed = function ()
	{
		return {
			function onMissed( _attacker, _skill )
			{
				local actor = this.getContainer().getActor();

				if (actor.getFatigue() > this.m.FatigueBeforeMiss)
				{
					actor.setFatigue(::Math.max(0, ::Math.min(actor.getFatigueMax(), this.m.FatigueBeforeMiss)));
				}
			}

		}.onMissed;
	};
});
