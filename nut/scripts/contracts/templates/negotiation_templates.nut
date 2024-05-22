local gt = this.getroottable();

if (!("Contracts" in gt.Const))
{
	gt.Const.Contracts <- {};
}

gt.Const.Contracts.Overview <- [
	{
		ID = "Overview",
		Title = "Overview",
		Text = "你们协商的合同如下。你同意这些条款吗？",
		Image = "",
		List = [],
		Options = [
			{
				Text = "我接受这份合同。",
				function getResult()
				{
					this.Contract.setState("Running");
					return 0;
				}

			},
			{
				Text = "我需要一些时间来考虑考虑。",
				function getResult()
				{
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			},
			{
				Text = "经过再三考虑，我拒绝这份合同。",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			}
		],
		ShowObjectives = true,
		ShowPayment = true,
		ShowEmployer = true,
		ShowDifficulty = true,
		function start()
		{
			this.Contract.m.IsNegotiated = true;
		}

	}
];
gt.Const.Contracts.NegotiationDefault <- [
	{
		ID = "Negotiation",
		Title = "谈判",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "我接受你的提议。",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getInAdvance() + "克朗作为预付");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getOnCompletion() + "克朗会在事成之后付清");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "我们需要更多的报酬。",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "我们需要预付款。" : "我们需要更多的预付款。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;
							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
							this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "我们需要在工作完成后马上拿到报酬。" : "我们需要在工作完成后拿到更多的报酬。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;
							this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "算了吧，这可不值得。",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{他点了点头。%SPEECH_ON%好，当然。我早就在想这活儿的报酬了。 | 他直起身子。%SPEECH_ON%那么，至于报酬。 | 他笑着说道。%SPEECH_ON%干完这票你就是个大款了我的朋友。 | 他深吸了一口气。%SPEECH_ON%很好，这是我打算给你的。 | 他把手搭在你肩膀上，笑着重新说道。%SPEECH_ON%我想我知道怎样才算对得起你的服务。 | 他用手比划着，在手指上点来点去，算着什么，但你看不懂。%SPEECH_ON%从经验来看，合理的报酬会是。 | 他点了点头。%SPEECH_ON%你看起来挺有本事，我愿意多给你点。 | 他晃着一袋子钱币。%SPEECH_ON%搞定这件事，它就是你的了。 | 他摊开手掌。%SPEECH_ON%我最近手头很紧，多说无益，我只有这么多。 | %SPEECH_ON%放心吧，对你要做的事情来说，我给的相当不错。}";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%我拒绝付更多报酬。 | %SPEECH_START%讲点道理。 | %SPEECH_START%不，不行，绝对不行。 | %SPEECH_START%你当你是谁？报酬是我定的。 | 他只是严肃地看着你，摇了摇头。%SPEECH_ON% | %SPEECH_START%没门！%SPEECH_OFF%他愤怒地大吼。%SPEECH_ON% | %SPEECH_START%不行，我已经多给着你了。 | %SPEECH_START%不行。别把我逼急了！ | %SPEECH_START%我觉得你还不太明白。如果你想得到报酬，那我们就需要达成一致。我的报价还是那样。}";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%那就这样? | 他深吸了一口气。%SPEECH_ON% | 他叹了口气。%SPEECH_ON% | %SPEECH_START%行吧。 | %SPEECH_START%好吧，好吧。 | %SPEECH_START%非要这样的话。 | %SPEECH_START%行吧，那这样呢？ | %SPEECH_START%好吧，当然，我理解。 | %SPEECH_START%还算合理。 | %SPEECH_START%有趣。我觉得那这样比较合适。 | %SPEECH_START%那这样如何？ | %SPEECH_START%我的报价如下。 | %SPEECH_ON%可以。那这样你接受吗？ | %SPEECH_START%好吧。鉴于你的要求，这是我新的报价。 | %SPEECH_START%快点敲定吧。这是我的新报价。 | %SPEECH_START%我们朋友一场，对吧？让我们看看……}";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0)
			{
				this.Text += "合同完成后{你会得到 | 你会收到 | 我会给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你}共 %reward_advance% 克朗的预付款。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你} %reward_advance% 克朗的预付款，并且当你完成后再付 %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else
			{
				this.Text += "那你什么也得不到。你真这么想吗？%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%别以为只有你们在出卖武力。我要另找别人了，祝你好运。%SPEECH_OFF% | %SPEECH_START%我的耐心也是有限的，看来我的时间白费了。%SPEECH_OFF% | %SPEECH_START%我受够了！我决定找到其他人来做这项工作！%SPEECH_OFF% | %SPEECH_START%别侮辱我的智商！这份合同跟你没关系了。咱们到此为止。%SPEECH_OFF% | 他的脸气得通红。%SPEECH_ON%滚出去，我不贪鬼打交道！%SPEECH_OFF% | 他叹了口气。%SPEECH_ON%就……算了吧。我一开始就不该相信你。你走吧，我好去找其他更明事理的人。%SPEECH_OFF% | %SPEECH_START%我当真还以为咱俩关系还不错。但这已经超出我的极限了。我觉得这不行，告辞。%SPEECH_OFF% | %SPEECH_ON%这完全是浪费时间。想不明白就别再来找我了。%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "我们不会为了这么微薄的报酬而冒生命危险……",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "合同谈崩了");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
gt.Const.Contracts.NegotiationPerHead <- [
	{
		ID = "Negotiation",
		Title = "谈判",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "我接受你的提议。",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getInAdvance() + "克朗作为预付");
					}

					if (this.Contract.m.Payment.Count != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getPerCount() + "克朗乘带回来的人头数，最多计" + this.Contract.m.Payment.MaxCount + "个头");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getOnCompletion() + "克朗会在事成之后付清");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "我们需要更多的报酬。",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Count < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Count == 0 ? "我们需要按拿回的人头支付报酬。" : "我们需要你为每个带回的人头付更多的钱。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
							}
							else if (this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Count = this.Math.minf(1.0, this.Contract.m.Payment.Count + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "我们需要预付款。" : "我们需要更多的预付款。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "我们需要在工作完成后马上拿到报酬。" : "我们需要在工作完成后拿到更多的报酬。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Advance > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}

							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "算了吧，这可不值得。",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{他点了点头。%SPEECH_ON%好，当然。我早就在想这活儿的报酬了。 | 他笑着说道。%SPEECH_ON%干完这票你就是个大款了我的朋友。 | 他深吸了一口气。%SPEECH_ON%很好，这是我打算给你的。 | 他把手搭在你肩膀上，笑着重新说道。%SPEECH_ON%我想我知道怎样才算对得起你的服务。 | 他用手比划着，在手指上点来点去，算着什么，但你看不懂。%SPEECH_ON%从经验来看，合理的报酬会是。 | 他点了点头。%SPEECH_ON%你看起来挺有本事，我愿意多给你点。 | 他晃着一袋子钱币。%SPEECH_ON%搞定这件事，它就是你的了。 | 他摊开手掌。%SPEECH_ON%我最近手头很紧，多说无益，我只有这么多。 | %SPEECH_ON%放心吧，对你要做的事情来说，我给的相当不错。}";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%我拒绝付更多报酬。 | %SPEECH_START%讲点道理。 | %SPEECH_START%不，不行，绝对不行。 | %SPEECH_START%你当你是谁？报酬是我定的。 | 他只是严肃地看着你，摇了摇头。%SPEECH_ON% | %SPEECH_START%没门！%SPEECH_OFF%他愤怒地大吼。%SPEECH_ON% | %SPEECH_START%不行，我已经多给着你了。 | %SPEECH_START%不行。别把我逼急了！ | %SPEECH_START%我觉得你还不太明白。如果你想得到报酬，那我们就需要达成一致。我的报价还是那样。}";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%那就这样? | 他深吸了一口气。%SPEECH_ON% | 他叹了口气。%SPEECH_ON% | %SPEECH_START%行吧。 | %SPEECH_START%好吧，好吧。 | %SPEECH_START%非要这样的话。 | %SPEECH_START%行吧，那这样呢？ | %SPEECH_START%好吧，当然，我理解。 | %SPEECH_START%还算合理。 | %SPEECH_START%有趣。我觉得那这样比较合适。 | %SPEECH_START%那这样如何？ | %SPEECH_START%我的报价如下。 | %SPEECH_ON%可以。那这样你接受吗？ | %SPEECH_START%好吧。鉴于你的要求，这是我新的报价。 | %SPEECH_START%快点敲定吧。这是我的新报价。 | %SPEECH_START%我们朋友一场，对吧？让我们看看……}";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "合同完成后{你会得到 | 你会收到 | 我会给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你}共 %reward_advance% 克朗的预付款。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "每带回一个人头{你会得到 | 你会收到 | 我会给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你} %reward_advance% 克朗的预付款，并且当你完成后再付 %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你}共 %reward_advance% 克朗的预付款，并且每带回一个人头{你会再得到 | 你会再收到 | 我会再给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "每带回一个人头{你会得到 | 你会收到 | 我会给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。合同完成后{你会再得到 | 你会再收到 | 我会再给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你} %reward_advance% 克朗的预付款，并且每带回一个人头{你会得到 | 你会收到 | 我会给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。合同完成后{你会再得到 | 你会再收到 | 我会再给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else
			{
				this.Text += "那你什么也得不到。你真这么想吗？%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%别以为只有你们在出卖武力。我要另找别人了，祝你好运。%SPEECH_OFF% | %SPEECH_START%我的耐心也是有限的，看来我的时间白费了。%SPEECH_OFF% | %SPEECH_START%我受够了！我决定找到其他人来做这项工作！%SPEECH_OFF% | %SPEECH_START%别侮辱我的智商！这份合同跟你没关系了。咱们到此为止。%SPEECH_OFF% | 他的脸气得通红。%SPEECH_ON%滚出去，我不贪鬼打交道！%SPEECH_OFF% | 他叹了口气。%SPEECH_ON%就……算了吧。我一开始就不该相信你。你走吧，我好去找其他更明事理的人。%SPEECH_OFF% | %SPEECH_START%我当真还以为咱俩关系还不错。但这已经超出我的极限了。我觉得这不行，告辞。%SPEECH_OFF% | %SPEECH_START%这完全是浪费时间。想不明白就别再来找我了。%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "我们不会为了这么微薄的报酬而冒生命危险……",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "合同谈崩了");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
gt.Const.Contracts.NegotiationPerHeadAtDestination <- [
	{
		ID = "Negotiation",
		Title = "谈判",
		Text = "",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [],
		function start()
		{
			this.Options = [];
			this.Options.push({
				Text = "我接受你的提议。",
				function getResult()
				{
					this.Contract.m.BulletpointsPayment = [];

					if (this.Contract.m.Payment.Advance != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getInAdvance() + "克朗作为预付");
					}

					if (this.Contract.m.Payment.Count != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getPerCount() + "克朗乘回来时的人头数，最多计" + this.Contract.m.Payment.MaxCount + "个头");
					}

					if (this.Contract.m.Payment.Completion != 0)
					{
						this.Contract.m.BulletpointsPayment.push("酬金" + this.Contract.m.Payment.getOnCompletion() + "克朗会在事成之后付清");
					}

					return "Overview";
				}

			});
			this.Options.push({
				Text = "我们需要更多的报酬。",
				function getResult()
				{
					if (!this.World.Retinue.hasFollower("follower.negotiator"))
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelationEx(-0.5);
					}

					this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

					if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
					{
						return "Negotiation.Fail";
					}

					if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
					{
						this.Contract.m.Payment.IsFinal = true;
					}
					else
					{
						this.Contract.m.Payment.IsFinal = false;
						this.Contract.m.Payment.Pool = this.Contract.m.Payment.Pool * (1.0 + this.Math.rand(3, 10) * 0.01);
					}

					return "Negotiation";
				}

			});

			if (this.Contract.m.Payment.Count < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Count == 0 ? "我们需要按照我们带回来的人头数支付报酬。" : "我们需要你为我们带来的每个人头支付更多的报酬。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
							}
							else if (this.Contract.m.Payment.Advance > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Count = this.Math.minf(1.0, this.Contract.m.Payment.Count + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Advance < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Advance == 0 ? "我们需要预付款。" : "我们需要更多的预付款。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Contract.m.Payment.Advance >= this.World.Assets.m.AdvancePaymentCap || this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Completion > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Completion = this.Math.maxf(0.0, this.Contract.m.Payment.Completion - 0.25);
							}

							this.Contract.m.Payment.Advance = this.Math.minf(1.0, this.Contract.m.Payment.Advance + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			if (this.Contract.m.Payment.Completion < 1.0)
			{
				this.Options.push({
					Text = this.Contract.m.Payment.Completion == 0 ? "我们需要在工作完成后马上拿到报酬。" : "我们需要在工作完成后拿到更多的报酬。",
					function getResult()
					{
						this.Contract.m.Payment.Annoyance += this.Math.maxf(1.0, this.Math.rand(this.Const.Contracts.Settings.NegotiationAnnoyanceGainMin, this.Const.Contracts.Settings.NegotiationAnnoyanceGainMax) * this.World.Assets.m.NegotiationAnnoyanceMult);

						if (this.Contract.m.Payment.Annoyance > this.Const.Contracts.Settings.NegotiationMaxAnnoyance)
						{
							return "Negotiation.Fail";
						}

						if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.NegotiationRefuseChance * this.Contract.m.Payment.Annoyance)
						{
							this.Contract.m.Payment.IsFinal = true;
						}
						else
						{
							this.Contract.m.Payment.IsFinal = false;

							if (this.Contract.m.Payment.Advance > 0 && this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.125);
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.125);
							}
							else if (this.Contract.m.Payment.Count > 0)
							{
								this.Contract.m.Payment.Count = this.Math.maxf(0.0, this.Contract.m.Payment.Count - 0.25);
							}
							else
							{
								this.Contract.m.Payment.Advance = this.Math.maxf(0.0, this.Contract.m.Payment.Advance - 0.25);
							}

							this.Contract.m.Payment.Completion = this.Math.minf(1.0, this.Contract.m.Payment.Completion + 0.25);
						}

						return "Negotiation";
					}

				});
			}

			this.Options.push({
				Text = "算了吧，这可不值得。",
				function getResult()
				{
					this.World.Contracts.removeContract(this.Contract);
					this.World.State.getTownScreen().updateContracts();
					return 0;
				}

			});

			if (!this.Contract.m.Payment.IsNegotiating)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{他点了点头。%SPEECH_ON%好，当然。我早就在想这活儿的报酬了。 | 他笑着说道。%SPEECH_ON%干完这票你就是个大款了我的朋友。 | 他深吸了一口气。%SPEECH_ON%很好，这是我打算给你的。 | 他把手搭在你肩膀上，笑着重新说道。%SPEECH_ON%我想我知道怎样才算对得起你的服务。 | 他用手比划着，在手指上点来点去，算着什么，但你看不懂。%SPEECH_ON%从经验来看，合理的报酬会是。 | 他点了点头。%SPEECH_ON%你看起来挺有本事，我愿意多给你点。 | 他晃着一袋子钱币。%SPEECH_ON%搞定这件事，它就是你的了。 | 他摊开手掌。%SPEECH_ON%我最近手头很紧，多说无益，我只有这么多。 | %SPEECH_ON%放心吧，对你要做的事情来说，我给的相当不错。}";
				this.Contract.m.Payment.IsNegotiating = true;
			}
			else if (this.Contract.m.Payment.IsFinal)
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%我拒绝付更多报酬。 | %SPEECH_START%讲点道理。 | %SPEECH_START%不，不行，绝对不行。 | %SPEECH_START%你当你是谁？报酬是我定的。 | 他只是严肃地看着你，摇了摇头。%SPEECH_ON% | %SPEECH_START%没门！%SPEECH_OFF%他愤怒地大吼。%SPEECH_ON% | %SPEECH_START%不行，我已经多给着你了。 | %SPEECH_START%不行。别把我逼急了！ | %SPEECH_START%我觉得你还不太明白。如果你想得到报酬，那我们就需要达成一致。我的报价还是那样。}";
			}
			else
			{
				this.Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%那就这样? | 他深吸了一口气。%SPEECH_ON% | 他叹了口气。%SPEECH_ON% | %SPEECH_START%行吧。 | %SPEECH_START%好吧，好吧。 | %SPEECH_START%非要这样的话。 | %SPEECH_START%行吧，那这样呢？ | %SPEECH_START%好吧，当然，我理解。 | %SPEECH_START%还算合理。 | %SPEECH_START%有趣。我觉得那这样比较合适。 | %SPEECH_START%那这样如何？ | %SPEECH_START%我的报价如下。 | %SPEECH_ON%可以。那这样你接受吗？ | %SPEECH_START%好吧。鉴于你的要求，这是我新的报价。 | %SPEECH_START%快点敲定吧。这是我的新报价。 | %SPEECH_START%我们朋友一场，对吧？让我们看看……}";
			}

			if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "合同完成后{你会得到 | 你会收到 | 我会给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你}共 %reward_advance% 克朗的预付款。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "每带来一个人头{你会得到 | 你会收到 | 我会给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count == 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你} %reward_advance% 克朗的预付款，并且当你完成后再付 %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion == 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你}共 %reward_advance% 克朗的预付款，每带回一个人头{你会再得到 | 你会再收到 | 我会再给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance == 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "每带来一个人头{你会得到 | 你会收到 | 我会给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }。合同完成后{你会再得到 | 你会再收到 | 我会再给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else if (this.Contract.m.Payment.Completion != 0 && this.Contract.m.Payment.Advance != 0 && this.Contract.m.Payment.Count != 0)
			{
				this.Text += "{你会得到 | 你会收到 | 我会给你}共 %reward_advance% 克朗的预付款，每带来一个人头{你会再得到 | 你会再收到 | 我会再给你} %reward_count% 克朗，{我最多收 %maxcount% 个头 | 我最多给你 %maxcount% 个头的钱 }，合同完成后{你会再得到 | 你会再收到 | 我会再给你} %reward_completion% 克朗。%SPEECH_OFF%";
			}
			else
			{
				this.Text += "那你什么也得不到。你真这么想吗？%SPEECH_OFF%";
			}
		}

	},
	{
		ID = "Negotiation.Fail",
		Title = "谈判",
		Text = "[img]gfx/ui/events/event_74.png[/img]{%SPEECH_START%别以为只有你们在出卖武力。我要另找别人了，祝你好运。%SPEECH_OFF% | %SPEECH_START%我的耐心也是有限的，看来我的时间白费了。%SPEECH_OFF% | %SPEECH_START%我受够了！我决定找到其他人来做这项工作！%SPEECH_OFF% | %SPEECH_START%别侮辱我的智商！这份合同跟你没关系了。咱们到此为止。%SPEECH_OFF% | 他的脸气得通红。%SPEECH_ON%滚出去，我不贪鬼打交道！%SPEECH_OFF% | 他叹了口气。%SPEECH_ON%就……算了吧。我一开始就不该相信你。你走吧，我好去找其他更明事理的人。%SPEECH_OFF% | %SPEECH_START%我当真还以为咱俩关系还不错。但这已经超出我的极限了。我觉得这不行，告辞。%SPEECH_OFF% | %SPEECH_START%这完全是浪费时间。想不明白就别再来找我了。%SPEECH_OFF%}",
		Image = "",
		List = [],
		ShowEmployer = true,
		ShowDifficulty = true,
		Options = [
			{
				Text = "我们不会为了这么微薄的报酬而冒生命危险……",
				function getResult()
				{
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationContractNegotiationsFail, "合同谈崩了");
					this.World.Contracts.removeContract(this.Contract);
					return 0;
				}

			}
		]
	}
];
