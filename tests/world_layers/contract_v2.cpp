#include "contract_v2.hpp"
#include "world/world_validation.hpp"

#include <fstream>
#include <map>
#include <stdexcept>
#include <tuple>

namespace {
	using namespace world_layers;
	void require(bool condition, const std::string &message) {
		if (!condition) {
			throw std::runtime_error("v2: " + message);
		}
	}
	void write(const std::filesystem::path &file, const std::string &content) {
		std::ofstream stream(file, std::ios::binary | std::ios::trunc);
		stream << content;
		require(stream.good(), "write fixture");
	}
	struct Map final : MapView {
		using Key = std::tuple<int32_t, int32_t, int32_t>;
		std::map<Key, MapTile> tiles;
		std::vector<UniqueOccurrence> ids;
		std::map<Key, MapTile> baseline;
		std::map<uint64_t, uint16_t> persistedUids;
		bool nativeTeleport(uint16_t id) const override {
			return id == 1949;
		}
		bool knownItem(uint16_t id) const override {
			return id != 0 && id < 50000;
		}
		bool capability(uint16_t id, const std::string &name) const override {
			if (name == "container") {
				return id == 2435;
			}
			if (name == "door") {
				return id == 1662 || id == 1663;
			}
			return MapView::capability(id, name);
		}
		MapTile tile(const Position &p) override {
			const auto it = tiles.find({ p.x, p.y, p.z });
			return it == tiles.end() ? MapTile {} : it->second;
		}
		MapTile selectionTile(const Position &p) override {
			const auto it = baseline.find({ p.x, p.y, p.z });
			return it == baseline.end() ? tile(p) : it->second;
		}
		uint16_t effectiveUid(const MapItem &item) override {
			const auto it = persistedUids.find(item.key);
			return it == persistedUids.end() ? item.uid : it->second;
		}
		std::vector<UniqueOccurrence> uniqueIds(const std::unordered_set<uint16_t> &requested) override {
			std::vector<UniqueOccurrence> result;
			for (const auto &id : ids) {
				if (requested.empty() || requested.contains(id.uid)) {
					result.push_back(id);
				}
			}
			return result;
		}
	};
	const char* layerSource = R"json({"schemaVersion":2,"id":"authoring-example","name":"Biblioteca — São João","objects":[
		{"id":"example.sign","kind":"item","source":{"mode":"map","selector":{"position":{"x":100,"y":100,"z":7},"part":"item","itemId":2012}},"attributes":{"text":"Entrada da biblioteca.\nRespeite os visitantes.","aid":0}},
		{"id":"example.attribute_only_portal","kind":"item","source":{"mode":"map","selector":{"position":{"x":108,"y":108,"z":7},"part":"item","itemId":1949}},"attributes":{"aid":4914}},
		{"id":"example.arrival","kind":"anchor","position":{"x":110,"y":110,"z":7}},
		{"id":"example.portal","kind":"item","source":{"mode":"create","itemId":1949,"count":1,"placement":{"position":{"x":102,"y":100,"z":7}}},"lifecycle":"fixture","attributes":{"uid":45001},"components":[{"type":"teleport","destination":{"object":"example.arrival","offset":{"x":0,"y":-1,"z":0}}}]},
		{"id":"example.door","kind":"item","source":{"mode":"map","selector":{"position":{"x":104,"y":102,"z":7},"part":"item","itemId":1662}},"attributes":{"aid":12107}},
		{"id":"example.lever","kind":"item","source":{"mode":"map","selector":{"position":{"x":103,"y":102,"z":7},"part":"item","itemId":2772}},"attributes":{"aid":12107},"behaviors":[{"id":"quest.gated_door","contractVersion":1,"events":["onUse"],"parameters":{"storageKey":60001,"openDoorItemId":1663},"relations":{"door":{"object":"example.door"}}}]},
		{"id":"example.bookcase","kind":"item","source":{"mode":"map","selector":{"position":{"x":100,"y":104,"z":7},"part":"item","itemId":2435}}},
		{"id":"example.existing_book","kind":"item","source":{"mode":"map","selector":{"container":"example.bookcase","itemId":2828}},"attributes":{"text":"Este livro já pertence ao mapa-base."}},
		{"id":"example.external_book","kind":"item","source":{"mode":"create","itemId":2828,"count":1,"placement":{"container":"example.bookcase","order":0}},"lifecycle":"refillOnStartup","attributes":{"text":"História da biblioteca.\nSegunda página.","writer":"Bibliotecário"}},
		{"id":"example.replacement_portal","kind":"item","source":{"mode":"replace","selector":{"position":{"x":104,"y":100,"z":7},"part":"item","itemId":1949},"itemId":1949,"count":1,"placement":{"position":{"x":106,"y":100,"z":7}}},"lifecycle":"fixture","attributes":{"uid":45002},"components":[{"type":"teleport","destination":{"object":"example.arrival"}}]}
	]})json";
	const char* behaviorSource = R"json({"schemaVersion":2,"id":"quest.gated_door","contractVersion":1,"name":"Abrir porta com condição","script":"quest_gated_door.lua","targetKind":"item","events":["onUse"],"parameters":{
		"requiredLevel":{"type":"integer","minimum":1,"default":1},
		"storageKey":{"type":"integer","minimum":1,"required":true},
		"requiredValue":{"type":"integer","default":1},
		"openDoorItemId":{"type":"itemId","required":true,"capabilities":["door"]},
		"deniedMessage":{"type":"string","default":"Você não atende aos requisitos."}
	},"relations":{"door":{"type":"objectRef","targetKind":"item","capabilities":["door"],"required":true,"allowOffset":false}}})json";
}

void runWorldV2Tests(const std::filesystem::path &scratch) {
	using namespace world_layers;
	const auto root = scratch / "v2";
	std::filesystem::create_directories(root);
	write(root / "example.world.json", R"({"schemaVersion":2,"id":"authoring-example","map":"example.otbm","items":"items.xml","layers":[{"file":"example.layer.json","enabled":true}],"behaviorCatalog":["quest_gated_door.behavior.json"],"migrations":[]})");
	write(root / "example.layer.json", layerSource);
	write(root / "quest_gated_door.behavior.json", behaviorSource);
	write(root / "quest_gated_door.lua", "-- fixture implementation\n");
	Project project;
	Diagnostics diagnostics;
	require(loadProject(root / "example.world.json", project, diagnostics), diagnostics.empty() ? "load complete authoring example" : diagnostics.front().describe());
	validateProject(project, diagnostics);
	require(diagnostics.empty(), diagnostics.empty() ? "project validation" : diagnostics.front().describe());
	require(project.find("example.sign") && !project.find("authoring-example.example.sign"), "fully qualified object IDs are independent of layer identity");
	require(project.find("example.sign")->aidOverride && project.find("example.sign")->aid == 0, "explicit zero differs from inheritance");
	require(!project.find("example.bookcase")->aidOverride, "missing AID inherits");
	Layer roundTrip;
	require(parseLayer(serializeLayer(project.layers[0]), root / "roundtrip.json", roundTrip, diagnostics), "v2 round trip parses");
	require(roundTrip.objects == project.layers[0].objects, "v2 round trip preserves objects, Unicode, parameters and inheritance");
	Map map;
	for (int x = 95; x <= 115; ++x) {
		for (int y = 95; y <= 115; ++y) {
			map.tiles[{ x, y, 7 }] = { true, true, false, false, {} };
		}
	}
	map.tiles[{ 100, 100, 7 }].items.push_back({ 1, 2012 });
	map.tiles[{ 104, 102, 7 }].items.push_back({ 2, 1662 });
	map.tiles[{ 103, 102, 7 }].items.push_back({ 3, 2772 });
	MapItem bookcase { 4, 2435 };
	bookcase.container = true;
	bookcase.children.push_back({ 5, 2828 });
	map.tiles[{ 100, 104, 7 }].items.push_back(bookcase);
	map.tiles[{ 104, 100, 7 }].items.push_back({ 6, 1949, 0, true, {} });
	map.tiles[{ 108, 108, 7 }].items.push_back({ 8, 1949, 0, true, { 108, 109, 7 } });
	map.tiles[{ 108, 109, 7 }].blocked = true;
	ApplicationPlan plan;
	const auto check = [&] { diagnostics.clear(); return validateMap(project, map, plan, diagnostics); };
	require(check(), diagnostics.empty() ? "attribute-only native teleport preserves its base-map behavior" : diagnostics.front().describe());
	require(plan.objects.size() == 10 && plan.originals.size() == 1 && plan.originals.contains(6), "bindings are not suppressed originals; replacements are");
	require(plan.objects[0].original == 1, "bind exact original");
	map.tiles[{ 100, 100, 7 }].ground = false;
	require(check(), "existing wall items can be configured on a tile without ground");
	map.tiles[{ 100, 100, 7 }].ground = true;
	map.tiles[{ 102, 100, 7 }].ground = false;
	require(!check(), "external item placement still requires ground");
	map.tiles[{ 102, 100, 7 }].ground = true;
	project.find("example.external_book")->position = { 0, 0, 0 };
	require(check(), "container position comes from its declared parent");
	project.find("example.external_book")->uid = 45003;
	require(!check(), "refill items cannot reserve UIDs");
	project.find("example.external_book")->uid = 0;
	map.tiles[{ 100, 104, 7 }].items.front().children.push_back({ 7, 2828 });
	require(!check(), "ambiguous base child selector is rejected");
	auto &selector = *project.find("example.existing_book")->selector;
	selector.occurrence = Occurrence { 1, 2, selectorFingerprint(map.tiles[{ 100, 104, 7 }].items.front().children) };
	require(check(), "explicit base occurrence preconditions disambiguate identical books");
	map.tiles[{ 100, 104, 7 }].items.front().children[0].aid = 100;
	require(!check(), "changed base fingerprint requires reassociation");
	map.tiles[{ 100, 104, 7 }].items.front().children.pop_back();
	map.tiles[{ 100, 104, 7 }].items.front().children[0].aid = 0;
	selector.occurrence.reset();
	map.ids.push_back({ 45001, 999, { 110, 110, 7 } });
	require(!check(), "external UID conflicts with unmanaged world UID");
	map.ids.clear();
	map.tiles[{ 104, 102, 7 }].items.front().uid = 45001;
	require(!check(), "inherited UID conflicts with external UID");
	project.find("example.door")->uidOverride = true;
	project.find("example.door")->uid = 0;
	require(check(), "explicitly clearing inherited UID removes the collision");
	project.find("example.lever")->behaviors[0].parameters["openDoorItemId"] = Value { int64_t(2828) };
	require(!check(), "descriptor item capability is enforced");
	project.find("example.lever")->behaviors[0].parameters["openDoorItemId"] = Value { int64_t(1663) };
	project.find("example.lever")->behaviors[0].parameters["typo"] = Value { true };
	require(!check(), "unknown parameter is rejected without discarding it");
	project.find("example.lever")->behaviors[0].parameters.erase("typo");
	project.find("example.arrival")->position = { 102, 100, 7 };
	project.find("example.portal")->teleport->destinationOffset = {};
	require(!check(), "native arrival cycle rejected separately from ordinary relationships");
	project.find("example.arrival")->position = { 110, 110, 7 };
	project.find("example.sign")->relations["other"] = { { "example.lever", {} } };
	project.find("example.lever")->relations["other"] = { { "example.sign", {} } };
	require(check(), "ordinary cyclic relations are allowed");
	project.find("example.bookcase")->container = "example.existing_book";
	require(!check(), "cyclic containment is rejected");
	project.find("example.bookcase")->container.clear();
	const auto originalLayerId = project.layers[0].id;
	project.layers[0].id = "renamed-file-group";
	project.rebuildIndex(diagnostics);
	require(project.find("example.lever") != nullptr, "layer rename leaves object identity stable");
	project.layers[0].id = originalLayerId;

	map.baseline[{ 100, 104, 7 }] = map.tiles[{ 100, 104, 7 }];
	map.tiles[{ 100, 104, 7 }].items.front().children.push_back({ 1001, 2828 });
	require(check(), "persisted/refilled child does not make a base selector ambiguous");
	map.tiles[{ 100, 104, 7 }].items.front().children.pop_back();
	map.baseline.clear();
	map.persistedUids[5] = 45001;
	require(!check(), "live inherited UID is validated independently of original selection");
	map.persistedUids.clear();
	project.find("example.bookcase")->mode = SourceMode::Replace;
	require(!check(), "cannot bind a child removed by its parent's replacement");
	project.find("example.bookcase")->mode = SourceMode::Map;

	const std::string digest(64, 'a');
	const auto migration = std::string(R"({"schemaVersion":2,"id":"fixture-migration","sources":[{"file":"legacy.lua","sha256":")") + digest + R"("}],"claims":[{"source":{"file":"legacy.lua","table":"LeverAction","key":"12107","declaration":2,"fingerprint":")" + digest + R"("},"occurrence":"1.item","object":"example.lever","responsibilities":["attributes.aid","onUse"]}]})";
	write(root / "migration.json", migration);
	MigrationRecord record;
	diagnostics.clear();
	require(loadMigration(root / "migration.json", record, diagnostics), "transition claim parses with source revision and occurrence");
	record.receipt = root / "migration.receipt.json";
	const auto serializedMigration = serializeMigration(record);
	write(root / "migration.json", serializedMigration);
	MigrationRecord reread;
	require(loadMigration(root / "migration.json", reread, diagnostics) && serializeMigration(reread) == serializedMigration, "migration identity rewrite round trip retains source preconditions");
	require(reread.receipt == record.receipt, "tool recovery metadata remains associated after migration serialization");
	project.migrationRecords.push_back(record);
	require(check(), "migration target and responsibility validation");
	project.layers[0].enabled = false;
	require(check(), "disabled layer retains migration ownership");
	project.layers[0].enabled = true;
	project.migrationRecords.push_back(record);
	require(!check(), "duplicate migration/ownership rejected");
	project.migrationRecords.clear();
	write(root / "migration.json", R"({"schemaVersion":2,"id":"bad","sources":[],"claims":[{"source":{"file":"legacy.lua"},"occurrence":"1.item","object":"example.lever","responsibilities":["attributes.aid"]}]})");
	diagnostics.clear();
	require(!loadMigration(root / "migration.json", record, diagnostics), "claims without source revisions rejected");

	for (const auto* invalid : {
			 R"({"schemaVersion":2,"id":"test","objects":[{"id":"x","id":"y","kind":"anchor","position":{"x":1,"y":1,"z":7}}]})",
			 R"({"schemaVersion":2,"id":"test","objects":[{"id":"x","kind":"item","source":{"mode":"map","selector":{"position":{"x":1,"y":1,"z":7},"part":"item","itemId":1}},"attributes":{"unknown":1}}]})",
			 R"({"schemaVersion":2,"id":"test","objects":[{"id":"x","kind":"anchor","position":{"x":1,"y":1,"z":16}}]})" }) {
		diagnostics.clear();
		require(!parseLayer(invalid, root / "invalid.json", roundTrip, diagnostics), "invalid document rejected transactionally");
	}
	Value value;
	std::string error;
	Selector selected;
	selected.itemId = 1949;
	std::vector<MapItem> candidates { { 101, 1949 }, { 102, 1949 } };
	require(captureSelector(selected, candidates, 102, error) && selected.occurrence && selected.occurrence->index == 1, "explicit clicked item captures ambiguity preconditions");
	MapItem chosen;
	require(resolveSelector(selected, candidates, chosen, error) && chosen.key == 102, "captured selector resolves exactly the clicked occurrence");
	candidates.pop_back();
	require(!resolveSelector(selected, candidates, chosen, error), "removing an indistinguishable item invalidates the captured selection");
	BehaviorDescriptor defaults;
	Parameter amount;
	amount.type = "integer";
	amount.defaultValue = Value { int64_t(3) };
	Parameter reward;
	reward.type = "record";
	reward.fields.emplace("amount", amount);
	Parameter rewards;
	rewards.type = "list";
	rewards.element.push_back(reward);
	defaults.parameters.emplace("rewards", rewards);
	defaults.parameters.emplace("level", amount);
	BehaviorBinding configured;
	configured.parameters["rewards"] = Value { Value::List { Value { Value::Record {} } } };
	auto resolved = resolveParameters(defaults, configured);
	require(std::get<int64_t>(resolved.at("level").data) == 3, "top-level behavior default materialized");
	auto &resolvedReward = std::get<Value::Record>(std::get<Value::List>(resolved.at("rewards").data)[0].data);
	require(std::get<int64_t>(resolvedReward.at("amount").data) == 3, "defaults nested inside lists of records materialized");
	resolvedReward["amount"] = Value { int64_t(99) };
	require(std::get<Value::Record>(std::get<Value::List>(configured.parameters.at("rewards").data)[0].data).empty(), "mutable behavior result never modifies its definition");
	require(!validateParameter(amount, Value { int64_t(9007199254740992LL) }, error), "inexact Lua integers rejected");
	require(validateParameter(amount, Value { int64_t(9007199254740991LL) }, error), "largest exact Lua integer accepted");
	require(!parseValue("{\"key\":1,\"key\":2}", value, error), "duplicate typed value key rejected");
	require(!parseValue("18446744073709551615", value, error), "unsigned overflow cannot wrap into Lua integer");
	require(!parseValue("1e999", value, error), "nonfinite values rejected");
	const auto nested = std::string(200, '[') + "0" + std::string(200, ']');
	require(!parseValue(nested, value, error), "deep JSON rejected before typed decoding");
}
