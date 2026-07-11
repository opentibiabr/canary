#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
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
constexpr uint8_t OTBM_HOUSETILE = 14;

struct Context {
    uint8_t type = 0;
    int areaX = -1;
    int areaY = -1;
    int areaZ = -1;
};

struct Options {
    std::filesystem::path mapPath;
    std::filesystem::path outputDirectory;
    int originX = 31744;
    int originY = 30976;
    int width = 2560;
    int height = 2048;
};

int parseInteger(const std::string& value, const char* name) {
    size_t consumed = 0;
    const long long parsed = std::stoll(value, &consumed, 10);
    if (consumed != value.size() || parsed < std::numeric_limits<int>::min() || parsed > std::numeric_limits<int>::max()) {
        throw std::runtime_error(std::string("Invalid ") + name + ": " + value);
    }
    return static_cast<int>(parsed);
}

Options parseArguments(int argc, char** argv) {
    if (argc < 3) {
        throw std::runtime_error(
            "usage: otbm_reference_scan MAP OUTPUT_DIR [--origin-x X] [--origin-y Y] [--width W] [--height H]"
        );
    }
    Options options;
    options.mapPath = argv[1];
    options.outputDirectory = argv[2];
    for (int index = 3; index < argc; ++index) {
        const std::string argument = argv[index];
        if (index + 1 >= argc) {
            throw std::runtime_error("Missing value for " + argument);
        }
        const std::string value = argv[++index];
        if (argument == "--origin-x") {
            options.originX = parseInteger(value, "origin-x");
        } else if (argument == "--origin-y") {
            options.originY = parseInteger(value, "origin-y");
        } else if (argument == "--width") {
            options.width = parseInteger(value, "width");
        } else if (argument == "--height") {
            options.height = parseInteger(value, "height");
        } else {
            throw std::runtime_error("Unknown argument: " + argument);
        }
    }
    if (options.width <= 0 || options.height <= 0) {
        throw std::runtime_error("Reference width and height must be positive");
    }
    const uint64_t pixels = static_cast<uint64_t>(options.width) * static_cast<uint64_t>(options.height);
    if (pixels > 256ULL * 1024ULL * 1024ULL) {
        throw std::runtime_error("Reference grid exceeds 256 million positions");
    }
    return options;
}

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

std::array<uint8_t, 5> readAreaProperties(const std::vector<uint8_t>& data, size_t position) {
    std::array<uint8_t, 5> output{};
    size_t written = 0;
    while (position < data.size() && written < output.size()) {
        uint8_t value = data[position++];
        if (value == NODE_ESCAPE) {
            if (position >= data.size()) {
                throw std::runtime_error("Dangling OTBM escape byte");
            }
            value = data[position++];
        } else if (value == NODE_START || value == NODE_END) {
            throw std::runtime_error("Tile-area properties are shorter than expected");
        }
        output[written++] = value;
    }
    if (written != output.size()) {
        throw std::runtime_error("Truncated tile-area properties");
    }
    return output;
}

std::array<uint8_t, 2> readTileOffsets(const std::vector<uint8_t>& data, size_t position) {
    std::array<uint8_t, 2> output{};
    size_t written = 0;
    while (position < data.size() && written < output.size()) {
        uint8_t value = data[position++];
        if (value == NODE_ESCAPE) {
            if (position >= data.size()) {
                throw std::runtime_error("Dangling OTBM escape byte");
            }
            value = data[position++];
        } else if (value == NODE_START || value == NODE_END) {
            throw std::runtime_error("Tile properties are shorter than expected");
        }
        output[written++] = value;
    }
    if (written != output.size()) {
        throw std::runtime_error("Truncated tile offsets");
    }
    return output;
}

uint16_t readU16(const uint8_t low, const uint8_t high) {
    return static_cast<uint16_t>(low) | (static_cast<uint16_t>(high) << 8);
}

bool setBit(std::vector<uint8_t>& bits, const size_t index) {
    const size_t byteIndex = index >> 3;
    const uint8_t mask = static_cast<uint8_t>(1u << (index & 7));
    const bool duplicate = (bits[byteIndex] & mask) != 0;
    bits[byteIndex] |= mask;
    return duplicate;
}

std::string floorName(const int floor) {
    std::ostringstream stream;
    stream << "floor-" << std::setw(2) << std::setfill('0') << floor << ".bits";
    return stream.str();
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

} // namespace

int main(int argc, char** argv) {
    try {
        const Options options = parseArguments(argc, argv);
        std::filesystem::create_directories(options.outputDirectory);
        const auto data = readFile(options.mapPath);
        if (data.size() < 8) {
            throw std::runtime_error("OTBM file is too small");
        }

        const size_t pixels = static_cast<size_t>(options.width) * static_cast<size_t>(options.height);
        const size_t bitBytes = (pixels + 7) / 8;
        std::array<std::vector<uint8_t>, 16> occupancy;
        for (auto& floor : occupancy) {
            floor.assign(bitBytes, 0);
        }
        std::array<uint64_t, 16> floorCounts{};
        std::array<uint64_t, 16> inBoundsFloorCounts{};
        std::array<int, 16> minX;
        std::array<int, 16> minY;
        std::array<int, 16> maxX;
        std::array<int, 16> maxY;
        minX.fill(std::numeric_limits<int>::max());
        minY.fill(std::numeric_limits<int>::max());
        maxX.fill(std::numeric_limits<int>::min());
        maxY.fill(std::numeric_limits<int>::min());

        uint64_t totalTiles = 0;
        uint64_t inBoundsTiles = 0;
        uint64_t duplicatePositions = 0;
        uint64_t tileAreaNodes = 0;
        std::vector<Context> stack;
        stack.reserve(32);

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
                if (nodeType == OTBM_TILE_AREA && parent && parent->type == OTBM_MAP_DATA) {
                    const auto props = readAreaProperties(data, position + 2);
                    context.areaX = readU16(props[0], props[1]);
                    context.areaY = readU16(props[2], props[3]);
                    context.areaZ = props[4];
                    ++tileAreaNodes;
                } else if ((nodeType == OTBM_TILE || nodeType == OTBM_HOUSETILE) && parent && parent->type == OTBM_TILE_AREA) {
                    const auto offsets = readTileOffsets(data, position + 2);
                    const int x = parent->areaX + offsets[0];
                    const int y = parent->areaY + offsets[1];
                    const int z = parent->areaZ;
                    ++totalTiles;
                    if (z >= 0 && z < 16) {
                        ++floorCounts[z];
                        minX[z] = std::min(minX[z], x);
                        minY[z] = std::min(minY[z], y);
                        maxX[z] = std::max(maxX[z], x);
                        maxY[z] = std::max(maxY[z], y);
                        if (
                            x >= options.originX && x < options.originX + options.width &&
                            y >= options.originY && y < options.originY + options.height
                        ) {
                            const size_t index = static_cast<size_t>(y - options.originY) * static_cast<size_t>(options.width)
                                + static_cast<size_t>(x - options.originX);
                            if (setBit(occupancy[z], index)) {
                                ++duplicatePositions;
                            } else {
                                ++inBoundsTiles;
                                ++inBoundsFloorCounts[z];
                            }
                        }
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

        for (int floor = 0; floor < 16; ++floor) {
            std::ofstream output(options.outputDirectory / floorName(floor), std::ios::binary);
            if (!output) {
                throw std::runtime_error("Cannot create occupancy bitset");
            }
            output.write(reinterpret_cast<const char*>(occupancy[floor].data()), static_cast<std::streamsize>(occupancy[floor].size()));
            if (!output) {
                throw std::runtime_error("Cannot write occupancy bitset");
            }
        }

        std::ofstream json(options.outputDirectory / "occupancy.json");
        if (!json) {
            throw std::runtime_error("Cannot create occupancy manifest");
        }
        json << "{\n"
             << "  \"format\": \"canary-otbm-occupancy-v1\",\n"
             << "  \"source\": {\"path\": \"" << jsonEscape(options.mapPath.filename().string()) << "\", \"size\": " << data.size() << "},\n"
             << "  \"origin\": [" << options.originX << ", " << options.originY << "],\n"
             << "  \"width\": " << options.width << ",\n"
             << "  \"height\": " << options.height << ",\n"
             << "  \"tileAreaNodes\": " << tileAreaNodes << ",\n"
             << "  \"totalTiles\": " << totalTiles << ",\n"
             << "  \"inReferenceBoundsTiles\": " << inBoundsTiles << ",\n"
             << "  \"duplicateReferencePositions\": " << duplicatePositions << ",\n"
             << "  \"floors\": [\n";
        for (int floor = 0; floor < 16; ++floor) {
            json << "    {\"z\": " << floor
                 << ", \"tileCount\": " << floorCounts[floor]
                 << ", \"inReferenceBoundsTiles\": " << inBoundsFloorCounts[floor]
                 << ", \"occupancyFile\": \"" << floorName(floor) << "\"";
            if (floorCounts[floor] > 0) {
                json << ", \"bounds\": [[" << minX[floor] << ", " << minY[floor] << "], ["
                     << maxX[floor] << ", " << maxY[floor] << "]]";
            } else {
                json << ", \"bounds\": null";
            }
            json << "}" << (floor == 15 ? "\n" : ",\n");
        }
        json << "  ]\n}\n";
        std::cout << "totalTiles=" << totalTiles
                  << " inBounds=" << inBoundsTiles
                  << " duplicates=" << duplicatePositions << "\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "error: " << error.what() << "\n";
        return 1;
    }
}
