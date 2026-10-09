this.rf_banshee_potion_item <- ::inherit("scripts/items/misc/anatomist/rf_anatomist_potion_item", {
	m = {},
	function create()
	{
		this.rf_anatomist_potion_item.create();
		this.m.ID = "misc.rf_banshee_potion";
		this.m.Name = "宁静药剂";
		local entityName = ::Const.Strings.EntityName[::Const.EntityType.RF_Banshee];
		entityName = ::Const.Strings.getArticle(entityName) + entityName;
		this.m.Description = "从" + entityName + "的灵体残秽中提炼出的一种稀薄、闪亮的精馏液。这种液体轻得出奇，拿在手中几乎感受不到重量，还有一股尖锐刺鼻的气味。临床试验表明，该药剂能稳定受试者的体液，使其性情处于恒定的亢奋状态。这不仅能让饮用者抵御恐惧与悲痛的侵蚀，还更容易被灵感激发变得自信。受试者报告称，服用后的几天内，耳中会持续出现一股若有若无的嗡鸣声，这种感觉会随时间消退，但从未彻底消失。";
		this.m.Icon = "consumables/rf_banshee_potion_item.png";
	}

});
