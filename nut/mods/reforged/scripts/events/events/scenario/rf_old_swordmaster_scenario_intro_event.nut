this.rf_old_swordmaster_scenario_intro_event <- ::inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.rf_old_swordmaster_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]蜡烛的火光随着微风摇曳，在你小屋粗糙的墙上投下长长的影子。几十年来，这个隐匿在野生森林边缘的地方，一直是你的庇身之所。在这里，你磨练着自己的技艺，身体铸成武器，心灵砺成磨石。剑一直是你唯一的伴侣 ―― 一言不发地见证着你的战斗和胜利。然而，随着生命的暮色愈发接近，你想到的不是战斗和胜利，而是寂静 ―― 寂静将伴随你离世。\n\n时间还真是奇妙。曾经有力的双臂早已动摇，意志未灭却止不住双手的颤抖。这些老骨头每响一次，都会让你感受到知识的重量。如果这些知识不被传承，那它们就会像晨雾一样，最终消散。剑术不仅仅是挥舞钢铁，还是一种哲学，一种原则，一种看待世界的方式。是混乱中平稳的呼吸，是风暴中心的平静。它塑造了你，但如果它塑造不了别人，又何谈有什么价值。\n\n一定会有这么一个人 ―― 一位探索者，一位漫游者，甚至一个傻瓜 ―― 值得传承这门技艺。你回想起第一次握剑时的惊奇与兴奋，在课堂中求索的畅快，以及面对浩如烟海的知识的敬畏。那种火花必定存在于某个人身上，一个能接过你的毕生所学，将其继承、改进、践行、发扬的人。\n\n于是，你下定决心，要传授你的技艺。不是为了身后名 ―― 声名易逝，而是要让这些知识超越你生命的界限。剑术之道不必藏私；就像一条河，从一人流向另一人的手中。你要去寻找那些愿意学习的人。你留下的寂静将不会空洞，而是充满了钢铁碰撞的回响，传道解惑的回声。\n\n烛火将尽，但它的光芒尚能指引你。当你站起身，你的剑就像老朋友一样靠在墙上，给了你莫名的希望。你的生命不再属于你自己；它是一座通向后来者的桥梁，你已经准备好迎接他们，把你的毕生所学倾囊相授。",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "是时候了……",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				foreach( l in ::World.EntityManager.getLocations() )
				{
					if (l.getTypeID() == "location.fountain_of_youth")
					{
						::logInfo("Removing the Fountain of Youth (Grotesque Tree) location");
						l.fadeOutAndDie();
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "起源介绍";
				local avatarEffect = ::new("scripts/skills/effects/rf_old_swordmaster_scenario_avatar_effect");
				local recruitEffect = ::new("scripts/skills/effects/rf_old_swordmaster_scenario_recruit_effect");
				local origin = ::World.Assets.getOrigin();
				this.Text = "%OOC%起源机制：%OOC_OFF%\n- 该起源围绕教授学徒展开。如果" + avatarEffect.m.DaysWithoutRecruitsMax + "天后，你还没能招募到" + (avatarEffect.m.NumRecruitsRequired - 1) + "名学徒，游戏就会结束。\n- 学徒会获得“剑师训练”效果，使用剑时，该效果会带来特殊的增益，并随着升级逐渐变强。\n- 拥有剑特技组的学徒在升级时有" + recruitEffect.m.FreePerkChancePerLevel + "%%几率获得一项免费的剑特技。\n- 拥有剑特技组的学徒会失去所有的其他特技组，获得剑术大师特技组，该特技组包含了一系列与剑斗相关的特殊特技，使你可以搭配出不同的特化角色和战斗风格。\n- 不能装备剑、旗帜和远程武器以外的任何武器。\n- 记得查看角色“剑师训练”和“剑师技艺”效果的提示栏，获得更多的增益（或减益）相关重要信息\n- 最多可有" + origin.m.BrothersMax + "名角色，上场" + origin.m.BrothersMaxInCombat + "名角色\n- 主角色会因每场战斗疲劳，几天后才能恢复到适合战斗的状态。还会随时间逐渐变老，承受各种减益。\n- 高天赋的学徒可以挑战定居点的剑术大师，若成功则会获得强力的增益。\n- 高度专精近战的角色背景将无法雇佣。\n- 世界毫不留情地考验着你的剑术。比起常规起源，战斗难度会提升地更快，合同也因此更为致命。\n- 在该起源游戏中，青春泉（不老泉、怪诞树）地点不会生成。\n- 营地掉落的著名武器更容易是剑。";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "最后一课";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			::World.Flags.get("HomeVillage")
		]);
	}

	function onClear()
	{
	}

});
