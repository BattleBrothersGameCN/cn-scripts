for( local index = ::Const.TipOfTheDay.len() - 1; index >= 0; index-- )
{
	switch(::Const.TipOfTheDay[index])
	{
	case "As brothers we fight, as brothers we die!":
	case "Learn the \'Rotation\' or \'Footwork\' perks for additional mobility in battle.":
	case "A life can be worth little in this world.":
	case "Try the Ironman mode to experience Battle Brothers the way it\'s meant to be played.":
	case "Dying is part of a mercenary\'s job description.":
	case "Try playing a campaign in veteran mode once you\'ve gained some experience - it\'s the recommended difficulty.":
	case "Do the job. Survive. Get paid.":
	case "The \'Lone Wolf\' perk is not affected by nearby dogs or allies that are not part of your company.":
	case "The \'Fast Adaptation\' perk reduces variance of randomness.":
	case "Losing is fun.":
	case "Some people will use you and throw you away.":
	case "With the \'Beast Slayers\' origin you\'ll have an easier time tracking beasts and get more trophies from any of those you slay.":
	case "With the \'Lone Wolf\' origin you\'ll have a player character in the world. If you die, the campaign ends.":
	case "With the \'Peasant Militia\' origin you can take up to 16 men into battle at once.":
	case "With the \'Cultists\' origin your god will demand sacrifices from you, but also bestow boons upon those loyal to him.":
	case "With the \'Band of Poachers\' origin you\'ll move faster on the worldmap.":
	case "With the \'Trading Caravan\' origin you\'ll get better prices for both buying and selling.":
	case "With the \'Manhunters\' origin you can make prisoners after every battle against humans and force them to fight for you.":
	case "With the \'Gladiators\' origin you start with three powerful characters, but losing all three will end your campaign.":
	case "With the \'Anatomists\' origin, defeating new enemies grants potions that mutate your men and grant them special abilities.":
	case "With the \'Oathtakers\' origin, instead of ambitions you\'ll pick oaths that grant special boons and burdens.":
	case "Consider putting injured characters in reserve until their wounds have healed.":
	case "Consider building up a reserve roster and rotating your men, so you can more easily deal with losses down the road.":
	case "Having men of different backgrounds in your company may enable you to perform different actions in events.":
	case "You don\'t have to be a hero, you\'re running a business.":
	case "Drag and drop your men in the inventory screen to where you want them to be in your formation.":
	case "Consider forming a shieldwall when surrounded.":
	case "Conserve your stamina when in prolonged engagements.":
	case "Success in Battle Brothers is also about picking the right fights.":
	case "Undead are unaffected by fatigue and morale.":
	case "Crossbows require less skill to fire accurately than bows, but are slower to use.":
	case "Each type of weapon has advantages and disadvantages.":
	case "Clubs and maces can stun or incapacitate targets.":
	case "Try to save some crowns for when things turn sour.":
	case "Longswords and Greatswords can hit multiple targets with one strike.":
	case "Spears are good defensive weapons due to their Spearwall ability.":
	case "Use terrain and chokepoints to your advantage.":
	case "The higher their level, the more your men will demand in wages.":
	case "Skeletons are highly resistant to ranged attacks and fire.":
	case "Heavy armor offers great protection, but also slows down the wearer and makes him tire more quickly.":
	case "Heavy helmets can be hard to breathe in and limit the field of vision.":
	case "Warhammers and Military Picks can make short work of heavy armor.":
	case "The Billhook, Pike and Longaxe can attack over 2 tiles, unlike most other melee weapons.":
	case "A human is no match for an adult orc physically.":
	case "Orcs rely on raw power and physical prowess.":
	case "A goblin is no match for an adult human physically, so they rely on wit and dirty tricks.":
	case "Geists are lost between the physical world and the world beyond, constantly shifting between the two.":
	case "Two-handed axes can hit up to 6 targets with a single round swing.":
	case "Roads are the fastest way to travel over land, but not always the safest.":
	case "Forests can hide many dangers within.":
	case "Always keep a good stock of provisions - lest your men starve and desert you!":
	case "Wiedergangers are the dead walking again.":
	case "Difficult terrain, such as mountains and swamp, has your men use more supplies on the worldmap.":
	case "If you can not win, retreat to fight another day.":
	case "Try to negotiate better payment for your contracts.":
	case "Try to negotiate payment modalities that guarantee you the most money for contracts.":
	case "Throwing weapons can be deadly on short distances, but their accuracy drops sharply the farther away the target.":
	case "You can find contract offers in the top left of settlement screens.":
	case "Cleavers can inflict bleeding wounds.":
	case "Stunned characters get no attack of opportunity when someone moves inside their zone of control.":
	case "The minimum hit chance for any attack is 5%, and the maximum hit chance for any attack is 95%.":
	case "The natural habitat of direwolves is the forest.":
	case "You can enable faster AI turns in the options menu.":
		::Const.TipOfTheDay.remove(index);
		break;

	case "Flails ignore the defense bonus of shields.":
		::Const.TipOfTheDay[index] = "重铸：和链枷类似，流星锤也能无视盾牌的防御加成，“盾墙”除外。";
		break;
	}
}

::Const.TipOfTheDay.extend([
	"非玩家控制角色永远不会用光弓、弩和火铳的弹药。",
	"重铸：护送商队任务当中，你可以在两格距离上而非临近时才能进入城镇。",
	"模组选项当中有很多可以改善游戏体验的自定义内容。",
	"身边的敌人会提高士气检定难度，盟友则会降低检定难度。",
	"点击活跃的合同会把你聚焦到地图上的任务目标，未知位置除外。",
	"重铸：酒馆流言不会提到已经发现过的传说地点。",
	"重铸：只有你的阵营造成的伤害达一半以上时，才能获得敌人掉落的战利品。",
	"重铸：杀敌经验按照造成伤害的份额分配。",
	"重铸：你可以在模组选项中定制你角色和敌人的提示栏。",
	"重铸：亡灵会受到某些特定的创伤，但要对它们造成创伤则相对困难。",
	"重铸：游玩常规起源时，执誓者兄弟会定期宣誓新的誓言。",
	"如果你看到彩色色块，请不要保存游戏，否则可能导致存档损坏。",
	"重铸：你的角色装备的武器就算损坏了也会掉落，你可以在战后修复它们。"
]);
