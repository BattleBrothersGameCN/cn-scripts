::Reforged.HooksMod.hook("scripts/contracts/contract", function ( q )
{
	q.RF_autoNegotiate <- {
		function RF_autoNegotiate( _numAttempts = 1 )
		{
			if (!this.isStarted())
			{
				this.start();
			}

			if (this.m.ActiveScreen.ID == "Negotiation.Fail" || this.m.Payment.IsFinal)
			{
				return;
			}

			if (this.m.ActiveScreen.ID != "Negotiation")
			{
				foreach( s in this.m.Screens )
				{
					if (s.ID == "Negotiation")
					{
						this.setScreen("Negotiation");
						break;
					}
				}

				if (this.m.ActiveScreen.ID != "Negotiation")
				{
					return;
				}
			}

			for( local i = 0; i < _numAttempts; i++ )
			{
				this.setScreen(this.getScreen(this.m.ActiveScreen.Options[1].getResult()));

				if (this.m.ActiveScreen.ID == "Negotiation.Fail")
				{
					return;
				}

				if (this.m.Payment.IsFinal)
				{
					break;
				}
			}
		}

	}.RF_autoNegotiate;
	q.RF_fakeStart <- {
		function RF_fakeStart()
		{
			if (this.isStarted())
			{
				return;
			}

			if (::MSU.isNull(this.getHome()))
			{
				local settlements = ::World.FactionManager.getFaction(this.getFaction()).getSettlements();

				if (settlements.len() == 1)
				{
					this.setHome(settlements[0]);
				}
			}

			if (!::MSU.isNull(this.getHome()))
			{
				local original_LastEnteredTown = ::World.State.m.LastEnteredTown;
				::World.State.m.LastEnteredTown = ::MSU.asWeakTableRef(this.getHome());
				local contractManager = ::World.Contracts.get();
				local original_updateActiveContract = contractManager.updateActiveContract;
				contractManager.updateActiveContract = function ()
				{
					return null;
				};
				this.start();
				contractManager.updateActiveContract = original_updateActiveContract;
				::World.State.m.LastEnteredTown = original_LastEnteredTown;
			}
		}

	}.RF_fakeStart;
	q.RF_getDescription <- {
		function RF_getDescription()
		{
			local ret = this.RF_getOriginText();

			if (ret != "")
			{
				ret = ret + "\n\n";
			}

			return ret + this.RF_getOfferedByText();
		}

	}.RF_getDescription;
	q.RF_getOfferedByText <- {
		function RF_getOfferedByText()
		{
			local faction = ::World.FactionManager.getFaction(this.getFaction());
			local characterString = ::MSU.isNull(this.getCharacter()) ? "某人" : this.format("[%s|Tooltip+%s]", this.getCharacter().getName(), ::Reforged.Mod.Tooltips.parseTooltip([
				{
					id = 1,
					type = "title",
					text = this.getCharacter().getName()
				}
			]));
			local factionString = "";
			local homeString = "";

			if (::MSU.isNull(this.getHome()))
			{
				homeString = "某处";
			}
			else if (!::MSU.isEqual(::World.State.getCurrentTown(), this.getHome()))
			{
				homeString = "在" + ::Reforged.NestedTooltips.getNestedWorldEntityName(this.getHome());
			}

			if (::MSU.isNull(this.getHome()) || faction.getName() != this.getHome().getName())
			{
				factionString = "来自" + ::Reforged.NestedTooltips.getNestedFactionName(faction);
			}

			return ::Reforged.Mod.Tooltips.parseString(this.format("Offered by %s%s%s", characterString, factionString, homeString));
		}

	}.RF_getOfferedByText;
	q.RF_getTile <- {
		function RF_getTile( _obj )
		{
			return typeof _obj == "integer" ? ::World.State.getRegion(_obj).Center : _obj.getTile();
		}

	}.RF_getTile;
	q.RF_getOriginText <- {
		function RF_getOriginText()
		{
			local ret = "";
			local origin = ::MSU.isNull(this.getOrigin()) ? this.getHome() : this.getOrigin();

			if (!::MSU.isNull(origin))
			{
				local originRegion = typeof origin == "integer" ? ::World.State.getRegion(origin) : null;
				local destinations = this.RF_getDestinations();

				foreach( i, d in destinations )
				{
					if (i != 0)
					{
						ret = ret + "那里";
					}

					if (::MSU.isEqual(origin, d))
					{
						ret = ret + (i == 0 ? "附近" : "附近");
					}
					else if (!::MSU.isNull(d))
					{
						local destRegion = typeof d == "integer" ? ::World.State.getRegion(d) : null;

						if (destRegion != null)
						{
							ret = ret + (i == 0 ? "附近的" : "附近的");
							ret = ret + (::Const.Strings.TerrainShort[destRegion.Type] + "地区" + destRegion.Name);
						}

						ret = ret + this.format("%s about %s %s of ", destRegion != null ? "" : ::Reforged.NestedTooltips.getNestedWorldEntityName(d), ::Reforged.Text.getDaysAndHalf(this.RF_getDaysRequiredToTravel(this.RF_getTile(origin), this.RF_getTile(d)) * ::World.getTime().SecondsPerDay), ::Const.Strings.Direction8[this.RF_getTile(origin).getDirection8To(this.RF_getTile(d))]);
					}

					if (i != 0)
					{
						ret = ret + "然后";
					}
					else
					{
						if (originRegion != null)
						{
							ret = ret + (i == 0 ? "附近的" : "附近的");
							ret = ret + (::Const.Strings.TerrainShort[originRegion.Type] + "地区" + originRegion.Name);
						}
						else
						{
							ret = ret + (::MSU.isEqual(::World.State.getCurrentTown(), origin) ? "这座定居点" : ::Reforged.NestedTooltips.getNestedWorldEntityName(origin));
						}

						if (!::MSU.isNull(this.getHome()) && !::MSU.isEqual(origin, this.getHome()))
						{
							ret = ret + this.format(" about %s %s of ", ::Reforged.Text.getDaysAndHalf(this.RF_getDaysRequiredToTravel(this.RF_getTile(origin), this.getHome().getTile()) * ::World.getTime().SecondsPerDay), ::Const.Strings.Direction8[this.getHome().getTile().getDirection8To(this.RF_getTile(origin))]);
							ret = ret + (::MSU.isEqual(::World.State.getCurrentTown(), this.getHome()) ? "这座定居点" : ::Reforged.NestedTooltips.getNestedWorldEntityName(this.getHome()));
						}
					}

					origin = d;
				}
			}

			return ::Reforged.Mod.Tooltips.parseString(ret);
		}

	}.RF_getOriginText;
	q.RF_getDestinations <- {
		function RF_getDestinations()
		{
			return ::MSU.isIn("Destination", this.m, true) && !::MSU.isNull(this.m.Destination) ? [
				this.m.Destination
			] : [
				this.getOrigin()
			];
		}

	}.RF_getDestinations;
	q.RF_getDaysRequiredToTravel <- {
		function RF_getDaysRequiredToTravel( _start, _end )
		{
			return this.getDaysRequiredToTravel(_start.getDistanceTo(_end), ::Const.World.MovementSettings.Speed, false);
		}

	}.RF_getDaysRequiredToTravel;
	q.RF_getTooltip <- {
		function RF_getTooltip()
		{
			local daysRemaining = (this.m.TimeOut - ::Time.getVirtualTimeF()) / ::World.getTime().SecondsPerDay;
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = this.RF_getDescription()
				},
				{
					id = 3,
					type = "hint",
					icon = "ui/icons/action_points.png",
					text = daysRemaining < 0 ? "来不及接到了" : "合同会保留" + ::Reforged.Text.getDaysRemainingText(daysRemaining)
				},
				{
					id = 100,
					type = "rf_image",
					image = ::String.replace(this.getUIDifficultySmall(), "difficulty", "rf_difficulty") + "_tooltip.png",
					cssClass = "rf-contract-difficulty-tooltip"
				}
			];

			if (this.m.IsStarted || this.isNegotiated())
			{
				local payment = this.getPayment();
				local advance = payment.getInAdvance();
				local completion = payment.getOnCompletion();
				local perCount = payment.getPerCount();
				local strs = [];

				if (advance != 0)
				{
					strs.push(advance + "克朗提前预付");
				}

				if (completion != 0)
				{
					strs.push(completion + "克朗事成后付");
				}

				if (perCount != 0)
				{
					strs.push(perCount + "克朗按人头付");
				}

				if (strs.len() != 0)
				{
					local str = this.format("%s %s", this.isNegotiated() ? "You negotiated this contract for" : "Offering", strs[0]);

					for( local i = 1; i < strs.len(); i++ )
					{
						if (i != strs.len() - 1)
						{
							str = str + ", ";
						}
						else
						{
							str = str + "\n另外";
						}

						str = str + ::String.replace(strs[i], "crowns ", "");
					}

					ret.push({
						id = 4,
						type = "hint",
						icon = "ui/icons/asset_money.png",
						text = str
					});
				}
			}

			if (this.m.SituationID != 0)
			{
				local hasAgent = ::World.Retinue.hasFollower("follower.agent");
				local situations = [];

				foreach( settlement in ::World.EntityManager.getSettlements() )
				{
					if (hasAgent)
					{
						situations.extend(settlement.getSituations());
					}
					else if (::MSU.isEqual(::World.State.getCurrentTown(), settlement))
					{
						situations.extend(settlement.getSituations());
					}
					else
					{
						situations.extend(settlement.m.RF_LastVisitSituations);
					}
				}

				foreach( s in situations )
				{
					if (s.getInstanceID() == this.m.SituationID)
					{
						ret.push({
							id = 100,
							type = "hint",
							icon = s.getIcon(),
							text = ::Reforged.Mod.Tooltips.parseString(::Reforged.NestedTooltips.getNestedObjectName(s, "contentType:settlement-status-effect"))
						});
						break;
					}
				}
			}

			return ret;
		}

	}.RF_getTooltip;
	q.RF_getTooltipIcon <- {
		function RF_getTooltipIcon()
		{
			return this.isNegotiated() ? "ui/icons/rf_contract_scroll_negotiated.png" : "ui/icons/contract_scroll.png";
		}

	}.RF_getTooltipIcon;
	q.getSecondsRequiredToTravel <- {
		function getSecondsRequiredToTravel( _numTiles, _speed, _onRoadOnly = false )
		{
			_speed = _speed * ::Const.World.MovementSettings.GlobalMult;

			if (_onRoadOnly)
			{
				_speed = _speed * ::Const.World.MovementSettings.RoadMult;
			}

			return _numTiles * 170.0 / _speed;
		}

	}.getSecondsRequiredToTravel;
	q.RF_getUICharacterTooltipID <- {
		function RF_getUICharacterTooltipID( _index = 0 )
		{
			local image = this.getUICharacterImage(_index);

			if (image == null)
			{
				return null;
			}

			local imagePath = image.Image;

			if (("Destination" in this.m) && !::MSU.isNull(this.m.Destination) && this.m.Destination.getImagePath() == imagePath)
			{
				return "WorldEntity+" + this.m.Destination.getID();
			}

			if (("Characters" in this.m.ActiveScreen) && this.m.ActiveScreen.Characters.len() > _index)
			{
				foreach( k, v in this.m )
				{
					if (::MSU.isKindOf(v, "actor") && imagePath.find("," + v.getID() + ",") != null)
					{
						return "EventActor+" + v.getID();
					}
				}
			}

			if (("Banner" in this.m.ActiveScreen) && imagePath == this.m.ActiveScreen.Banner)
			{
				foreach( f in ::World.FactionManager.getFactions() )
				{
					if (f != null && (imagePath == f.getUIBanner() || imagePath == f.getUIBannerSmall()))
					{
						return "Faction+" + f.getID();
					}
				}
			}

			if (("ShowEmployer" in this.m.ActiveScreen) && this.m.ActiveScreen.ShowEmployer)
			{
				if (_index == 0)
				{
					return "EventActor+" + this.m.EmployerID;
				}
				else if (::World.FactionManager.getFaction(this.m.Faction).getType() == ::Const.FactionType.NobleHouse)
				{
					return "Faction+" + ::World.FactionManager.getFaction(this.getFaction()).getID();
				}
				else
				{
					return null;
				}
			}
		}

	}.RF_getUICharacterTooltipID;
	q.getUICharacterImage = function ( __original )
	{
		return {
			function getUICharacterImage( _index = 0 )
			{
				if ((!("Characters" in this.m.ActiveScreen) || !this.m.ActiveScreen.Characters.len()) && (!("Banner" in this.m.ActiveScreen) || _index == 0) && ("ShowEmployer" in this.m.ActiveScreen) && this.m.ActiveScreen.ShowEmployer && _index != 0 && ("Destination" in this.m) && this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isLocation() && this.m.Destination.isLocationType(::Const.World.LocationType.Settlement) && this.m.Destination.isDiscovered())
				{
					return {
						Image = this.m.Destination.getImagePath(),
						IsProcedural = false
					};
				}
				else
				{
					return __original(_index);
				}
			}

		}.getUICharacterImage;
	};
	q.addUnitsToEntity = function ( __original )
	{
		return {
			function addUnitsToEntity( _entity, _partyList, _resources )
			{
				::Const.World.Common.RF_addSpawnlistInfo(_entity, _partyList);
				__original(_entity, _partyList, _resources);
			}

		}.addUnitsToEntity;
	};
	q.setScreen = function ( __original )
	{
		return {
			function setScreen( _screen, _restartIfAlreadyActive = true )
			{
				::Reforged.NestedTooltips.setApplyNestingForEvents(true);
				__original(_screen, _restartIfAlreadyActive);
				::Reforged.NestedTooltips.setApplyNestingForEvents(false);
			}

		}.setScreen;
	};
	q.buildText = function ( __original )
	{
		return {
			function buildText( _text )
			{
				::Reforged.NestedTooltips.setApplyNestingForEvents(true);
				local ret = __original(_text);
				::Reforged.NestedTooltips.setApplyNestingForEvents(false);
				return ret;
			}

		}.buildText;
	};
});
::Reforged.HooksMod.hookTree("scripts/contracts/contract", function ( q )
{
	q.onPrepareVariables = function ( __original )
	{
		return {
			function onPrepareVariables( _vars )
			{
				::Reforged.NestedTooltips.setApplyNestingForEvents(true);
				__original(_vars);
				::Reforged.NestedTooltips.setApplyNestingForEvents(false);
			}

		}.onPrepareVariables;
	};
});
