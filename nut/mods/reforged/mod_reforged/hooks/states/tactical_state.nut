::Reforged.HooksMod.hook("scripts/states/tactical_state", function ( q )
{
	q.m.RF_NeutralCombatTracks <- [
		"music/rf_silent_music.ogg"
	];
	q.m.__RF_IsPlayingRealCombatMusic <- false;
	q.initMap = function ( __original )
	{
		return {
			function initMap()
			{
				foreach( party in this.m.StrategicProperties.Parties )
				{
					::Reforged.Math.seedRandom("RF_FixedCombatMapSeed", party.getCombatSeed(), party.getName(), party.getFaction(), party.getTile().X * 200, party.getTile().Y);
					break;
				}

				__original();
			}

		}.initMap;
	};
	q.onShow = function ( __original )
	{
		return {
			function onShow()
			{
				__original();

				if (!this.m.__RF_IsPlayingRealCombatMusic)
				{
					foreach( p in ::Tactical.State.getStrategicProperties().Parties )
					{
						if (!p.isLocation() || p.isShowingDefenders() || p.isAlliedWithPlayer())
						{
							continue;
						}

						::Music.setTrackList(this.m.RF_NeutralCombatTracks, ::Const.Sound.CrossFadeTime);
						break;
					}
				}
			}

		}.onShow;
	};
	q.onBattleEnded = function ( __original )
	{
		return {
			function onBattleEnded()
			{
				this.m.__RF_IsPlayingRealCombatMusic = false;
				__original();
			}

		}.onBattleEnded;
	};
	q.setPause = function ( __original )
	{
		return {
			function setPause( _pause )
			{
				__original(_pause);

				if (this.m.TacticalScreen != null)
				{
					if (_pause)
					{
						local data = {
							Header = "已暂停",
							Subheader = null
						};

						if (::Reforged.Mod.Keybinds.getKeybind("Tactical_PauseAI").getKeyCombinationsCapitalized() != "")
						{
							data.Subheader = "(按" + ::Reforged.Mod.Keybinds.getKeybind("Tactical_PauseAI").getKeyCombinationsCapitalized() + "键解除暂停)";
						}

						this.m.TacticalScreen.m.JSHandle.asyncCall("RF_showMessage", data);
					}
					else
					{
						this.m.TacticalScreen.m.JSHandle.asyncCall("RF_hideMessage", null);
					}
				}
			}

		}.setPause;
	};
	q.showRetreatScreen = function ( __original )
	{
		return function ( _tag = null )
		{
			this.m.TacticalScreen.getTopbarOptionsModule().changeFleeButtonToWin();
			return __original(_tag);
		};
	};
	q.topbar_round_information_onQueryRoundInformation = function ( __original )
	{
		return {
			function topbar_round_information_onQueryRoundInformation()
			{
				local ret = __original();
				ret.RF_enemiesCountMin <- ::Tactical.Entities.getAllHostilesAsArray().filter(function ( _, _a )
				{
					return _a.isDiscovered();
				}).len();

				if (ret.RF_enemiesCountMin < ret.enemiesCount)
				{
					ret.RF_enemiesCountMax <- "??";
				}

				return ret;
			}

		}.topbar_round_information_onQueryRoundInformation;
	};
	q.RF_playActualTrackList <- function ()
	{
		if (this.m.__RF_IsPlayingRealCombatMusic)
		{
			return;
		}

		this.m.__RF_IsPlayingRealCombatMusic = true;

		if (this.m.Scenario != null)
		{
			::Music.setTrackList(this.m.Scenario.getMusic(), ::Const.Music.RF_CrossFadeTimeToRealMusic);
		}
		else if (this.m.StrategicProperties != null)
		{
			::Music.setTrackList(this.m.StrategicProperties.Music, ::Const.Music.RF_CrossFadeTimeToRealMusic);
		}
		else
		{
			::Music.setTrackList(::Const.Music.BattleTracks[this.m.Factions.getHostileFactionWithMostInstances()], ::Const.Music.RF_CrossFadeTimeToRealMusic);
		}
	};
});
