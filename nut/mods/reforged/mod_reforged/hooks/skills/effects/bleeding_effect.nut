::Reforged.HooksMod.hook("scripts/skills/effects/bleeding_effect", function ( q )
{
	q.m.Stacks <- 1;
	q.m.StacksThisTurn <- 1;
	q.m.StacksForMoraleCheck <- 3;
	q.m.MaxMalusMult <- 0.5;
	q.m.SkillCount <- 0;
	q.create = function ( __original )
	{
		return {
			function create()
			{
				__original();
				this.m.Description = "该角色正在大量出血，行动变慢，丧失勇气，每回合都会失去生命值。";
				this.m.IsStacking = false;
			}

		}.create;
	};
	q.getTooltip = function ()
	{
		return {
			function getTooltip()
			{
				local ret = this.skill.getTooltip();
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = ::Reforged.Mod.Tooltips.parseString("每[回合|Concept.Turn]受到" + ::MSU.Text.colorNegative(this.getDamage()) + "点伤害/每[回合|Concept.Turn]")
				});

				if (this.getContainer().getActor().getID() == ::MSU.getDummyPlayer().getID())
				{
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString("[主动值|Concept.Initiative]和[决心|Concept.Bravery]会按照叠加层数降低，最多降低" + ::MSU.Text.colorizeMult(this.m.MaxMalusMult) + "。角色的当前[生命值|Concept.Hitpoints]越低，每层的减益就越高。")
					});
				}
				else
				{
					local malusMult = ::Math.round(this.getMalusMult() * 100) / 100.0;
					ret.push({
						id = 11,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMult(malusMult) + " less [Resolve|Concept.Bravery]")
					});
					ret.push({
						id = 12,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMult(malusMult) + " less [Initiative|Concept.Initiative]")
					});
				}

				ret.push({
					id = 13,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("如果单[回合|Concept.Turn]中叠加的层数超过" + ::MSU.Text.colorNegative(this.getStacksForMoraleCheck()) + "层时，若在单个[回合|Concept.Turn]内获得这些层数，则立即触发一次负面[士气检定|Concept.Morale]")
				});
				return ret;
			}

		}.getTooltip;
	};
	q.getName = function ()
	{
		return {
			function getName()
			{
				return this.m.Stacks == 1 ? this.m.Name : this.m.Name + " (x" + this.m.Stacks + ")";
			}

		}.getName;
	};
	q.getDescription = function ()
	{
		return {
			function getDescription()
			{
				return this.m.Description;
			}

		}.getDescription;
	};
	q.getMalusMult <- {
		function getMalusMult()
		{
			local actor = this.getContainer().getActor();
			local debuff = ::Math.minf(this.m.MaxMalusMult, 2 * this.m.Stacks.tofloat() / actor.getHitpoints());
			debuff = debuff * actor.getCurrentProperties().RF_BleedingEffectMult;
			return ::Math.maxf(0, 1.0 - debuff);
		}

	}.getMalusMult;
	q.getDamage = function ()
	{
		return {
			function getDamage()
			{
				return ::Math.floor(this.m.Stacks * this.getContainer().getActor().getCurrentProperties().RF_BleedingEffectMult);
			}

		}.getDamage;
	};
	q.getStacksForMoraleCheck <- {
		function getStacksForMoraleCheck()
		{
			return ::Math.max(1, this.m.StacksForMoraleCheck / this.getContainer().getActor().getCurrentProperties().RF_BleedingEffectMult);
		}

	}.getStacksForMoraleCheck;
	q.onUpdate = function ()
	{
		return {
			function onUpdate( _properties )
			{
				local mult = this.getMalusMult();
				_properties.InitiativeMult *= mult;
				_properties.BraveryMult *= mult;
			}

		}.onUpdate;
	};
	q.applyDamage = function ()
	{
		return {
			function applyDamage()
			{
				if (this.m.LastRoundApplied != ::Time.getRound())
				{
					this.m.LastRoundApplied = ::Time.getRound();
					local actor = this.getContainer().getActor();
					this.spawnIcon(this.m.Overlay, actor.getTile());
					local damage = [
						this.getDamage()
					];
					local i = 0;

					while (i < damage.len() && damage[i] > 10)
					{
						damage.push(damage[i] - 10);
						damage[i] = 10;
						i++;
					}

					foreach( d in damage )
					{
						if (this.isGarbage() || !actor.isAlive() || actor.isDying())
						{
							return;
						}

						local hitInfo = clone ::Const.Tactical.HitInfo;
						hitInfo.DamageDirect = 1.0;
						hitInfo.BodyPart = ::Const.BodyPart.Body;
						hitInfo.BodyDamageMult = 1.0;
						hitInfo.FatalityChanceMult = 0.0;
						hitInfo.DamageRegular = d;
						actor.onDamageReceived(actor, this, hitInfo);
					}
				}
			}

		}.applyDamage;
	};
	q.onAdded = function ( __original )
	{
		return {
			function onAdded()
			{
				__original();
				this.m.SkillCount = ::Const.SkillCounter;
			}

		}.onAdded;
	};
	q.onRefresh = function ()
	{
		return {
			function onRefresh()
			{
				local actor = this.getContainer().getActor();

				if (actor.getCurrentProperties().IsResistantToAnyStatuses && ::Math.rand(1, 100) <= 50)
				{
					if (!actor.isHiddenToPlayer())
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "靠他的后天生理机能迅速止血");
					}

					return;
				}

				this.m.Stacks++;

				if (this.m.SkillCount != ::Const.SkillCounter)
				{
					this.spawnIcon(this.m.Overlay, actor.getTile());
				}
				else
				{
					local original_SkillIconStayDuration = ::Const.Tactical.Settings.SkillIconStayDuration;
					local original_SkillIconOffsetY = ::Const.Tactical.Settings.SkillIconOffsetY;
					::Const.Tactical.Settings.SkillIconStayDuration *= 0.3;
					::Const.Tactical.Settings.SkillIconOffsetY *= 0.6;
					this.spawnIcon(this.m.Overlay, actor.getTile());
					::Const.Tactical.Settings.SkillIconStayDuration = original_SkillIconStayDuration;
					::Const.Tactical.Settings.SkillIconOffsetY = original_SkillIconOffsetY;
				}

				this.m.SkillCount = ::Const.SkillCounter;

				if (++this.m.StacksThisTurn == this.getStacksForMoraleCheck())
				{
					actor.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - actor.getHitpoints() / actor.getHitpointsMax()));
				}
			}

		}.onRefresh;
	};
	q.onTurnStart = function ()
	{
		return {
			function onTurnStart()
			{
				this.m.StacksThisTurn = 0;
			}

		}.onTurnStart;
	};
});
