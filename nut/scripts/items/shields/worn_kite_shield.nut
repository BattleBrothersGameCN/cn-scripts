this.worn_kite_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.worn_kite_shield";
		this.m.Name = "破旧筝形盾";
		this.m.Description = "一面能护住下半身的细长木制盾牌。在近身战斗中稍显笨重。";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.updateVariant();
		this.m.Value = 150;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -16;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_kite_enemy_01";
		this.m.SpriteDamaged = "shield_kite_enemy_01_damaged";
		this.m.ShieldDecal = "shield_kite_enemy_01_destroyed";
		this.m.IconLarge = "shields/inventory_kite_shield_enemy_01.png";
		this.m.Icon = "shields/icon_kite_shield_enemy_01.png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});
