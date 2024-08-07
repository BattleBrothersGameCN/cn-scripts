this.obsidian_dagger <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.obsidian_dagger";
		this.m.Name = "黑曜石匕首";
		this.m.Description = "一位隐居女巫用你的血回火了这把匕首，又将它赠与了你。匕首镜面般光洁的表面上映出了一个个会自行活动的倒影，不用说，这肯定又是什么利用了视错觉的障眼法罢了。然而出乎你意料的是，沾染在黑曜石上的血液似乎都永远不会干涸，这可真是奇怪。";
		this.m.Categories = "匕首，单手持";
		this.m.IconLarge = "weapons/melee/obsidian_dagger_01.png";
		this.m.Icon = "weapons/melee/obsidian_dagger_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_obsidian_dagger";
		this.m.Condition = 1.0;
		this.m.ConditionMax = 1.0;
		this.m.Value = 5000;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "杀死的任何人类单位都将复活为丧尸为你而战"
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/stab"));
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

	function onDamageDealt( _target, _skill, _hitInfo )
	{
		this.weapon.onDamageDealt(_target, _skill, _hitInfo);

		if (!this.isKindOf(_target, "player") && !this.isKindOf(_target, "human"))
		{
			return;
		}

		if (_target.getHitpoints() > 0)
		{
			return;
		}

		if (_hitInfo.Tile.IsCorpseSpawned && _hitInfo.Tile.Properties.get("Corpse").IsResurrectable)
		{
			local corpse = _hitInfo.Tile.Properties.get("Corpse");
			corpse.Faction = this.Const.Faction.PlayerAnimals;
			corpse.Hitpoints = 1.0;
			corpse.Items = _target.getItems();
			corpse.IsConsumable = false;
			corpse.IsResurrectable = false;
			this.Time.scheduleEvent(this.TimeUnit.Rounds, this.Math.rand(1, 1), this.Tactical.Entities.resurrect, corpse);
		}
	}

});
