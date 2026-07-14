::Reforged.HooksMod.hook("scripts/entity/tactical/humans/nomad_archer", function ( q )
{
	q.onInit = function ()
	{
		return {
			function onInit()
			{
				this.human.onInit();
				local b = this.m.BaseProperties;
				b.setValues(::Const.Tactical.Actor.NomadArcher);
				b.TargetAttractionMult = 1.1;
				this.m.ActionPoints = b.ActionPoints;
				this.m.Hitpoints = b.Hitpoints;
				this.m.CurrentProperties = clone b;
				this.setAppearance();
				this.getSprite("socket").setBrush("bust_base_nomads");

				if (::Math.rand(1, 100) <= 20)
				{
					local pox = this.getSprite("tattoo_head");
					pox.Visible = true;
					pox.setBrush("bust_head_darkeyes_01");
				}
				else
				{
					local dirt = this.getSprite("dirt");
					dirt.Visible = true;
					dirt.Alpha = ::Math.rand(150, 255);
				}

				b.Vision = 8;
				this.m.Skills.add(::new("scripts/skills/actives/throw_dirt_skill"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
				this.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
			}

		}.onInit;
	};
	q.onSpawned = function ()
	{
		return {
			function onSpawned()
			{
				::Reforged.Skills.addPerkGroupOfEquippedWeapon(this, 4);
			}

		}.onSpawned;
	};
});
