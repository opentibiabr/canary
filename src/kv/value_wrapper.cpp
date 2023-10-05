#include "kv/value_wrapper.hpp"

ValueWrapper::ValueWrapper(uint64_t timestamp) :
	timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(const ValueVariant &value, uint64_t timestamp) :
	data_(value), timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(const std::string &value, uint64_t timestamp) :
	data_(value), timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(bool value, uint64_t timestamp) :
	data_(value), timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(int value, uint64_t timestamp) :
	data_(value), timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(double value, uint64_t timestamp) :
	data_(value), timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(const phmap::flat_hash_map<std::string, ValueWrapper> &value, uint64_t timestamp) :
	data_(createMapFromRange(value.begin(), value.end(), timestamp)),
	timestamp_(timestamp) { }

ValueWrapper::ValueWrapper(const std::initializer_list<std::pair<const std::string, ValueWrapper>> &init_list, uint64_t timestamp) :
	data_(createMapFromRange(init_list.begin(), init_list.end(), timestamp)),
	timestamp_(timestamp) { }

std::optional<ValueWrapper> ValueWrapper::get(const std::string &key) const {
	auto pval = std::get_if<MapType>(&data_);
	if (!pval) {
		return std::nullopt;
	}

	if (!pval->contains(key)) {
		return std::nullopt;
	}

	const auto &[_, valuePtr] = *pval->find(key);
	if (!valuePtr) {
		return std::nullopt;
	}

	return *valuePtr;
}

std::optional<ValueWrapper> ValueWrapper::get(size_t index) const {
	if (auto pval = std::get_if<ArrayType>(&data_)) {
		if (index < pval->size()) {
			return (*pval)[index];
		}
	}
	return std::nullopt;
}
