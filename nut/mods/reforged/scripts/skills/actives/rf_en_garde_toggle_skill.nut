this.rf_en_garde_toggle_skill <- ::inherit("scripts/skills/skill", {
	m = {
		IsOn = true,
		FatigueRequired = 15,
		ReturnFavorSounds = [
			"sounds/combat/return_favor_01.wav"
		],
		__AdjustRebuke = false
	},
	function create()
	{
		this.m.ID = "actives.rf_en_garde_toggle";
		this.m.Name = "开关接战势";
		this.m.Description = ::Reforged.Mod.Tooltips.parseString("切换是否启用[$ $|Perk+perk_rf_en_garde]特技。");
		this.m.Icon = "skills/rf_en_garde_toggle_on.png";
		this.m.IconDisabled = "skills/rf_en_garde_toggle_sw.png";
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.ReturnFavorSounds )
		{
			::Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "当前" + (this.m.IsOn ? ::MSU.Text.colorPositive("已启用") : ::MSU.Text.colorNegative("未启用"))
		});
		return ret;
	}

	function isEnabled()
	{
		if (this.getContainer().getActor().isDisarmed())
		{
			return false;
		}

		local weapon = this.getContainer().getActor().getMainhandItem();

		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword))
		{
			return false;
		}

		return true;
	}

	function isHidden()
	{
		return !this.getContainer().getActor().isPlacedOnMap() || !this.isEnabled();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function pickSkill()
	{
		if (!this.isEnabled())
		{
			return null;
		}

		if (this.getContainer().getActor().getFatigueMax() - this.getContainer().getActor().getFatigue() < this.m.FatigueRequired)
		{
			local meisterhau = this.getContainer().getSkillByID("actives.rf_swordmaster_stance_meisterhau");

			if (meisterhau == null || !meisterhau.m.IsOn)
			{
				return null;
			}
		}

		local riposte = this.getContainer().getSkillByID("actives.riposte");

		if (riposte != null)
		{
			return riposte;
		}
		else
		{
			this.m.__AdjustRebuke = true;
			return ::Reforged.new("scripts/skills/perks/perk_rf_rebuke", function ( o )
			{
				o.m.IsSerialized = false;
				o.m.IsRefundable = false;
			});
		}
	}

	function onTurnEnd()
	{
		if (!this.m.IsOn)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap() || !actor.hasZoneOfControl() || ::Tactical.State.isAutoRetreat())
		{
			return;
		}

		local skill = this.pickSkill();

		if (skill != null)
		{
			if (skill.getID() == "actives.riposte")
			{
				skill.useForFree(actor.getTile());
			}
			else
			{
				if (this.getContainer().hasSkill(skill.getID()))
				{
					this.spawnIcon(skill.m.Overlay, actor.getTile());
				}

				this.getContainer().add(skill);

				if (actor.getTile().IsVisibleForPlayer)
				{
					::Sound.play(this.m.ReturnFavorSounds[::Math.rand(0, this.m.ReturnFavorSounds.len() - 1)], ::Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos());
				}
			}
		}
	}

	function onTurnStart()
	{
		if (this.m.__AdjustRebuke)
		{
			this.getContainer().removeByStackByID("perk.rf_rebuke", false);
			this.m.__AdjustRebuke = false;
		}
	}

	function onUpdate( _properties )
	{
		if (this.m.__AdjustRebuke)
		{
			local rebuke = this.getContainer().getSkillByID("perk.rf_rebuke");

			if (rebuke != null)
			{
				rebuke.m.BaseChance += 15;
				rebuke.m.BuildsFatigue = false;
			}
		}
	}

	function onAfterUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPreviewing())
		{
			return;
		}

		local meisterhau = this.getContainer().getSkillByID("actives.rf_swordmaster_stance_meisterhau");

		if (meisterhau == null || !meisterhau.m.IsOn)
		{
			this.m.FatigueCost = this.m.FatigueRequired;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.setOnOff(!this.m.IsOn);
		return true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();

		if (this.m.__AdjustRebuke)
		{
			this.getContainer().removeByStackByID("perk.rf_rebuke", false);
			this.m.__AdjustRebuke = false;
		}

		this.setOnOff(true);
	}

	function setOnOff( _onOrOff )
	{
		this.m.IsOn = _onOrOff;
		this.m.Icon = _onOrOff ? "skills/rf_en_garde_toggle_on.png" : "skills/rf_en_garde_toggle_off.png";
	}

});
