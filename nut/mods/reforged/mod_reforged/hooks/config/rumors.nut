::Const.Strings.LegendaryLocationAdjective <- [
	"叹为观止",
	"神秘至极",
	"震撼人心",
	"闻所未闻",
	"引人入胜",
	"如梦似幻"
];
::Const.Strings.RumorsUniqueLocation <- [
	[
		"{我总是听说 | 一些旅行者提到过 | 一些朝圣者提到过}一个%legendaryLocationAdjective%的{地方 | 地界}，{就在这儿的%direction% | 在这儿%distance%的%terrain% }。"
	],
	[
		"{一名探险者 | 一名制图师}最近来过这儿，说他找到了{一个 | 某个}%legendaryLocationAdjective%{的地方 | 的地儿}，离这儿%distance%，{他把那儿 | } {叫做 | 称为}%location%。他要是愿意多透露点什么就好了……",
		"有一天，{有个从%randomtown%来的人 | %randomname%}跟我说起了%location%的事。他说那就在这儿{%direction% | %wrongDirection% | %wrongDirection%}边。{但他喝得醉醺醺的，我可不信他的话 | 但我记错了也说不定}。",
		"有这么一个{坊间 | 古老的}{寓言 | 传说 | 故事}，说的是一处叫%location%{的地方 | 的地儿}。{有人 | 某些人}{说 | 坚称}它就在{离这儿%distance%的%terrain%，另一些人却说是在%wrongDistance%的%wrongTerrain% | 离这儿%wrongDistance%的%wrongTerrain%， 另一些却说是在%distance%的%terrain%}。",
		"就在{前天 | 昨天 | 今天早上}一个醉醺醺的家伙{找我来吹牛 | 找到了我}，说他在一次冒险当中，{发现了 | 找到了 | 撞见了}{一个 | 某个}叫%location%的{地方 | 地儿}。一开始他说在{%direction%边，后来他又说不对不对，是在%wrongDirection%边 | %wrongDirection%边，后来他又说不对不对，是在%direction%边}。最后他{打定了主意 | 直接赌起了咒}，说那地方肯定是在{%direction% | %wrongDirection%}方。",
		"{Some | %randomname%s} kid told me {this | a} story {the other day | yesterday | this morning}. It was about {a | some} {place | location} {he calls | called} %location%. He told me it\'s supposed to be {%distance% | %wrongDistance%} to the {%direction% | %wrongDirection%} from here, {%terrain% | %wrongTerrain%}. You {know, I think that story is | believe any of this? Me neither, it\'s} a load of {horse | horse | horse | horse | unhold} shit."
	]
];
