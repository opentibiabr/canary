/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "kv/value_wrapper_proto.hpp"

#include "kv/value_wrapper.hpp"

#include <kv.pb.h>

namespace ProtoHelpers {
	void setProtoStringValue(Canary::protobuf::kv::ValueWrapper &protoValue, const StringType &arg) {
		protoValue.set_str_value(arg);
	}

	void setProtoBooleanValue(Canary::protobuf::kv::ValueWrapper &protoValue, const BooleanType &arg) {
		protoValue.set_bool_value(arg);
	}

	void setProtoIntValue(Canary::protobuf::kv::ValueWrapper &protoValue, const IntType &arg) {
		protoValue.set_int_value(arg);
	}

	void setProtoDoubleValue(Canary::protobuf::kv::ValueWrapper &protoValue, const DoubleType &arg) {
		protoValue.set_double_value(arg);
	}

	void setProtoArrayValue(Canary::protobuf::kv::ValueWrapper &protoValue, const ArrayType &arg) {
		const auto arrayValue = protoValue.mutable_array_value();
		for (const auto &elem : arg) {
			*arrayValue->add_values() = ProtoSerializable::toProto(elem);
		}
	}

	void setProtoMapValue(Canary::protobuf::kv::ValueWrapper &protoValue, const MapType &arg) {
		const auto mapValue = protoValue.mutable_map_value();
		for (const auto &[key, value] : arg) {
			auto* elem = mapValue->add_items();
			elem->set_key(key);
			*elem->mutable_value() = ProtoSerializable::toProto(*value);
		}
	}
}

Canary::protobuf::kv::ValueWrapper ProtoSerializable::toProto(const ValueWrapper &obj) {
	Canary::protobuf::kv::ValueWrapper protoValue;

	std::visit(
		[&protoValue](const auto &arg) {
			using T = std::decay_t<decltype(arg)>;
			if constexpr (std::is_same_v<T, StringType>) {
				ProtoHelpers::setProtoStringValue(protoValue, arg);
			} else if constexpr (std::is_same_v<T, BooleanType>) {
				ProtoHelpers::setProtoBooleanValue(protoValue, arg);
			} else if constexpr (std::is_same_v<T, IntType>) {
				ProtoHelpers::setProtoIntValue(protoValue, arg);
			} else if constexpr (std::is_same_v<T, DoubleType>) {
				ProtoHelpers::setProtoDoubleValue(protoValue, arg);
			} else if constexpr (std::is_same_v<T, ArrayType>) {
				ProtoHelpers::setProtoArrayValue(protoValue, arg);
			} else if constexpr (std::is_same_v<T, MapType>) {
				ProtoHelpers::setProtoMapValue(protoValue, arg);
			}
		},
		obj.getVariant()
	);

	return protoValue;
}

ValueWrapper ProtoSerializable::fromProto(const Canary::protobuf::kv::ValueWrapper &protoValue, uint64_t timestamp) {
	ValueVariant data;
	switch (protoValue.value_case()) {
		case Canary::protobuf::kv::ValueWrapper::kStrValue:
			data = protoValue.str_value();
			break;
		case Canary::protobuf::kv::ValueWrapper::kBoolValue:
			data = protoValue.bool_value();
			break;
		case Canary::protobuf::kv::ValueWrapper::kIntValue:
			data = protoValue.int_value();
			break;
		case Canary::protobuf::kv::ValueWrapper::kDoubleValue:
			data = protoValue.double_value();
			break;
		case Canary::protobuf::kv::ValueWrapper::kArrayValue: {
			ArrayType array;
			for (const auto &protoElem : protoValue.array_value().values()) {
				array.emplace_back(fromProto(protoElem, timestamp));
			}
			data = array;
		} break;
		case Canary::protobuf::kv::ValueWrapper::kMapValue: {
			MapType map;
			for (const auto &protoElem : protoValue.map_value().items()) {
				map[protoElem.key()] = std::make_shared<ValueWrapper>(fromProto(protoElem.value(), timestamp));
			}
			data = map;
		} break;
		default:
			break;
	}
	return ValueWrapper(data, timestamp);
}
