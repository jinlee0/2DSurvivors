class_name NodeGroup

const E = {
	"Player": "player", 
	"ForegroundLayer": "foreground_layer",
	"Enemy": "enemy",
	"EntitiesLayer": "entities_layer",
	"UpgradeCard": "upgrade_card"
}


static func get_player(tree: SceneTree) -> Player:
	return get_first_node_in(tree, E.Player)


static func get_foreground_layer(tree: SceneTree) -> Node:
	return get_first_node_in(tree, E.ForegroundLayer)


static func get_enemies(tree: SceneTree) -> Array[Node]:
	return get_nodes_in(tree, E.Enemy)


static func get_entities_layer(tree: SceneTree) -> Node:
	return get_first_node_in(tree, E.EntitiesLayer)


static func get_upgrade_cards(tree: SceneTree) -> Array[AbilityUpgradeCard]:
	var arr: Array[AbilityUpgradeCard] = []
	arr.append_array(get_nodes_in(tree, E.UpgradeCard))
	return arr


static func get_nodes_in(tree: SceneTree, group_name: String) -> Array[Node]:
	return tree.get_nodes_in_group(group_name)


static func get_first_node_in(tree: SceneTree, group_name: String) -> Node:
	return tree.get_first_node_in_group(group_name)

