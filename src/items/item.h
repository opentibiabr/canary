/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_ITEMS_ITEM_H_
#define SRC_ITEMS_ITEM_H_

#include "items/cylinder.h"
#include "items/thing.h"
#include "items/items.h"
#include "lua/scripts/luascript.h"
#include "utils/tools.h"
#include "io/fileloader.h"

class Creature;
class Player;
class Container;
class Depot;
class Teleport;
class TrashHolder;
class Mailbox;
class Door;
class MagicField;
class BedItem;
class Imbuement;

class ItemAttributes
{
	public:
		ItemAttributes() = default;

		void setSpecialDescription(const std::string& desc) {
			setStrAttr(ITEM_ATTRIBUTE_DESCRIPTION, desc);
		}
		const std::string& getSpecialDescription() const {
			return getStrAttr(ITEM_ATTRIBUTE_DESCRIPTION);
		}

		void setText(const std::string& text) {
			setStrAttr(ITEM_ATTRIBUTE_TEXT, text);
		}
		void resetText() {
			removeAttribute(ITEM_ATTRIBUTE_TEXT);
		}
		const std::string& getText() const {
			return getStrAttr(ITEM_ATTRIBUTE_TEXT);
		}

		void setDate(int32_t n) {
			setIntAttr(ITEM_ATTRIBUTE_DATE, n);
		}
		void resetDate() {
			removeAttribute(ITEM_ATTRIBUTE_DATE);
		}
		time_t getDate() const {
			return getIntAttr(ITEM_ATTRIBUTE_DATE);
		}

		void setWriter(const std::string& writer) {
			setStrAttr(ITEM_ATTRIBUTE_WRITER, writer);
		}
		void resetWriter() {
			removeAttribute(ITEM_ATTRIBUTE_WRITER);
		}
		const std::string& getWriter() const {
			return getStrAttr(ITEM_ATTRIBUTE_WRITER);
		}

		void setActionId(uint16_t n) {
			setIntAttr(ITEM_ATTRIBUTE_ACTIONID, n);
		}
		uint16_t getActionId() const {
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_ACTIONID));
		}

		void setUniqueId(uint16_t n) {
			setIntAttr(ITEM_ATTRIBUTE_UNIQUEID, n);
		}
		uint16_t getUniqueId() const {
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_UNIQUEID));
		}

		void setCharges(uint16_t n) {
			setIntAttr(ITEM_ATTRIBUTE_CHARGES, n);
		}
		uint16_t getCharges() const {
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_CHARGES));
		}

		void setFluidType(uint16_t n) {
			setIntAttr(ITEM_ATTRIBUTE_FLUIDTYPE, n);
		}
		uint16_t getFluidType() const {
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_FLUIDTYPE));
		}

		void setOwner(uint32_t owner) {
			setIntAttr(ITEM_ATTRIBUTE_OWNER, owner);
		}
		uint32_t getOwner() const {
			return getIntAttr(ITEM_ATTRIBUTE_OWNER);
		}

		void setCorpseOwner(uint32_t corpseOwner) {
			setIntAttr(ITEM_ATTRIBUTE_CORPSEOWNER, corpseOwner);
		}
		uint32_t getCorpseOwner() const {
			return getIntAttr(ITEM_ATTRIBUTE_CORPSEOWNER);
		}

		void setDuration(int32_t time) {
			setIntAttr(ITEM_ATTRIBUTE_DURATION, std::max<int32_t>(0, time));
		}
		void setDurationTimestamp(int64_t timestamp) {
			setIntAttr(ITEM_ATTRIBUTE_DURATION_TIMESTAMP, timestamp);
		}
		int32_t getDuration() const {
			ItemDecayState_t decayState = getDecaying();
			if (decayState == DECAYING_TRUE || decayState == DECAYING_STOPPING) {
				return std::max<int32_t>(0, static_cast<int32_t>(getIntAttr(ITEM_ATTRIBUTE_DURATION_TIMESTAMP) - OTSYS_TIME()));
			} else {
				return getIntAttr(ITEM_ATTRIBUTE_DURATION);
			}
		}

		void setDecaying(ItemDecayState_t decayState) {
			setIntAttr(ITEM_ATTRIBUTE_DECAYSTATE, decayState);
			if (decayState == DECAYING_FALSE) {
				removeAttribute(ITEM_ATTRIBUTE_DURATION_TIMESTAMP);
			}
		}
		ItemDecayState_t getDecaying() const {
			return static_cast<ItemDecayState_t>(getIntAttr(ITEM_ATTRIBUTE_DECAYSTATE));
		}

		struct CustomAttribute
		{
			typedef boost::variant<boost::blank, std::string, int64_t, double, bool> VariantAttribute;
			VariantAttribute value;

			CustomAttribute() : value(boost::blank()) {}

			template<typename T>
			explicit CustomAttribute(const T& v) : value(v) {}

			template<typename T>
			void set(const T& v) {
				value = v;
			}

			const std::string& getString() const {
				if (value.type() == typeid(std::string)) {
					return boost::get<std::string>(value);
				}

				return emptyString;
			}

			const int64_t& getInt() const {
				if (value.type() == typeid(int64_t)) {
					return boost::get<int64_t>(value);
				}

				return emptyInt;
			}

			const double& getDouble() const {
				if (value.type() == typeid(double)) {
					return boost::get<double>(value);
				}

				return emptyDouble;
			}

			const bool& getBool() const {
				if (value.type() == typeid(bool)) {
					return boost::get<bool>(value);
				}

				return emptyBool;
			}

			struct PushLuaVisitor : public boost::static_visitor<> {
				lua_State* L;

				explicit PushLuaVisitor(lua_State* L) : boost::static_visitor<>(), L(L) {}

				void operator()(const boost::blank&) const {
					lua_pushnil(L);
				}

				void operator()(const std::string& v) const {
					LuaScriptInterface::pushString(L, v);
				}

				void operator()(bool v) const {
					LuaScriptInterface::pushBoolean(L, v);
				}

				void operator()(const int64_t& v) const {
					lua_pushnumber(L, v);
				}

				void operator()(const double& v) const {
					lua_pushnumber(L, v);
				}
			};

			void pushToLua(lua_State* L) const {
				boost::apply_visitor(PushLuaVisitor(L), value);
			}

			struct SerializeVisitor : public boost::static_visitor<> {
				PropWriteStream& propWriteStream;

				explicit SerializeVisitor(PropWriteStream& propWriteStream) : boost::static_visitor<>(), propWriteStream(propWriteStream) {}

				void operator()(const boost::blank&) const {
				}

				void operator()(const std::string& v) const {
					propWriteStream.writeString(v);
				}

				template<typename T>
				void operator()(const T& v) const {
					propWriteStream.write<T>(v);
				}
			};

			void serialize(PropWriteStream& propWriteStream) const {
				propWriteStream.write<uint8_t>(static_cast<uint8_t>(value.which()));
				boost::apply_visitor(SerializeVisitor(propWriteStream), value);
			}

			bool unserialize(PropStream& propStream) {
				// This is hard coded so it's not general, depends on the position of the variants.
				uint8_t pos;
				if (!propStream.read<uint8_t>(pos)) {
					return false;
				}

				switch (pos) {
					case 1:  { // std::string
						std::string tmp;
						if (!propStream.readString(tmp)) {
							return false;
						}
						value = tmp;
						break;
					}

					case 2: { // int64_t
						int64_t tmp;
						if (!propStream.read<int64_t>(tmp)) {
							return false;
						}
						value = tmp;
						break;
					}

					case 3: { // double
						double tmp;
						if (!propStream.read<double>(tmp)) {
							return false;
						}
						value = tmp;
						break;
					}

					case 4: { // bool
						bool tmp;
						if (!propStream.read<bool>(tmp)) {
							return false;
						}
						value = tmp;
						break;
					}

					default: {
						value = boost::blank();
						return false;
					}
				}
				return true;
			}
		};

	private:
		bool hasAttribute(ItemAttrTypes type) const {
			return (type & static_cast<ItemAttrTypes>(attributeBits)) != 0;
		}
		void removeAttribute(ItemAttrTypes type);

		static std::string emptyString;
		static int64_t emptyInt;
		static double emptyDouble;
		static bool emptyBool;

		typedef phmap::flat_hash_map<std::string, CustomAttribute> CustomAttributeMap;

		struct Attribute {
			union {
				int64_t integer;
				std::string* string;
				CustomAttributeMap* custom;
			} value;
			ItemAttrTypes type;

			// Singleton - ensures we don't accidentally copy it
			Attribute& operator=(const Attribute& other) = delete;

			explicit Attribute(ItemAttrTypes type) : type(type) {
				memset(&value, 0, sizeof(value));
			}
			Attribute(const Attribute& i) {
				type = i.type;
				if (ItemAttributes::isIntAttrType(type)) {
					value.integer = i.value.integer;
				} else if (ItemAttributes::isStrAttrType(type)) {
					value.string = new std::string(*i.value.string);
				} else if (ItemAttributes::isCustomAttrType(type)) {
					value.custom = new CustomAttributeMap(*i.value.custom);
				} else {
					memset(&value, 0, sizeof(value));
				}
			}
			Attribute(Attribute&& attribute) noexcept : value(attribute.value), type(attribute.type) {
				memset(&attribute.value, 0, sizeof(value));
				attribute.type = ITEM_ATTRIBUTE_NONE;
			}
			Attribute& operator=(Attribute&& other) noexcept {
				if (this != &other) {
					if (ItemAttributes::isStrAttrType(type)) {
						delete value.string;
					} else if (ItemAttributes::isCustomAttrType(type)) {
						delete value.custom;
					}

					value = other.value;
					type = other.type;

					memset(&other.value, 0, sizeof(value));
					other.type = ITEM_ATTRIBUTE_NONE;
				}
				return *this;
			}
			~Attribute() {
				if (ItemAttributes::isStrAttrType(type)) {
					delete value.string;
				} else if (ItemAttributes::isCustomAttrType(type)) {
					delete value.custom;
				}
			}
		};

		std::vector<Attribute> attributes;
		std::underlying_type_t<ItemAttrTypes> attributeBits = 0;

		const std::string& getStrAttr(ItemAttrTypes type) const;
		void setStrAttr(ItemAttrTypes type, const std::string& value);

		int64_t getIntAttr(ItemAttrTypes type) const;
		void setIntAttr(ItemAttrTypes type, int64_t value);
		void increaseIntAttr(ItemAttrTypes type, int64_t value);

		const Attribute* getExistingAttr(ItemAttrTypes type) const;
		Attribute& getAttr(ItemAttrTypes type);

		CustomAttributeMap* getCustomAttributeMap() {
			if (!hasAttribute(ITEM_ATTRIBUTE_CUSTOM)) {
				return nullptr;
			}

			return getAttr(ITEM_ATTRIBUTE_CUSTOM).value.custom;
		}

		template<typename R>
		void setCustomAttribute(int64_t key, R value) {
			std::string tmp = std::to_string(key);
			setCustomAttribute(tmp, value);
		}

		void setCustomAttribute(int64_t key, CustomAttribute& value) {
			std::string tmp = std::to_string(key);
			setCustomAttribute(tmp, value);
		}

		template<typename R>
		void setCustomAttribute(std::string& key, R value) {
			toLowerCaseString(key);
			if (hasAttribute(ITEM_ATTRIBUTE_CUSTOM)) {
				removeCustomAttribute(key);
			} else {
				getAttr(ITEM_ATTRIBUTE_CUSTOM).value.custom = new CustomAttributeMap();
			}
			getAttr(ITEM_ATTRIBUTE_CUSTOM).value.custom->emplace(key, value);
		}

		void setCustomAttribute(std::string& key, CustomAttribute& value) {
			toLowerCaseString(key);
			if (hasAttribute(ITEM_ATTRIBUTE_CUSTOM)) {
				removeCustomAttribute(key);
			} else {
				getAttr(ITEM_ATTRIBUTE_CUSTOM).value.custom = new CustomAttributeMap();
			}
			getAttr(ITEM_ATTRIBUTE_CUSTOM).value.custom->insert(std::make_pair(std::move(key), std::move(value)));
		}

		const CustomAttribute* getCustomAttribute(int64_t key) {
			std::string tmp = std::to_string(key);
			return getCustomAttribute(tmp);
		}

		const CustomAttribute* getCustomAttribute(const std::string& key) {
			if (const CustomAttributeMap* customAttrMap = getCustomAttributeMap()) {
				auto it = customAttrMap->find(asLowerCaseString(key));
				if (it != customAttrMap->end()) {
					return &(it->second);
				}
			}
			return nullptr;
		}

		bool removeCustomAttribute(int64_t key) {
			std::string tmp = std::to_string(key);
			return removeCustomAttribute(tmp);
		}

		bool removeCustomAttribute(const std::string& key) {
			if (CustomAttributeMap* customAttrMap = getCustomAttributeMap()) {
				auto it = customAttrMap->find(asLowerCaseString(key));
				if (it != customAttrMap->end()) {
					customAttrMap->erase(it);
					return true;
				}
			}
			return false;
		}

	public:
		static bool isIntAttrType(ItemAttrTypes type) {
			std::underlying_type_t<ItemAttrTypes> checkTypes = 0;
			checkTypes |= ITEM_ATTRIBUTE_ACTIONID;
			checkTypes |= ITEM_ATTRIBUTE_UNIQUEID;
			checkTypes |= ITEM_ATTRIBUTE_DATE;
			checkTypes |= ITEM_ATTRIBUTE_WEIGHT;
			checkTypes |= ITEM_ATTRIBUTE_ATTACK;
			checkTypes |= ITEM_ATTRIBUTE_DEFENSE;
			checkTypes |= ITEM_ATTRIBUTE_EXTRADEFENSE;
			checkTypes |= ITEM_ATTRIBUTE_ARMOR;
			checkTypes |= ITEM_ATTRIBUTE_HITCHANCE;
			checkTypes |= ITEM_ATTRIBUTE_SHOOTRANGE;
			checkTypes |= ITEM_ATTRIBUTE_OWNER;
			checkTypes |= ITEM_ATTRIBUTE_DURATION;
			checkTypes |= ITEM_ATTRIBUTE_DECAYSTATE;
			checkTypes |= ITEM_ATTRIBUTE_CORPSEOWNER;
			checkTypes |= ITEM_ATTRIBUTE_CHARGES;
			checkTypes |= ITEM_ATTRIBUTE_FLUIDTYPE;
			checkTypes |= ITEM_ATTRIBUTE_DOORID;
			checkTypes |= ITEM_ATTRIBUTE_IMBUEMENT_SLOT;
			checkTypes |= ITEM_ATTRIBUTE_OPENCONTAINER;
			checkTypes |= ITEM_ATTRIBUTE_QUICKLOOTCONTAINER;
			checkTypes |= ITEM_ATTRIBUTE_DURATION_TIMESTAMP;
			checkTypes |= ITEM_ATTRIBUTE_TIER;
			return (type & static_cast<ItemAttrTypes>(checkTypes)) != 0;
		}
		static bool isStrAttrType(ItemAttrTypes type) {
			std::underlying_type_t<ItemAttrTypes> checkTypes = 0;
			checkTypes |= ITEM_ATTRIBUTE_DESCRIPTION;
			checkTypes |= ITEM_ATTRIBUTE_TEXT;
			checkTypes |= ITEM_ATTRIBUTE_WRITER;
			checkTypes |= ITEM_ATTRIBUTE_NAME;
			checkTypes |= ITEM_ATTRIBUTE_ARTICLE;
			checkTypes |= ITEM_ATTRIBUTE_PLURALNAME;
			checkTypes |= ITEM_ATTRIBUTE_SPECIAL;
			return (type & static_cast<ItemAttrTypes>(checkTypes)) != 0;
		}
		inline static bool isCustomAttrType(ItemAttrTypes type) {
			return (type & ITEM_ATTRIBUTE_CUSTOM) != 0;
		}

		const std::vector<Attribute>& getList() const {
			return attributes;
		}

	friend class Item;
};

class Item : virtual public Thing
{
	public:
		//Factory member to create item of right type based on type
		static Item* CreateItem(const uint16_t type, uint16_t count = 0);
		static Container* CreateItemAsContainer(const uint16_t type, uint16_t size);
		static Item* CreateItem(PropStream& propStream);
		static Items items;

		// Constructor for items
		Item(const uint16_t type, uint16_t count = 0);
		Item(const Item& i);
		virtual Item* clone() const;

		virtual ~Item() = default;

		// non-assignable
		Item& operator=(const Item&) = delete;

		bool equals(const Item* otherItem) const;

		Item* getItem() override final {
			return this;
		}
		const Item* getItem() const override final {
			return this;
		}
		virtual Teleport* getTeleport() {
			return nullptr;
		}
		virtual const Teleport* getTeleport() const {
			return nullptr;
		}
		virtual TrashHolder* getTrashHolder() {
			return nullptr;
		}
		virtual const TrashHolder* getTrashHolder() const {
			return nullptr;
		}
		virtual Mailbox* getMailbox() {
			return nullptr;
		}
		virtual const Mailbox* getMailbox() const {
			return nullptr;
		}
		virtual Door* getDoor() {
			return nullptr;
		}
		virtual const Door* getDoor() const {
			return nullptr;
		}
		virtual MagicField* getMagicField() {
			return nullptr;
		}
		virtual const MagicField* getMagicField() const {
			return nullptr;
		}
		virtual BedItem* getBed() {
			return nullptr;
		}
		virtual const BedItem* getBed() const {
			return nullptr;
		}

		SoundEffect_t getMovementSound(Cylinder* toCylinder);

		const std::string& getStrAttr(ItemAttrTypes type) const {
			if (!attributes) {
				return ItemAttributes::emptyString;
			}
			return attributes->getStrAttr(type);
		}
		void setStrAttr(ItemAttrTypes type, const std::string& value) {
			getAttributes()->setStrAttr(type, value);
		}

		int64_t getIntAttr(ItemAttrTypes type) const {
			if (!attributes) {
				return 0;
			}
			return attributes->getIntAttr(type);
		}
		void setIntAttr(ItemAttrTypes type, int64_t value) {
			getAttributes()->setIntAttr(type, value);
		}
		void increaseIntAttr(ItemAttrTypes type, int64_t value) {
			getAttributes()->increaseIntAttr(type, value);
		}

		void setIsLootTrackeable(bool value) {
			isLootTrackeable = value;
		}

		bool getIsLootTrackeable() {
			return isLootTrackeable;
		}

		void removeAttribute(ItemAttrTypes type) {
			if (attributes) {
				attributes->removeAttribute(type);
			}
		}
		bool hasAttribute(ItemAttrTypes type) const {
			if (!attributes) {
				return false;
			}
			return attributes->hasAttribute(type);
		}

		template<typename R>
		void setCustomAttribute(std::string& key, R value) {
			getAttributes()->setCustomAttribute(key, value);
		}

		void setCustomAttribute(std::string& key, ItemAttributes::CustomAttribute& value) {
			getAttributes()->setCustomAttribute(key, value);
		}

		const ItemAttributes::CustomAttribute* getCustomAttribute(int64_t key) {
			return getAttributes()->getCustomAttribute(key);
		}

		const ItemAttributes::CustomAttribute* getCustomAttribute(const std::string& key) {
			return getAttributes()->getCustomAttribute(key);
		}
		const ItemAttributes::CustomAttribute* getCustomAttribute(const std::string& key) const {
			if (!attributes) {
				return nullptr;
			}

			if (!attributes->hasAttribute(ITEM_ATTRIBUTE_CUSTOM)) {
				return nullptr;
			}

			ItemAttributes::CustomAttributeMap* customAttrMap = attributes->getAttr(ITEM_ATTRIBUTE_CUSTOM).value.custom;
			if (!customAttrMap) {
				return nullptr;
			}

			auto it = customAttrMap->find(asLowerCaseString(key));
			if (it != customAttrMap->end()) {
				return &(it->second);
			}

			return nullptr;
		}

		bool removeCustomAttribute(int64_t key) {
			return getAttributes()->removeCustomAttribute(key);
		}

		bool removeCustomAttribute(const std::string& key) {
			return getAttributes()->removeCustomAttribute(key);
		}

		void setSpecialDescription(const std::string& desc) {
			setStrAttr(ITEM_ATTRIBUTE_DESCRIPTION, desc);
		}
		const std::string& getSpecialDescription() const {
			return getStrAttr(ITEM_ATTRIBUTE_DESCRIPTION);
		}

		void setText(const std::string& text) {
			setStrAttr(ITEM_ATTRIBUTE_TEXT, text);
		}
		void resetText() {
			removeAttribute(ITEM_ATTRIBUTE_TEXT);
		}
		const std::string& getText() const {
			return getStrAttr(ITEM_ATTRIBUTE_TEXT);
		}

		void setDate(int32_t n) {
			setIntAttr(ITEM_ATTRIBUTE_DATE, n);
		}
		void resetDate() {
			removeAttribute(ITEM_ATTRIBUTE_DATE);
		}
		time_t getDate() const {
			return static_cast<time_t>(getIntAttr(ITEM_ATTRIBUTE_DATE));
		}

		void setWriter(const std::string& writer) {
			setStrAttr(ITEM_ATTRIBUTE_WRITER, writer);
		}
		void resetWriter() {
			removeAttribute(ITEM_ATTRIBUTE_WRITER);
		}
		const std::string& getWriter() const {
			return getStrAttr(ITEM_ATTRIBUTE_WRITER);
		}

		void setActionId(uint16_t n) {
			if (n < 100) {
				n = 100;
			}

			setIntAttr(ITEM_ATTRIBUTE_ACTIONID, n);
		}
		uint16_t getActionId() const {
			if (!attributes) {
				return 0;
			}
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_ACTIONID));
		}

		uint16_t getUniqueId() const {
			if (!attributes) {
				return 0;
			}
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_UNIQUEID));
		}

		void setCharges(uint16_t n) {
			setIntAttr(ITEM_ATTRIBUTE_CHARGES, n);
		}
		uint16_t getCharges() const {
			if (!attributes) {
				return 0;
			}
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_CHARGES));
		}

		void setFluidType(uint16_t n) {
			setIntAttr(ITEM_ATTRIBUTE_FLUIDTYPE, n);
		}
		uint16_t getFluidType() const {
			if (!attributes) {
				return 0;
			}
			return static_cast<uint16_t>(getIntAttr(ITEM_ATTRIBUTE_FLUIDTYPE));
		}

		void setOwner(uint32_t owner) {
			setIntAttr(ITEM_ATTRIBUTE_OWNER, owner);
		}
		uint32_t getOwner() const {
			if (!attributes) {
				return 0;
			}
			return getIntAttr(ITEM_ATTRIBUTE_OWNER);
		}

		void setCorpseOwner(uint32_t corpseOwner) {
			setIntAttr(ITEM_ATTRIBUTE_CORPSEOWNER, corpseOwner);
		}
		uint32_t getCorpseOwner() const {
			if (!attributes) {
				return 0;
			}
			return getIntAttr(ITEM_ATTRIBUTE_CORPSEOWNER);
		}

		void setRewardCorpse() {
			setCorpseOwner(static_cast<uint32_t>(std::numeric_limits<int32_t>::max()));
		}
		bool isRewardCorpse() {
			return getCorpseOwner() == static_cast<uint32_t>(std::numeric_limits<int32_t>::max());
		}

		void setDuration(int32_t time) {
			setIntAttr(ITEM_ATTRIBUTE_DURATION, std::max<int32_t>(0, time));
		}
		void setDurationTimestamp(int64_t timestamp) {
			setIntAttr(ITEM_ATTRIBUTE_DURATION_TIMESTAMP, timestamp);
		}
		int32_t getDuration() const {
			ItemDecayState_t decayState = getDecaying();
			if (decayState == DECAYING_TRUE || decayState == DECAYING_STOPPING) {
				return std::max<int32_t>(0, static_cast<int32_t>(getIntAttr(ITEM_ATTRIBUTE_DURATION_TIMESTAMP) - OTSYS_TIME()));
			} else {
				return getIntAttr(ITEM_ATTRIBUTE_DURATION);
			}
		}

		void setDecaying(ItemDecayState_t decayState) {
			setIntAttr(ITEM_ATTRIBUTE_DECAYSTATE, decayState);
			if (decayState == DECAYING_FALSE) {
				removeAttribute(ITEM_ATTRIBUTE_DURATION_TIMESTAMP);
			}
		}
		ItemDecayState_t getDecaying() const {
			if (!attributes) {
				return DECAYING_FALSE;
			}
			return static_cast<ItemDecayState_t>(getIntAttr(ITEM_ATTRIBUTE_DECAYSTATE));
		}

		static std::string parseImbuementDescription(const Item* item);
		static std::string parseShowAttributesDescription(const Item *item, const uint16_t itemId);
		static std::string parseClassificationDescription(const Item* item);

		static std::vector<std::pair<std::string, std::string>> getDescriptions(const ItemType& it,
                                    const Item* item = nullptr);
		static std::string getDescription(const ItemType& it, int32_t lookDistance, const Item* item = nullptr, int32_t subType = -1, bool addArticle = true);
		static std::string getNameDescription(const ItemType& it, const Item* item = nullptr, int32_t subType = -1, bool addArticle = true);
		static std::string getWeightDescription(const ItemType& it, uint32_t weight, uint32_t count = 1);

		std::string getDescription(int32_t lookDistance) const override final;
		std::string getNameDescription() const;
		std::string getWeightDescription() const;

		//serialization
		virtual Attr_ReadValue readAttr(AttrTypes_t attr, PropStream& propStream);
		bool unserializeAttr(PropStream& propStream);
		virtual bool unserializeItemNode(OTB::Loader&, const OTB::Node&, PropStream& propStream);

		virtual void serializeAttr(PropWriteStream& propWriteStream) const;

		bool isPushable() const override final {
			return isMoveable();
		}
		int32_t getThrowRange() const override final {
			return (isPickupable() ? 15 : 2);
		}

		uint16_t getID() const {
			return id;
		}
		void setID(uint16_t newid);

		// Returns the player that is holding this item in his inventory
		Player* getHoldingPlayer() const;

		WeaponType_t getWeaponType() const {
			return items[id].weaponType;
		}
		Ammo_t getAmmoType() const {
			return items[id].ammoType;
		}
		uint8_t getShootRange() const {
			if (hasAttribute(ITEM_ATTRIBUTE_SHOOTRANGE)) {
				return static_cast<uint8_t>(getIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE));
			}
			return items[id].shootRange;
		}

		virtual uint32_t getWeight() const;
		uint32_t getBaseWeight() const {
			if (hasAttribute(ITEM_ATTRIBUTE_WEIGHT)) {
				return getIntAttr(ITEM_ATTRIBUTE_WEIGHT);
			}
			return items[id].weight;
		}
		int32_t getAttack() const {
			if (hasAttribute(ITEM_ATTRIBUTE_ATTACK)) {
				return getIntAttr(ITEM_ATTRIBUTE_ATTACK);
			}
			return items[id].attack;
		}
		int32_t getArmor() const {
			if (hasAttribute(ITEM_ATTRIBUTE_ARMOR)) {
				return getIntAttr(ITEM_ATTRIBUTE_ARMOR);
			}
			return items[id].armor;
		}
		int32_t getDefense() const {
			if (hasAttribute(ITEM_ATTRIBUTE_DEFENSE)) {
				return getIntAttr(ITEM_ATTRIBUTE_DEFENSE);
			}
			return items[id].defense;
		}
		int32_t getExtraDefense() const {
			if (hasAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE)) {
				return getIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE);
			}
			return items[id].extraDefense;
		}
		uint8_t getImbuementSlot() const {
			if (hasAttribute(ITEM_ATTRIBUTE_IMBUEMENT_SLOT)) {
				return getIntAttr(ITEM_ATTRIBUTE_IMBUEMENT_SLOT);
			}
			return items[id].imbuementSlot;
		}
		int32_t getSlotPosition() const {
			return items[id].slotPosition;
		}
		int8_t getHitChance() const {
			if (hasAttribute(ITEM_ATTRIBUTE_HITCHANCE)) {
				return static_cast<uint8_t>(getIntAttr(ITEM_ATTRIBUTE_HITCHANCE));
			}
			return items[id].hitChance;
		}
		uint32_t getQuicklootAttr() const {
			if (hasAttribute(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER)) {
				return getIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER);
			}
			return 0;
		}

		uint32_t getWorth() const;
		uint32_t getForgeSlivers() const;
		uint32_t getForgeCores() const;
		LightInfo getLightInfo() const;

		bool hasProperty(ItemProperty prop) const;
		bool isBlocking() const {
			return items[id].blockSolid;
		}
		bool isStackable() const {
			return items[id].stackable;
		}
		bool isStowable() const {
			return items[id].stackable && items[id].wareId > 0;
		}
		bool isAlwaysOnTop() const {
			return items[id].alwaysOnTopOrder != 0;
		}
		bool isGroundTile() const {
			return items[id].isGroundTile();
		}
		bool isMagicField() const {
			return items[id].isMagicField();
		}
		bool isWrapContainer() const {
			return items[id].wrapContainer;
		}
		bool isMoveable() const {
			return items[id].moveable;
		}
		bool isCorpse() const {
			return items[id].isCorpse;
		}
		bool isPickupable() const {
			return items[id].pickupable;
		}
		bool isMultiUse() const {
			return items[id].multiUse;
		}
		bool isHangable() const {
			return items[id].isHangable;
		}
		bool isRotatable() const {
			return items[id].rotatable && items[id].rotateTo;
		}
		bool isPodium() const {
			return items[id].isPodium;
		}
		bool isWrapable() const {
			return items[id].wrapable && items[id].wrapableTo;
		}
		bool hasWalkStack() const {
			return items[id].walkStack;
		}
		bool isQuiver() const {
			return items[id].isQuiver();
		}

		const std::string& getName() const {
			if (hasAttribute(ITEM_ATTRIBUTE_NAME)) {
				return getStrAttr(ITEM_ATTRIBUTE_NAME);
			}
			return items[id].name;
		}
		const std::string getPluralName() const {
			if (hasAttribute(ITEM_ATTRIBUTE_PLURALNAME)) {
				return getStrAttr(ITEM_ATTRIBUTE_PLURALNAME);
			}
			return items[id].getPluralName();
		}
		const std::string& getArticle() const {
			if (hasAttribute(ITEM_ATTRIBUTE_ARTICLE)) {
				return getStrAttr(ITEM_ATTRIBUTE_ARTICLE);
			}
			return items[id].article;
		}

		// get the number of items
		uint16_t getItemCount() const {
			return count;
		}
		void setItemCount(uint8_t n) {
			count = n;
		}

		static uint32_t countByType(const Item* item, int32_t subType) {
			if (subType == -1 || subType == item->getSubType()) {
				return item->getItemCount();
			}

			return 0;
		}

		void setDefaultSubtype();
		uint16_t getSubType() const;
		bool isItemStorable() const;
		void setSubType(uint16_t n);

		void setUniqueId(uint16_t n);

		void setDefaultDuration() {
			uint32_t duration = getDefaultDuration();
			if (duration != 0) {
				setDuration(duration);
			}
		}
		uint32_t getDefaultDuration() const {
			return items[id].decayTime * 1000;
		}
		bool canDecay() const;

		virtual bool canRemove() const {
			return true;
		}
		virtual bool canTransform() const {
			return true;
		}
		virtual void onRemoved();
		virtual void onTradeEvent(TradeEvents_t, Player*) {}

		virtual void startDecaying();
		virtual void stopDecaying();

		bool getLoadedFromMap() const {
			return loadedFromMap;
		}

		void setLoadedFromMap(bool value) {
			loadedFromMap = value;
		}
		bool isCleanable() const {
			return !loadedFromMap && canRemove() && isPickupable() && !hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) && !hasAttribute(ITEM_ATTRIBUTE_ACTIONID);
		}

		bool hasMarketAttributes();

		std::unique_ptr<ItemAttributes>& getAttributes() {
			if (!attributes) {
				attributes.reset(new ItemAttributes());
			}
			return attributes;
		}

		void incrementReferenceCounter() {
			++referenceCounter;
		}
		void decrementReferenceCounter() {
			if (--referenceCounter == 0) {
				delete this;
			}
		}

		Cylinder* getParent() const override {
			return parent;
		}
		void setParent(Cylinder* cylinder) override {
			parent = cylinder;
		}
		Cylinder* getTopParent();
		const Cylinder* getTopParent() const;
		Tile* getTile() override;
		const Tile* getTile() const override;
		bool isRemoved() const override {
			return !parent || parent->isRemoved();
		}

		bool isInsideDepot(bool includeInbox = false) const;

		/**
		 * @brief Get the Imbuement Info object
		 *
		 * @param slot
		 * @param imbuementInfo (Imbuement *imbuement, uint32_t duration = 0)
		 * @return true = duration is > 0 (info >> 8)
		 * @return false
		 */
		bool getImbuementInfo(uint8_t slot, ImbuementInfo *imbuementInfo);
		void addImbuement(uint8_t slot, uint16_t imbuementId, int32_t duration);
		/**
		 * @brief Decay imbuement time duration, only use this for decay the imbuement time
		 * 
		 * @param slot Slot id to decay
		 * @param imbuementId Imbuement id to decay
		 * @param duration New duration
		 */
		void decayImbuementTime(uint8_t slot, uint16_t imbuementId, int32_t duration) {
			return setImbuement(slot, imbuementId, duration);
		}
		void clearImbuement(uint8_t slot, uint16_t imbuementId) {
			return setImbuement(slot, imbuementId, 0);
		}
		bool hasImbuementType(ImbuementTypes_t imbuementType, uint16_t imbuementTier) {
			auto it = items[id].imbuementTypes.find(imbuementType);
			if (it != items[id].imbuementTypes.end()) {
				return (it->second >= imbuementTier);
			}
			return false;
		}
		bool hasImbuementCategoryId(uint16_t categoryId);
		bool hasImbuements() {
			for (uint8_t slotid = 0; slotid < getImbuementSlot(); slotid++) {
				ImbuementInfo imbuementInfo;
				if (getImbuementInfo(slotid, &imbuementInfo)) {
					return true;
				}
			}

			return false;
		}

		double_t getDodgeChance() const {
			if (getTier() == 0) {
				return 0;
			}
			return (0.0307576 * getTier() * getTier()) + (0.440697 * getTier()) + 0.026;
		}

		double_t getFatalChance() const {
			if (getTier() == 0) {
				return 0;
			}
			return 0.5 * getTier() + 0.05 * ((getTier() - 1) * (getTier() - 1));
		}

		double_t getMomentumChance() const {
			if (getTier() == 0) {
				return 0;
			}
			return 2 * getTier() + 0.05 * ((getTier() - 1) * (getTier() - 1));
		}

		uint8_t getTier() const {
			if (!hasAttribute(ITEM_ATTRIBUTE_TIER)) {
				return 0;
			}

			auto tier = static_cast<uint8_t>(getIntAttr(ITEM_ATTRIBUTE_TIER));
			if (tier > g_configManager().getNumber(FORGE_MAX_ITEM_TIER)) {
				SPDLOG_ERROR("{} - Item {} have a wrong tier {}", __FUNCTION__, getName(), tier);
				return 0;
			}

			return tier;
		}
		void setTier(uint8_t tier) {
			auto configTier = g_configManager().getNumber(FORGE_MAX_ITEM_TIER);
			if (tier > configTier) {
				SPDLOG_ERROR("{} - It is not possible to set a tier higher than {}", __FUNCTION__, configTier);
				return;
			}

			if (items[id].upgradeClassification) {
				setIntAttr(ITEM_ATTRIBUTE_TIER, tier);
			}
		}
		uint8_t getClassification() const {
			return items[id].upgradeClassification;
		}

	protected:
		std::string getWeightDescription(uint32_t weight) const;

		Cylinder* parent = nullptr;
		std::unique_ptr<ItemAttributes> attributes;

		uint32_t referenceCounter = 0;

		uint16_t id;  // the same id as in ItemType
		uint8_t count = 1; // number of stacked items

		bool loadedFromMap = false;
		bool isLootTrackeable = false;
	
	private:
		void setImbuement(uint8_t slot, uint16_t imbuementId, int32_t duration);
		//Don't add variables here, use the ItemAttribute class.
		friend class Decay;
};

using ItemList = std::list<Item*>;
using ItemDeque = std::deque<Item*>;
using StashContainerList = std::vector<std::pair<Item*, uint32_t>>;

#endif  // SRC_ITEMS_ITEM_H_
