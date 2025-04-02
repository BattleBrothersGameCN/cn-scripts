this.main_menu_screen <- {
	m = {
		JSHandle = null,
		MainMenuModule = null,
		LoadCampaignModule = null,
		NewCampaignModule = null,
		ScenarioMenuModule = null,
		OptionsMenuModule = null,
		CreditsModule = null,
		Visible = null,
		OnConnectedListener = null,
		OnDisconnectedListener = null,
		OnScreenShownListener = null,
		OnScreenHiddenListener = null
	},
	function isVisible()
	{
		return this.m.Visible != null && this.m.Visible == true;
	}

	function isAnimating()
	{
		return this.m.MainMenuModule.isAnimating() || this.m.ScenarioMenuModule.isAnimating() || this.m.OptionsMenuModule.isAnimating() || this.m.LoadCampaignModule.isAnimating() || this.m.CreditsModule.isAnimating();
	}

	function isMainMenuVisible()
	{
		return this.m.MainMenuModule.isVisible();
	}

	function isLoadCampaignMenuVisible()
	{
		return this.m.LoadCampaignModule.isVisible();
	}

	function isScenarioMenuVisible()
	{
		return this.m.ScenarioMenuModule.isVisible();
	}

	function isOptionsMenuVisible()
	{
		return this.m.OptionsMenuModule.isVisible();
	}

	function getMainMenuModule()
	{
		return this.m.MainMenuModule;
	}

	function getLoadCampaignMenuModule()
	{
		return this.m.LoadCampaignModule;
	}

	function getNewCampaignMenuModule()
	{
		return this.m.NewCampaignModule;
	}

	function getScenarioMenuModule()
	{
		return this.m.ScenarioMenuModule;
	}

	function getOptionsMenuModule()
	{
		return this.m.OptionsMenuModule;
	}

	function getCreditsModule()
	{
		return this.m.CreditsModule;
	}

	function setOnConnectedListener( _listener )
	{
		this.m.OnConnectedListener = _listener;
	}

	function setOnDisconnectedListener( _listener )
	{
		this.m.OnDisconnectedListener = _listener;
	}

	function setOnScreenShownListener( _listener )
	{
		this.m.OnScreenShownListener = _listener;
	}

	function setOnScreenHiddenListener( _listener )
	{
		this.m.OnScreenHiddenListener = _listener;
	}

	function clearEventListener()
	{
		this.m.OnConnectedListener = null;
		this.m.OnDisconnectedListener = null;
		this.m.OnScreenShownListener = null;
		this.m.OnScreenHiddenListener = null;
	}

	function create()
	{
		this.m.Visible = false;
		this.m.MainMenuModule = this.new("scripts/ui/screens/menu/modules/main_menu_module");
		this.m.LoadCampaignModule = this.new("scripts/ui/screens/menu/modules/load_campaign_menu_module");
		this.m.NewCampaignModule = this.new("scripts/ui/screens/menu/modules/new_campaign_menu_module");
		this.m.ScenarioMenuModule = this.new("scripts/ui/screens/menu/modules/scenario_menu_module");
		this.m.OptionsMenuModule = this.new("scripts/ui/screens/menu/modules/options_menu_module");
		this.m.CreditsModule = this.new("scripts/ui/screens/menu/modules/credits_module");
	}

	function connect()
	{
		local prefix = function ( context )
		{
			local dlc = [
				{
					Image = "ui/images/undiscovered_opponent.png",
					Tooltip = "Battle-Brothers-CN",
					URL = "https://github.com/shabbywu/Battle-Brothers-CN",
					i = null
				}
			];

			for( local i = 0; i < 32; i = ++i )
			{
				if (this.Const.DLC.Info[i] != null && this.Const.DLC.Info[i].Announce == true)
				{
					local hasDLC = (this.Const.DLC.Mask & 1 << i) != 0;
					dlc.push({
						Image = hasDLC ? this.Const.DLC.Info[i].Icon : this.Const.DLC.Info[i].IconDisabled,
						Tooltip = "dlc_" + i,
						URL = this.Const.DLC.Info[i].URL,
						i = i
					});
					this.Const.DLC.Info[i].Announce = false;
				}
			}

			context.dlc <- dlc;
			return true;
		};
		local origin = function ()
		{
			this.m.JSHandle = this.UI.connect("MainMenuScreen", this);
			this.m.MainMenuModule.connectUI(this.m.JSHandle);
			this.m.LoadCampaignModule.connectUI(this.m.JSHandle);
			this.m.NewCampaignModule.connectUI(this.m.JSHandle);
			this.m.ScenarioMenuModule.connectUI(this.m.JSHandle);
			this.m.OptionsMenuModule.connectUI(this.m.JSHandle);
			this.m.CreditsModule.connectUI(this.m.JSHandle);
			this.m.JSHandle.asyncCall("setVersion", this.GameInfo.getVersionNumber() + " " + this.GameInfo.getVersionName());
			local dlc = [];

			for( local i = 0; i < 32; i = ++i )
			{
				if (this.Const.DLC.Info[i] != null && this.Const.DLC.Info[i].Announce == true)
				{
					local hasDLC = (this.Const.DLC.Mask & 1 << i) != 0;
					dlc.push({
						Image = hasDLC ? this.Const.DLC.Info[i].Icon : this.Const.DLC.Info[i].IconDisabled,
						Tooltip = "dlc_" + i,
						URL = this.Const.DLC.Info[i].URL
					});
				}
			}

			this.m.JSHandle.asyncCall("setDLC", dlc);
			this.m.JSHandle.asyncCall("setMOTD", "战场兄弟是一个具有挑战性的游戏。失败和重来是游戏的一部分。\n\n建议你从“初学者”难度和教程开始！");

			if (this.isSteamBuild())
			{
				this.m.JSHandle.asyncCall("addCrossMarketing", null);
			}
		};
		local suffix = function ( context )
		{
			foreach( dlc in context.dlc )
			{
				if (dlc.i != null)
				{
					this.Const.DLC.Info[dlc.i].Announce = true;
				}
			}

			this.m.JSHandle.asyncCall("setDLC", context.dlc);
			local ConsoleScreen = this.UI.connect("ConsoleScreen", this);
			ConsoleScreen.asyncCall("switchExecutionEnviroment", 0);
			local script = "var idx = setInterval(function() {\n        var container = $(\'.dlc-container\');\n        container.width(\'50rem\');\n        var image = container.find(\'.dlc-image\')[0];\n        if (image != undefined) {\n            image.src = \'data:image/jpeg;base64, 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\';\n            clearInterval(idx);\n        }\n    }, 200);";
			ConsoleScreen.asyncCall("executeCommand", script);
			this.UI.disconnect(ConsoleScreen);
		};
		local params = {};
		local context = {
			result = null,
			params = params,
			origin = origin
		};

		if (!prefix.call(this, context))
		{
			return context.result;
		}

		context.result = context.origin.acall([
			this
		]);
		suffix.call(this, context);
		return context.result;
	}

	function destroy()
	{
		this.clearEventListener();
		this.m.MainMenuModule.destroy();
		this.m.MainMenuModule = null;
		this.m.LoadCampaignModule.destroy();
		this.m.LoadCampaignModule = null;
		this.m.NewCampaignModule.destroy();
		this.m.NewCampaignModule = null;
		this.m.ScenarioMenuModule.destroy();
		this.m.ScenarioMenuModule = null;
		this.m.OptionsMenuModule.destroy();
		this.m.OptionsMenuModule = null;
		this.m.CreditsModule.destroy();
		this.m.CreditsModule = null;
		this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
	}

	function show( _animate )
	{
		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("show", _animate);
		}
	}

	function hide()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hide", null);
		}
	}

	function showLoadCampaignMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("showLoadCampaignMenu", this.UIDataHelper.convertCampaignStoragesToUIData());
		}
	}

	function hideLoadCampaignMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hideLoadCampaignMenu", null);
		}
	}

	function showNewCampaignMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("showNewCampaignMenu", null);
		}
	}

	function hideNewCampaignMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hideNewCampaignMenu", null);
		}
	}

	function showScenarioMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("showScenarioMenu", this.m.ScenarioMenuModule.onQueryData());
		}
	}

	function hideScenarioMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hideScenarioMenu", null);
		}
	}

	function showOptionsMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("showOptionsMenu", this.m.OptionsMenuModule.onQueryData());
		}
	}

	function hideOptionsMenu()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hideOptionsMenu", null);
		}
	}

	function showCredits()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("showCredits", this.Const.Credits);
		}
	}

	function hideCredits()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hideCredits", null);
		}
	}

	function setScenarioDemoModus()
	{
		if (this.m.JSHandle != null)
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("setScenarioDemoModus", null);
		}
	}

	function onScreenConnected()
	{
		if (this.m.OnConnectedListener != null)
		{
			this.m.OnConnectedListener();
		}
	}

	function onScreenDisconnected()
	{
		if (this.m.OnDisconnectedListener != null)
		{
			this.m.OnDisconnectedListener();
		}
	}

	function onScreenShown()
	{
		this.m.Visible = true;

		if (this.m.OnScreenShownListener != null)
		{
			this.m.OnScreenShownListener();
		}
	}

	function onScreenHidden()
	{
		this.m.Visible = false;

		if (this.m.OnScreenHiddenListener != null)
		{
			this.m.OnScreenHiddenListener();
		}
	}

};
