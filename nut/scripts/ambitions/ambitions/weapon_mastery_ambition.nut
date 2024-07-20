this.weapon_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.weapon_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "试想若技艺与勇气相当，你们能开辟出的恐惧之路。\n我们要训练五名武器专家，让他们充当开路先锋！";
		this.m.UIText = "拥有掌握武器精通特技的队员";
		this.m.TooltipText = "拥有5名掌握武器精通特技的队员，武器类型不论。";
		this.m.SuccessText = "[img]gfx/ui/events/event_50.png[/img]为了训练兄弟们精通武器，你采取了新的训练方法。这提升了大家的士气。参训者既通过磨练技艺提高了生存几率，又赢得了同伴们的钦佩，其他人则坐在圆木上边看热闹，边把羊肉吃得满脸都是。\n\n参训者一有时间，就会拿着各式各样的武器练习，直到把胳膊练得像橡树杈一样坚硬，眼睛练得像大猫一样敏锐无情。%SPEECH_ON%%weaponbrother%不光能吓退敌人，他灵活的步伐简直和舞女一样。%SPEECH_OFF%作出这番评论的%notweaponbrother%，最后被%weaponbrother%用训练剑狠狠收拾了一顿。";
		this.m.SuccessButtonText = "他们现在是专业人士了。";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(5, this.getBrosWithMastery()) + "/5)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInThrowing)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInSwords)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCleavers)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInMaces)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInHammers)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInAxes)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInFlails)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInSpears)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInPolearms)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInDaggers)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 5)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local not_candidates = [];

		if (brothers.len() > 2)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCrossbows)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInThrowing)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSwords)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInCleavers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInMaces)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInHammers)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInAxes)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInFlails)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInSpears)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInPolearms)
			{
				candidates.push(bro);
			}
			else if (p.IsSpecializedInDaggers)
			{
				candidates.push(bro);
			}
			else
			{
				not_candidates.push(bro);
			}
		}

		if (not_candidates.len() == 0)
		{
			not_candidates = brothers;
		}

		_vars.push([
			"weaponbrother",
			candidates[this.Math.rand(0, candidates.len() - 1)].getName()
		]);
		_vars.push([
			"notweaponbrother",
			not_candidates[this.Math.rand(0, not_candidates.len() - 1)].getName()
		]);
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});
