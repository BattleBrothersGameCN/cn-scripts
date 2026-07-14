this.perk_rf_soul_link <- ::inherit("scripts/skills/skill", {
	m = {
		TransferedPart = 0.4,
		TransferedMult = 1.0,
		TransferInfo = null
	},
	function create()
	{
		this.m.ID = "perk.rf_soul_link";
		this.m.Name = ::Const.Strings.PerkName.RF_SoulLink;
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("该角色与相邻友军建立了灵魂链接，会分流部分受到的[生命值|Concept.Hitpoints]伤害。");
		this.m.KilledString = "死于灵魂链接";
		this.m.Icon = "ui/perks/perk_rf_soul_link.png";
		this.m.IconMini = "perk_rf_soul_link_mini";
		this.m.Overlay = "perk_rf_soul_link";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_hex_damage_01.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_02.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_03.wav",
			"sounds/enemies/dlc2/hexe_hex_damage_04.wav"
		];
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	function isHidden()
	{
		return !this.hasLink();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive(this.m.TransferedPart * 100 + "%") + " of damage received to [Hitpoints|Concept.Hitpoints] is redirected")
		});
		return ret;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		this.m.TransferInfo = null;

		if (_damageHitpoints == 0)
		{
			return;
		}

		local link = this.getLink();

		if (link == null)
		{
			return;
		}

		local transferedDamageMult = 1.0 / (1.0 - this.m.TransferedPart) - 1.0;
		this.m.TransferInfo = {
			Attacker = ::MSU.asWeakTableRef(_attacker),
			Link = ::MSU.asWeakTableRef(link),
			Damage = ::Math.ceil(transferedDamageMult * _damageHitpoints * this.m.TransferedMult)
		};
	}

	function onAfterDamageReceived()
	{
		if (this.m.TransferInfo == null)
		{
			return;
		}

		this.transferDamage(this.m.TransferInfo.Attacker, this.m.TransferInfo.Link, this.m.TransferInfo.Damage);
		this.m.TransferInfo = null;
	}

	function onDeath( _fatalityType )
	{
		if (this.m.TransferInfo == null)
		{
			return;
		}

		this.transferDamage(this.m.TransferInfo.Attacker, this.m.TransferInfo.Link, this.m.TransferInfo.Damage);
		this.m.TransferInfo = null;
	}

	function onUpdate( _properties )
	{
		if (this.hasLink())
		{
			_properties.DamageReceivedRegularMult *= 1.0 - this.m.TransferedPart;
		}
	}

	function hasLink()
	{
		if (this.getLink() == null)
		{
			return false;
		}

		return true;
	}

	function getLink()
	{
		local candidates = [];
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();

		for( local i = 0; i < 6; i++ )
		{
			if (myTile.hasNextTile(i) == false)
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (!nextTile.IsOccupiedByActor)
				{
				}
				else
				{
					local nextEntity = nextTile.getEntity();

					if (!nextEntity.isAlliedWith(actor))
					{
					}
					else if (nextEntity.getSkills().hasSkill(this.m.ID))
					{
					}
					else
					{
						candidates.push(nextEntity);
					}
				}
			}
		}

		if (candidates.len() == 0)
		{
			return null;
		}

		return candidates[::Math.rand(0, candidates.len() - 1)];
	}

	function transferDamage( _attacker, _transferTarget, _damage )
	{
		if (_transferTarget == null || !_transferTarget.isAlive())
		{
			_transferTarget = this.getLink();
		}

		if (_transferTarget == null)
		{
			return;
		}

		if (this.m.SoundOnUse.len() != 0)
		{
			::Sound.play(this.m.SoundOnUse[::Math.rand(0, this.m.SoundOnUse.len() - 1)], ::Const.Sound.Volume.RacialEffect, _transferTarget.getPos());
		}

		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_transferTarget.onDamageReceived(_attacker, this, hitInfo);
	}

});
