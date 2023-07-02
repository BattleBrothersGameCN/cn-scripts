this.port_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {},
	function isHidden()
	{
		return !this.m.Settlement.isCoastal();
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.port";
		this.m.Name = "港口";
		this.m.UIImage = "ui/settlements/building_09";
		this.m.UIImageNight = "ui/settlements/building_09_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Port";
		this.m.TooltipIcon = "ui/icons/buildings/harbor.png";
		this.m.Description = "一个为外来商船和当地渔民服务的港口";
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [
			{
				File = "ambience/buildings/docks_rope_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_rope_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_bell_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_bell_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_bell_02.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_flapping_sail_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_flapping_sail_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_ship_creaking_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_ship_creaking_02.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_ship_creaking_03.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_ship_creaking_04.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_working_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_working_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_working_02.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_working_03.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_working_04.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_seagull_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_seagull_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_seagull_02.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_seagull_03.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_seagull_04.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_seagull_05.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_small_waves_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_small_waves_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_small_waves_02.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_small_waves_03.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_small_waves_04.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/terrain/coast_small_waves_05.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			}
		];
		this.m.SoundsAtNight = [
			{
				File = "ambience/buildings/docks_rope_00.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			},
			{
				File = "ambience/buildings/docks_rope_01.wav",
				Volume = 1.000000,
				Pitch = 1.000000
			}
		];
	}

	function onClicked( _townScreen )
	{
		if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() == "contract.escort_caravan")
		{
			return;
		}

		_townScreen.getTravelDialogModule().setData(this.getUITravelRoster());
		_townScreen.showTravelDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
	}

	function getUITravelRoster()
	{
		local data = {
			Title = "港口",
			SubTitle = "一个港口，允许你乘船前往该大陆的其他地区",
			HeaderImage = null,
			Roster = []
		};
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (!s.isCoastal())
			{
				continue;
			}

			if (s.getID() == this.m.Settlement.getID())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer() || !this.m.Settlement.getOwner().isAlliedWith(s.getFaction()))
			{
				continue;
			}

			local dest = {
				ID = s.getID(),
				EntryID = data.Roster.len(),
				ListName = "航行至" + s.getName(),
				Name = s.getName(),
				Cost = this.getCostTo(s),
				ImagePath = s.getImagePath(),
				ListImagePath = s.getImagePath(),
				FactionImagePath = s.getOwner().getUIBannerSmall(),
				BackgroundText = s.getDescription() + "<br><br>" + this.getRandomDescription(s.getName())
			};
			data.Roster.push(dest);
		}

		return data;
	}

	function getRandomDescription( _destinationName )
	{
		local desc = "名叫“%shipname%”的{一艘快船 | 一艘结实的船 | 一艘科克船 | 一艘长船 | 一艘小船 | 一艘商船 | 一艘纳尔船 | 一艘当地渔船 | 一艘吱吱作响的老船}，{可以把你的战团载到%destname% | 正巧开往%destname%并可带上你的战团 | 即将启航，可以安全、快速地到达%destname% | 可以提供比走陆路更快到达%destname%的方式 | 可以收一大笔克朗将你送到%destname%}。";
		local vars = [
			[
				"shipname",
				this.Const.Strings.ShipNames[this.Math.rand(0, this.Const.Strings.ShipNames.len() - 1)]
			],
			[
				"destname",
				_destinationName
			]
		];
		return this.buildTextFromTemplate(desc, vars);
	}

	function getCostTo( _to )
	{
		local myTile = this.getSettlement().getTile();
		local dist = _to.getTile().getDistanceTo(myTile);
		local cost = dist * this.World.getPlayerRoster().getSize() * 0.500000;
		cost = this.Math.round(cost * 0.100000);
		cost = cost * 10.000000;
		return cost;
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
	}

});
