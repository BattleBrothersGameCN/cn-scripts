this.named_full_metal_heater_shield <- this.inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.m.Variant = 5;
		this.updateVariant();
		this.m.ID = "shield.named_full_metal_heater";
		this.m.NameList = this.Const.Strings.ShieldNames;
		this.m.Description = "一面几乎完全由金属制成的精制扇形盾。沉重而耐用，比看起来还轻一些。非大师级工匠所不能造。";
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 1500;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -16;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_named_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_named_shield_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.named_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});
