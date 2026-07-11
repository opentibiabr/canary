#include <array>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <vector>

namespace {
constexpr uint8_t NODE_ESCAPE = 0xFD;
constexpr uint8_t NODE_START = 0xFE;
constexpr uint8_t NODE_END = 0xFF;
constexpr uint8_t OTBM_MAP_DATA = 2;
constexpr uint8_t OTBM_TILE_AREA = 4;
constexpr uint8_t OTBM_TILE = 5;
constexpr uint8_t OTBM_ITEM = 6;
constexpr uint8_t OTBM_HOUSETILE = 14;

constexpr uint8_t ATTR_TILE_FLAGS = 3;
constexpr uint8_t ATTR_ACTION_ID = 4;
constexpr uint8_t ATTR_UNIQUE_ID = 5;
constexpr uint8_t ATTR_TEXT = 6;
constexpr uint8_t ATTR_DESC = 7;
constexpr uint8_t ATTR_TELE_DEST = 8;
constexpr uint8_t ATTR_ITEM = 9;
constexpr uint8_t ATTR_DEPOT_ID = 10;
constexpr uint8_t ATTR_RUNE_CHARGES = 12;
constexpr uint8_t ATTR_HOUSEDOOR_ID = 14;
constexpr uint8_t ATTR_COUNT = 15;
constexpr uint8_t ATTR_DURATION = 16;
constexpr uint8_t ATTR_DECAYING_STATE = 17;
constexpr uint8_t ATTR_WRITTEN_DATE = 18;
constexpr uint8_t ATTR_WRITTEN_BY = 19;
constexpr uint8_t ATTR_SLEEPER_GUID = 20;
constexpr uint8_t ATTR_SLEEP_START = 21;
constexpr uint8_t ATTR_CHARGES = 22;
constexpr size_t ATTRIBUTE_LIMIT = 32;

struct Context {
    uint8_t type = 0;
    int areaX = -1;
    int areaY = -1;
    int areaZ = -1;
    int tileX = -1;
    int tileY = -1;
    int tileZ = -1;
    int itemDepth = -1;
};

struct ItemStats {
    uint64_t placements = 0;
    uint64_t inlinePlacements = 0;
    uint64_t nodePlacements = 0;
    std::array<uint64_t, ATTRIBUTE_LIMIT> attributes{};
};

struct MechanicPlacement {
    uint16_t itemId = 0;
    int x = -1;
    int y = -1;
    int z = -1;
    int depth = -1;
    std::optional<uint16_t> actionId;
    std::optional<uint16_t> uniqueId;
    std::optional<uint8_t> houseDoorId;
    std::optional<std::array<uint16_t, 3>> teleportDestination;
};

class PropertyReader {
public:
    PropertyReader(const std::vector<uint8_t>& data, size_t position) : data_(data), position_(position) {}

    bool hasMore() const {
        if (position_ >= data_.size()) {
            return false;
        }
        const uint8_t value = data_[position_];
        return value != NODE_START && value != NODE_END;
    }

    uint8_t readByte() {
        requireMore("byte");
        uint8_t value = data_[position_++];
        if (value == NODE_ESCAPE) {
            if (position_ >= data_.size()) {
                throw std::runtime_error("Dangling OTBM escape byte");
            }
            value = data_[position_++];
        } else if (value == NODE_START || value == NODE_END) {
            throw std::runtime_error("Unexpected OTBM node marker inside properties");
        }
        return value;
    }

    uint16_t readU16() {
        const uint16_t low = readByte();
        return static_cast<uint16_t>(low | (static_cast<uint16_t>(readByte()) << 8));
    }

    uint32_t readU32() {
        uint32_t value = 0;
        for (int shift = 0; shift < 32; shift += 8) {
            value |= static_cast<uint32_t>(readByte()) << shift;
        }
        return value;
    }

    void skipBytes(const size_t count) {
        for (size_t index = 0; index < count; ++index) {
            static_cast<void>(readByte());
        }
    }

    void skipString() {
        skipBytes(readU16());
    }

private:
    void requireMore(const char* what) const {
        if (!hasMore()) {
            throw std::runtime_error(std::string("Truncated OTBM properties while reading ") + what);
        }
    }

    const std::vector<uint8_t>& data_;
    size_t position_;
};

std::vector<uint8_t> readFile(const std::filesystem::path& path) {
    std::ifstream input(path, std::ios::binary);
    if (!input) {
        throw std::runtime_error("Cannot open input map: " + path.string());
    }
    input.seekg(0, std::ios::end);
    const auto size = input.tellg();
    if (size < 0) {
        throw std::runtime_error("Cannot determine map size");
    }
    input.seekg(0, std::ios::beg);
    std::vector<uint8_t> data(static_cast<size_t>(size));
    input.read(reinterpret_cast<char*>(data.data()), size);
    if (!input) {
        throw std::runtime_error("Cannot read input map");
    }
    return data;
}

bool skipAttributePayload(PropertyReader& reader, const uint8_t attribute) {
    switch (attribute) {
        case ATTR_ACTION_ID:
        case ATTR_UNIQUE_ID:
        case ATTR_DEPOT_ID:
        case ATTR_CHARGES:
            reader.skipBytes(2);
            return true;
        case ATTR_TELE_DEST:
            reader.skipBytes(5);
            return true;
        case ATTR_RUNE_CHARGES:
        case ATTR_HOUSEDOOR_ID:
        case ATTR_COUNT:
        case ATTR_DECAYING_STATE:
            reader.skipBytes(1);
            return true;
        case ATTR_DURATION:
        case ATTR_WRITTEN_DATE:
        case ATTR_SLEEPER_GUID:
        case ATTR_SLEEP_START:
            reader.skipBytes(4);
            return true;
        case ATTR_TEXT:
        case ATTR_DESC:
        case ATTR_WRITTEN_BY:
            reader.skipString();
            return true;
        default:
            return false;
    }
}

std::string jsonEscape(const std::string& value) {
    std::ostringstream stream;
    for (const unsigned char character : value) {
        switch (character) {
            case '\\': stream << "\\\\"; break;
            case '"': stream << "\\\""; break;
            case '\b': stream << "\\b"; break;
            case '\f': stream << "\\f"; break;
            case '\n': stream << "\\n"; break;
            case '\r': stream << "\\r"; break;
            case '\t': stream << "\\t"; break;
            default:
                if (character < 0x20) {
                    stream << "\\u" << std::hex << std::setw(4) << std::setfill('0')
                           << static_cast<int>(character) << std::dec << std::setfill(' ');
                } else {
                    stream << static_cast<char>(character);
                }
        }
    }
    return stream.str();
}

void parseItemAttributes(
    PropertyReader& reader,
    ItemStats& stats,
    MechanicPlacement& placement,
    uint64_t& unknownAttributeTails,
    std::array<uint64_t, 256>& unknownAttributeTypes
) {
    while (reader.hasMore()) {
        const uint8_t attribute = reader.readByte();
        if (attribute < stats.attributes.size()) {
            ++stats.attributes[attribute];
        }
        switch (attribute) {
            case ATTR_ACTION_ID:
                placement.actionId = reader.readU16();
                break;
            case ATTR_UNIQUE_ID:
                placement.uniqueId = reader.readU16();
                break;
            case ATTR_TELE_DEST: {
                const uint16_t x = reader.readU16();
                const uint16_t y = reader.readU16();
                const uint16_t z = reader.readByte();
                placement.teleportDestination = std::array<uint16_t, 3>{x, y, z};
                break;
            }
            case ATTR_HOUSEDOOR_ID:
                placement.houseDoorId = reader.readByte();
                break;
            default:
                if (!skipAttributePayload(reader, attribute)) {
                    ++unknownAttributeTails;
                    ++unknownAttributeTypes[attribute];
                    return;
                }
        }
    }
}

bool hasMechanic(const MechanicPlacement& placement) {
    return placement.actionId.has_value() || placement.uniqueId.has_value()
        || placement.teleportDestination.has_value() || placement.houseDoorId.has_value();
}

} // namespace

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "usage: otbm_item_audit_scan MAP OUTPUT.json\n";
        return 2;
    }
    try {
        const std::filesystem::path mapPath = argv[1];
        const std::filesystem::path outputPath = argv[2];
        const auto data = readFile(mapPath);
        if (data.size() < 8) {
            throw std::runtime_error("OTBM file is too small");
        }

        std::vector<ItemStats> items(65536);
        std::array<uint64_t, 256> unknownAttributeTypes{};
        std::vector<MechanicPlacement> mechanics;
        mechanics.reserve(4096);
        std::vector<Context> stack;
        stack.reserve(64);
        uint64_t tileCount = 0;
        uint64_t totalPlacements = 0;
        uint64_t inlinePlacements = 0;
        uint64_t nodePlacements = 0;
        uint64_t unknownAttributeTails = 0;

        size_t position = 4;
        while (position < data.size()) {
            const uint8_t value = data[position];
            if (value == NODE_ESCAPE) {
                if (position + 1 >= data.size()) {
                    throw std::runtime_error("Dangling OTBM escape byte");
                }
                position += 2;
                continue;
            }
            if (value == NODE_START) {
                if (position + 1 >= data.size()) {
                    throw std::runtime_error("OTBM node has no type");
                }
                const uint8_t nodeType = data[position + 1];
                const Context* parent = stack.empty() ? nullptr : &stack.back();
                Context context;
                context.type = nodeType;
                if (parent) {
                    context.areaX = parent->areaX;
                    context.areaY = parent->areaY;
                    context.areaZ = parent->areaZ;
                    context.tileX = parent->tileX;
                    context.tileY = parent->tileY;
                    context.tileZ = parent->tileZ;
                    context.itemDepth = parent->itemDepth;
                }

                if (nodeType == OTBM_TILE_AREA && parent && parent->type == OTBM_MAP_DATA) {
                    PropertyReader reader(data, position + 2);
                    context.areaX = reader.readU16();
                    context.areaY = reader.readU16();
                    context.areaZ = reader.readByte();
                } else if ((nodeType == OTBM_TILE || nodeType == OTBM_HOUSETILE) && parent && parent->type == OTBM_TILE_AREA) {
                    PropertyReader reader(data, position + 2);
                    context.tileX = parent->areaX + reader.readByte();
                    context.tileY = parent->areaY + reader.readByte();
                    context.tileZ = parent->areaZ;
                    context.itemDepth = -1;
                    ++tileCount;
                    if (nodeType == OTBM_HOUSETILE) {
                        static_cast<void>(reader.readU32());
                    }
                    while (reader.hasMore()) {
                        const uint8_t attribute = reader.readByte();
                        if (attribute == ATTR_TILE_FLAGS) {
                            static_cast<void>(reader.readU32());
                        } else if (attribute == ATTR_ITEM) {
                            const uint16_t itemId = reader.readU16();
                            ItemStats& stats = items[itemId];
                            ++stats.placements;
                            ++stats.inlinePlacements;
                            ++inlinePlacements;
                            ++totalPlacements;
                        } else {
                            throw std::runtime_error("Unsupported tile attribute " + std::to_string(attribute));
                        }
                    }
                } else if (nodeType == OTBM_ITEM) {
                    if (!parent || parent->tileX < 0 || parent->tileY < 0 || parent->tileZ < 0) {
                        throw std::runtime_error("Item node is outside a tile");
                    }
                    PropertyReader reader(data, position + 2);
                    const uint16_t itemId = reader.readU16();
                    context.itemDepth = parent->type == OTBM_ITEM ? parent->itemDepth + 1 : 0;
                    ItemStats& stats = items[itemId];
                    ++stats.placements;
                    ++stats.nodePlacements;
                    ++nodePlacements;
                    ++totalPlacements;
                    MechanicPlacement placement;
                    placement.itemId = itemId;
                    placement.x = parent->tileX;
                    placement.y = parent->tileY;
                    placement.z = parent->tileZ;
                    placement.depth = context.itemDepth;
                    parseItemAttributes(reader, stats, placement, unknownAttributeTails, unknownAttributeTypes);
                    if (hasMechanic(placement)) {
                        mechanics.push_back(placement);
                    }
                }
                stack.push_back(context);
                position += 2;
                continue;
            }
            if (value == NODE_END) {
                if (stack.empty()) {
                    throw std::runtime_error("Unexpected OTBM node end");
                }
                stack.pop_back();
                ++position;
                continue;
            }
            ++position;
        }
        if (!stack.empty()) {
            throw std::runtime_error("OTBM contains unterminated nodes");
        }

        size_t uniqueItemIds = 0;
        for (const auto& item : items) {
            if (item.placements > 0) {
                ++uniqueItemIds;
            }
        }

        std::filesystem::create_directories(outputPath.parent_path().empty() ? std::filesystem::path(".") : outputPath.parent_path());
        std::ofstream out(outputPath);
        if (!out) {
            throw std::runtime_error("Cannot create output report");
        }
        out << "{\n"
            << "  \"format\": \"canary-otbm-item-scan-v1\",\n"
            << "  \"source\": {\"path\": \"" << jsonEscape(mapPath.filename().string()) << "\", \"size\": " << data.size() << "},\n"
            << "  \"tileCount\": " << tileCount << ",\n"
            << "  \"totalPlacements\": " << totalPlacements << ",\n"
            << "  \"inlinePlacements\": " << inlinePlacements << ",\n"
            << "  \"itemNodePlacements\": " << nodePlacements << ",\n"
            << "  \"uniqueItemIds\": " << uniqueItemIds << ",\n"
            << "  \"unknownAttributeTails\": " << unknownAttributeTails << ",\n"
            << "  \"unknownAttributeTypes\": {";
        bool firstUnknown = true;
        for (size_t type = 0; type < unknownAttributeTypes.size(); ++type) {
            if (unknownAttributeTypes[type] == 0) {
                continue;
            }
            if (!firstUnknown) {
                out << ", ";
            }
            firstUnknown = false;
            out << "\"" << type << "\": " << unknownAttributeTypes[type];
        }
        out << "},\n  \"items\": [\n";
        bool firstItem = true;
        for (size_t itemId = 0; itemId < items.size(); ++itemId) {
            const ItemStats& stats = items[itemId];
            if (stats.placements == 0) {
                continue;
            }
            if (!firstItem) {
                out << ",\n";
            }
            firstItem = false;
            out << "    {\"id\": " << itemId
                << ", \"placements\": " << stats.placements
                << ", \"inlinePlacements\": " << stats.inlinePlacements
                << ", \"itemNodePlacements\": " << stats.nodePlacements
                << ", \"attributes\": {";
            bool firstAttribute = true;
            for (size_t attribute = 0; attribute < stats.attributes.size(); ++attribute) {
                if (stats.attributes[attribute] == 0) {
                    continue;
                }
                if (!firstAttribute) {
                    out << ", ";
                }
                firstAttribute = false;
                out << "\"" << attribute << "\": " << stats.attributes[attribute];
            }
            out << "}}";
        }
        out << "\n  ],\n  \"mechanicPlacements\": [\n";
        for (size_t index = 0; index < mechanics.size(); ++index) {
            const auto& placement = mechanics[index];
            out << "    {\"itemId\": " << placement.itemId
                << ", \"position\": [" << placement.x << ", " << placement.y << ", " << placement.z << "]"
                << ", \"itemDepth\": " << placement.depth;
            if (placement.actionId) {
                out << ", \"actionId\": " << *placement.actionId;
            }
            if (placement.uniqueId) {
                out << ", \"uniqueId\": " << *placement.uniqueId;
            }
            if (placement.houseDoorId) {
                out << ", \"houseDoorId\": " << static_cast<int>(*placement.houseDoorId);
            }
            if (placement.teleportDestination) {
                out << ", \"teleportDestination\": ["
                    << (*placement.teleportDestination)[0] << ", "
                    << (*placement.teleportDestination)[1] << ", "
                    << (*placement.teleportDestination)[2] << "]";
            }
            out << "}" << (index + 1 == mechanics.size() ? "\n" : ",\n");
        }
        out << "  ]\n}\n";
        std::cout << "tiles=" << tileCount << " placements=" << totalPlacements
                  << " unique=" << uniqueItemIds << " mechanics=" << mechanics.size() << "\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "error: " << error.what() << "\n";
        return 1;
    }
}
