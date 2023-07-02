this.emperors_armor_fake <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.emperors_armor";
		this.m.Name = "帝王铠甲";
		this.m.Description = "一件历史久远的帝王穿戴的闪亮铠甲，由许多伤人的材料打造而成，充满了神秘的力量。 打磨过的盔甲能很容易反射光线，使得穿戴者在白天闪闪发光。";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 80;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 20000;
		this.m.Condition = 380;
		this.m.ConditionMax = 380;
		this.m.StaminaModifier = -30;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "反弹 [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] 的肉搏伤害给攻击者"
		});
		return result;
	}

	function onDamageReceived( _damage, _fatalityType, _attacker )
	{
		this.armor.onDamageReceived(_damage, _fatalityType, _attacker);

		if (_attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) == 1 && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.Math.maxf(1.000000, _damage * 0.250000);
			hitInfo.DamageArmor = this.Math.maxf(1.000000, _damage * 0.250000);
			hitInfo.DamageDirect = 0.000000;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.000000;
			hitInfo.FatalityChanceMult = 0.000000;
			_attacker.onDamageReceived(_attacker, null, hitInfo);
		}
	}

});
