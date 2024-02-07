//
// Created by lgrossi on 27-8-23.
//

#pragma once

#include <boost/ut.hpp>

#include "account/in_memory_account_repository.hpp"
#include "kv/in_memory_kv.hpp"
#include "test_injection.hpp"
#include "lib/logging/in_memory_logger.hpp"

using namespace boost::ut;

struct InjectionFixture {
	di::extension::injector<> injector {};

	InjectionFixture() {
		setup();
	}

	InjectionFixture(const InjectionFixture &) {
		setup();
	}

	InjectionFixture(InjectionFixture &&other) noexcept
		:
		injector(std::move(other.injector)) {
		setup();
	}

	template <typename... Is>
	auto get() const {
		return std::tuple<typename TestInjection<Is>::type &...>(getImpl<Is>()...);
	}

	InMemoryLogger &logger() const {
		return getImpl<Logger>();
	}

	tests::InMemoryAccountRepository &accountRepository() const {
		return getImpl<AccountRepository>();
	}

	KVMemory &kv() const {
		return getImpl<KVStore>();
	}

private:
	template <typename I>
	typename TestInjection<I>::type &getImpl() const {
		return dynamic_cast<typename TestInjection<I>::type &>(injector.create<I &>()).reset();
	}

	void setup() {
		InMemoryLogger::install(injector);
		tests::InMemoryAccountRepository::install(injector);
		KVMemory::install(injector);

		DI::setTestContainer(&injector);
	}
};

namespace std {
	template <>
	struct tuple_size<InjectionFixture> : std::integral_constant<std::size_t, 2> { };

	template <std::size_t N>
	struct tuple_element<N, InjectionFixture> {
		using type = decltype(std::declval<InjectionFixture>().get<N>());
	};
}
