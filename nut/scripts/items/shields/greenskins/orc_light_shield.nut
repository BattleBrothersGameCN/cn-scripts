this.orc_light_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.orc_light_shield";
		this.m.Name = "野性盾牌";
		this.m.Description = "一面用皮革包覆的轻质木盾。凭借其尺寸提供了良好的远程防护，可惜不够坚固。";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.updateVariant();
		this.m.Value = 50;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -12;
		this.m.Condition = 16;
		this.m.ConditionMax = 16;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_orc_01";
		this.m.SpriteDamaged = "shield_orc_01_damaged";
		this.m.ShieldDecal = "shield_orc_01_destroyed";
		this.m.IconLarge = "shields/orc_wooden_shield_140x70.png";
		this.m.Icon = "shields/orc_wooden_shield_70x70.png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});
