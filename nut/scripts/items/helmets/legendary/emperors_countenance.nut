this.emperors_countenance <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.emperors_countenance";
		this.m.Name = "帝王尊容";
		this.m.Description = "一个展露帝王容貌的具有神秘能力的金色头盔。 当你把它放在阳光下时，面具感觉就像是在移动，似乎还会露出鄙夷之情。";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.HideCorpseHead = true;
		this.m.IsIndestructible = true;
		this.m.Variant = 84;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 20000;
		this.m.Condition = 400.000000;
		this.m.ConditionMax = 400.000000;
		this.m.StaminaModifier = -20;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "反弹[color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] 近战伤害反弹给攻击者"
		});
		return result;
	}

	function onDamageReceived( _damage, _fatalityType, _attacker )
	{
		this.helmet.onDamageReceived(_damage, _fatalityType, _attacker);

		if (_attacker != null && _attacker.isAlive() && _attacker.getHitpoints() > 0 && _attacker.getID() != this.getContainer().getActor().getID() && _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) == 1 && !_attacker.getCurrentProperties().IsImmuneToDamageReflection)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.Math.maxf(1.000000, _damage * 0.250000);
			hitInfo.DamageArmor = this.Math.maxf(1.000000, _damage * 0.250000);
			hitInfo.DamageDirect = 0.000000;
			hitInfo.BodyPart = this.Const.BodyPart.Head;
			hitInfo.BodyDamageMult = 1.000000;
			hitInfo.FatalityChanceMult = 0.000000;
			_attacker.onDamageReceived(_attacker, null, hitInfo);
		}
	}

});
