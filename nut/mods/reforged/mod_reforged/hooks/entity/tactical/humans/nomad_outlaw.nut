::Reforged.HooksMod.hook("scripts/entity/tactical/humans/nomad_outlaw", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.NomadOutlaw);
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_nomads");

				if (::Math.rand(1, 100) <= 15)
				{
					local pox = this.getSprite("tattoo_head");
					pox.Visible = true;
					pox.setBrush("bust_head_darkeyes_01");
				}
				else
				{
					local dirt = this.getSprite("dirt");
					dirt.Visible = true;
				}

				if (::Math.rand(1, 100) <= 25)
				{
					this.getSprite("eye_rings").Visible = true;
				}

				this.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
				this.m.Skills.add(::new("scripts/skills/actives/throw_dirt_skill"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
			}

		}.onInit;
	};
	q.assignRandomEquipment = function ( __original )
	{
		return {
			function assignRandomEquipment()
			{
				__original();
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);
			}

		}.assignRandomEquipment;
	};
});
