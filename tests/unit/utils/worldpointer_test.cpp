/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2026 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/worldpointer.hpp"

#include <atomic>
#include <shared_mutex>
#include <thread>
#include <vector>

namespace {

	// NOSONAR(cpp:S4963) — RAII destructor is the test instrumentation:
	// liveCount drives lifecycle assertions. Rule of Zero doesn't apply.
	struct Probe {
		int value;

		explicit Probe(int v) :
			value(v) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}

		~Probe() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		Probe(const Probe &) = delete;
		Probe &operator=(const Probe &) = delete;

		static inline std::atomic<int> liveCount { 0 };
	};

	using ProbeAlloc = WorldPtr<Probe>::DefaultAllocator;
	using Owning = WorldPtr<Probe>::Owning<ProbeAlloc>;
	using Shared = WorldPtr<Probe>::Shared<ProbeAlloc>;
	using Borrowed = WorldPtr<Probe>::Borrowed<ProbeAlloc>;

	// Standard-layout probe with wider alignment to exercise the offsetof
	// trick on padding between Block header and value.
	// NOSONAR(cpp:S4963) — see Probe rationale.
	struct alignas(64) WideProbe {
		int value;

		explicit WideProbe(int v) :
			value(v) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}

		~WideProbe() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		WideProbe(const WideProbe &) = delete;
		WideProbe &operator=(const WideProbe &) = delete;

		static inline std::atomic<int> liveCount { 0 };
	};

	using WideAlloc = WorldPtr<WideProbe>::DefaultAllocator;
	using WideOwning = WorldPtr<WideProbe>::Owning<WideAlloc>;

	// Walks the per-(T, Allocator) retiree list directly. Internal helper
	// used by tests that want to assert deferral semantics; not exposed
	// from the worldpointer API.
	size_t pendingQBSR() {
		size_t count = 0;
		for (auto it = WorldPtr<Probe>::BlockAllocator<ProbeAlloc>::retirees;
		     it != nullptr;
		     it = static_cast<WorldPtr<Probe>::Block*>(it->next)) {
			++count;
		}
		return count;
	}

	class WorldPointerTest : public ::testing::Test {
	protected:
		void SetUp() override {
			// Drain anything pending so liveCount starts clean.
			WorldPtr<Probe>::quiescentState<ProbeAlloc>();
			WorldPtr<WideProbe>::quiescentState<WideAlloc>();
			Probe::liveCount.store(0, std::memory_order_relaxed);
			WideProbe::liveCount.store(0, std::memory_order_relaxed);
		}

		void TearDown() override {
			WorldPtr<Probe>::quiescentState<ProbeAlloc>();
			WorldPtr<WideProbe>::quiescentState<WideAlloc>();
		}
	};

	// --- Owning -----------------------------------------------------------

	TEST_F(WorldPointerTest, Owning_DefaultConstructed_IsNull) {
		Owning p;
		EXPECT_FALSE(static_cast<bool>(p));
		EXPECT_EQ(nullptr, p.get());
		EXPECT_TRUE(p == nullptr);
		EXPECT_FALSE(p != nullptr);
	}

	TEST_F(WorldPointerTest, Owning_NullptrConstructor_ProducesEmpty) {
		Owning p(nullptr);
		EXPECT_FALSE(static_cast<bool>(p));
	}

	TEST_F(WorldPointerTest, Owning_Make_ConstructsInPlace) {
		auto wp = Owning::make(42);
		ASSERT_TRUE(static_cast<bool>(wp));
		EXPECT_EQ(42, wp->value);
		EXPECT_EQ(1, Probe::liveCount.load());

		auto sp = wp.share();
		EXPECT_EQ(2u, sp.useCount());
		EXPECT_EQ(wp.get(), sp.get());
	}

	TEST_F(WorldPointerTest, Owning_MoveCtor_NoRefCountOps) {
		auto a = Owning::make(7);
		auto sp = a.share();
		const size_t countAfterEnter = sp.useCount();

		Owning b = std::move(a);

		EXPECT_EQ(countAfterEnter, sp.useCount());
		EXPECT_FALSE(static_cast<bool>(a));
		ASSERT_TRUE(static_cast<bool>(b));
		EXPECT_EQ(7, b->value);
	}

	TEST_F(WorldPointerTest, Owning_ChainedMoves_ZeroBumps) {
		auto a = Owning::make(77);
		auto sp = a.share();
		const size_t countAfterEnter = sp.useCount();
		ASSERT_EQ(countAfterEnter, 2u);

		Owning b = std::move(a);
		Owning c = std::move(b);
		Owning d = std::move(c);

		EXPECT_EQ(countAfterEnter, sp.useCount());
		ASSERT_TRUE(static_cast<bool>(d));
		EXPECT_EQ(77, d->value);
	}

	TEST_F(WorldPointerTest, Owning_MoveAssign_DefersOldAndAdoptsNew) {
		auto a = Owning::make(1);
		auto b = Owning::make(2);
		ASSERT_EQ(2, Probe::liveCount.load());

		const size_t pendingBefore = pendingQBSR();
		b = std::move(a);

		EXPECT_EQ(pendingBefore + 1, pendingQBSR());
		ASSERT_TRUE(static_cast<bool>(b));
		EXPECT_EQ(1, b->value);
		EXPECT_FALSE(static_cast<bool>(a));
		EXPECT_EQ(2, Probe::liveCount.load());

		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(1, Probe::liveCount.load());
	}

	TEST_F(WorldPointerTest, Owning_Destructor_DefersDropToQSBR) {
		const size_t pendingBefore = pendingQBSR();
		{
			auto wp = Owning::make(99);
			EXPECT_EQ(1, Probe::liveCount.load());
			EXPECT_EQ(pendingBefore, pendingQBSR());
		}
		EXPECT_EQ(pendingBefore + 1, pendingQBSR());
		EXPECT_EQ(1, Probe::liveCount.load());

		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0, Probe::liveCount.load());
		EXPECT_EQ(pendingBefore, pendingQBSR());
	}

	TEST_F(WorldPointerTest, Owning_Reset_DefersDrop) {
		auto wp = Owning::make(5);
		const size_t pendingBefore = pendingQBSR();

		wp.reset();
		EXPECT_FALSE(static_cast<bool>(wp));
		EXPECT_EQ(pendingBefore + 1, pendingQBSR());
		EXPECT_EQ(1, Probe::liveCount.load());

		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	TEST_F(WorldPointerTest, Owning_NullptrAssign_ResetsCleanly) {
		auto wp = Owning::make(3);
		wp = nullptr;
		EXPECT_FALSE(static_cast<bool>(wp));
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	TEST_F(WorldPointerTest, Owning_AffineEquality_ByPointee) {
		auto a = Owning::make(1);
		auto b = Owning::make(2);
		EXPECT_NE(a, b);
		EXPECT_EQ(a, a);

		EXPECT_NE(a, nullptr);
		EXPECT_NE(b, nullptr);

		auto c = std::move(b);
		EXPECT_EQ(b, nullptr);
		EXPECT_NE(b, c);
		EXPECT_EQ(c, c);
	}

	// --- Borrowed ---------------------------------------------------------

	TEST_F(WorldPointerTest, Borrowed_FromOwning_NoRefCountChange) {
		auto wp = Owning::make(20);
		auto sp = wp.share();
		const size_t countAfter = sp.useCount();

		Borrowed view = wp.borrow();

		EXPECT_EQ(countAfter, sp.useCount());
		ASSERT_TRUE(static_cast<bool>(view));
		EXPECT_EQ(sp.get(), view.get());
		EXPECT_EQ(20, view->value);

		// Repeated copy/access stays zero-refcount.
		int sum = 0;
		for (int i = 0; i < 1000; ++i) {
			Borrowed copy = view;
			sum += copy->value;
		}
		EXPECT_EQ(20 * 1000, sum);
		EXPECT_EQ(countAfter, sp.useCount());
	}

	TEST_F(WorldPointerTest, Borrowed_ToShared_BumpsRefCount) {
		auto wp = Owning::make(10);
		auto sp = wp.share();
		const size_t countAfterEnter = sp.useCount();
		Borrowed view = wp.borrow();

		Shared escaped = view;

		EXPECT_EQ(countAfterEnter + 1, sp.useCount())
			<< "Boundary materialisation must bump the existing block.";
		EXPECT_EQ(sp.get(), escaped.get());
	}

	TEST_F(WorldPointerTest, Borrowed_ToShared_ExtendsLifetimePastOwnerDrop) {
		Shared escaped;
		{
			auto owner = Owning::make(11);
			Borrowed view = owner.borrow();
			escaped = view;
		}
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();

		ASSERT_TRUE(static_cast<bool>(escaped));
		EXPECT_EQ(11, escaped->value);
		EXPECT_EQ(1, Probe::liveCount.load());

		escaped = nullptr;
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	// --- Shared -----------------------------------------------------------

	TEST_F(WorldPointerTest, Shared_DefaultIsNull) {
		Shared s;
		EXPECT_FALSE(static_cast<bool>(s));
	}

	TEST_F(WorldPointerTest, Shared_Copy_BumpsRefCount) {
		auto owner = Owning::make(7);
		Shared a = owner;
		EXPECT_EQ(2u, a.useCount());

		{
			Shared b = a;
			EXPECT_EQ(3u, a.useCount());
			EXPECT_EQ(3u, b.useCount());
		}
		EXPECT_EQ(2u, a.useCount());
	}

	TEST_F(WorldPointerTest, Shared_ExtendsLifetimePastOwnerRetire) {
		Shared s;
		{
			auto owner = Owning::make(33);
			s = owner;
		}
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();

		ASSERT_TRUE(static_cast<bool>(s));
		EXPECT_EQ(33, s->value);
		EXPECT_EQ(1, Probe::liveCount.load());

		s = nullptr;
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	// --- Wider alignment --------------------------------------------------

	TEST_F(WorldPointerTest, OffsetofTrick_WorksForOverAlignedT) {
		auto wp = WideOwning::make(123);
		ASSERT_EQ(1, WideProbe::liveCount.load());
		EXPECT_EQ(123, wp->value);
		wp = nullptr;
		WorldPtr<WideProbe>::quiescentState<WideAlloc>();
		EXPECT_EQ(0, WideProbe::liveCount.load());
	}

	// --- QSBR semantics ---------------------------------------------------

	TEST_F(WorldPointerTest, QSBR_RetireDoesNotDestroyImmediately) {
		{
			auto a = Owning::make(1);
			auto b = Owning::make(2);
			auto c = Owning::make(3);
		}
		EXPECT_EQ(3u, pendingQBSR());
		EXPECT_EQ(3, Probe::liveCount.load());

		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0u, pendingQBSR());
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	TEST_F(WorldPointerTest, QSBR_QuiescentStateIsIdempotent) {
		{ auto wp = Owning::make(7); }
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0, Probe::liveCount.load());
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	// =====================================================================
	// PolyPtr<T> — polymorphic hierarchy variant
	// =====================================================================

	// Single-inheritance probe.
	// NOSONAR(cpp:S4963) — see Probe rationale.
	struct PolyBase {
		int base_value;

		static inline std::atomic<int> liveCount { 0 };

		explicit PolyBase(int v) :
			base_value(v) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}

		PolyBase(const PolyBase &) = delete;
		PolyBase &operator=(const PolyBase &) = delete;

		virtual ~PolyBase() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		virtual int compute() const {
			return base_value;
		}
	};

	// NOSONAR(cpp:S4963) — see Probe rationale.
	struct PolyDerived : public PolyBase {
		int derived_value;

		static inline std::atomic<int> derivedLiveCount { 0 };

		PolyDerived(int b, int d) :
			PolyBase(b), derived_value(d) {
			derivedLiveCount.fetch_add(1, std::memory_order_relaxed);
		}

		~PolyDerived() override {
			derivedLiveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		int compute() const override {
			return base_value + derived_value;
		}
	};

	// Abstract base, to verify that `make` is disabled for it and that
	// `make_poly<Concrete>()` is the way in.
	struct PolyAbstract {
		virtual ~PolyAbstract() = default;
		virtual int kind() const = 0;
	};

	// NOSONAR(cpp:S3624,cpp:S4963) — destructor and deleted copy ops are
	// instrumentation; Rule of Zero doesn't apply.
	struct PolyAbstractImpl final : public PolyAbstract {
		int v;

		static inline std::atomic<int> liveCount { 0 };

		explicit PolyAbstractImpl(int x) :
			v(x) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}

		~PolyAbstractImpl() override {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		int kind() const override {
			return v * 2;
		}
	};

	// Diamond with virtual inheritance — exercises the static_cast adjustment
	// that the intrusive WorldPtr<T> design cannot do via offsetof.
	// NOSONAR(cpp:S4963) — see Probe rationale.
	struct VirtBase {
		static inline std::atomic<int> liveCount { 0 };

		VirtBase() {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}

		VirtBase(const VirtBase &) = delete;
		VirtBase &operator=(const VirtBase &) = delete;

		virtual ~VirtBase() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		virtual int kind() const = 0;
	};

	struct VirtMid1 : virtual VirtBase {
		int x;

		explicit VirtMid1(int v) :
			x(v) { }
	};

	struct VirtMid2 : virtual VirtBase {
		int y;

		explicit VirtMid2(int v) :
			y(v) { }
	};

	struct VirtDiamond final : public VirtMid1, public VirtMid2 {
		static inline std::atomic<int> diamondLiveCount { 0 };

		VirtDiamond(int a, int b) :
			VirtMid1(a), VirtMid2(b) {
			diamondLiveCount.fetch_add(1, std::memory_order_relaxed);
		}

		~VirtDiamond() override {
			diamondLiveCount.fetch_sub(1, std::memory_order_relaxed);
		}

		int kind() const override {
			return x + y;
		}
	};

	size_t pendingPolyQBSR() {
		size_t count = 0;
		for (auto* it = world_ptr_poly_detail::g_retirees.load(std::memory_order_acquire);
		     it != nullptr;
		     it = it->next) {
			++count;
		}
		return count;
	}

	class PolyPointerTest : public ::testing::Test {
	protected:
		void SetUp() override {
			PolyPtr<PolyBase>::quiescentState();
			PolyBase::liveCount.store(0, std::memory_order_relaxed);
			PolyDerived::derivedLiveCount.store(0, std::memory_order_relaxed);
			PolyAbstractImpl::liveCount.store(0, std::memory_order_relaxed);
			VirtBase::liveCount.store(0, std::memory_order_relaxed);
			VirtDiamond::diamondLiveCount.store(0, std::memory_order_relaxed);
		}

		void TearDown() override {
			PolyPtr<PolyBase>::quiescentState();
		}
	};

	// --- Construction ----------------------------------------------------

	TEST_F(PolyPointerTest, Owning_DefaultConstructed_IsNull) {
		PolyPtr<PolyBase>::Owning p;
		EXPECT_FALSE(static_cast<bool>(p));
		EXPECT_EQ(nullptr, p.get());
		EXPECT_TRUE(p == nullptr);
	}

	TEST_F(PolyPointerTest, Owning_Make_ConcreteType) {
		auto p = PolyPtr<PolyBase>::Owning::make(42);
		ASSERT_TRUE(static_cast<bool>(p));
		EXPECT_EQ(42, p->base_value);
		EXPECT_EQ(42, p->compute());
		EXPECT_EQ(1, PolyBase::liveCount.load());
	}

	TEST_F(PolyPointerTest, MakePoly_AbstractBase_UpcastsImplicitly) {
		// `PolyPtr<PolyAbstract>::Owning::make` is gated by !is_abstract_v.
		// `make_poly<PolyAbstractImpl>` is the entry point.
		PolyPtr<PolyAbstract>::Owning p = make_poly<PolyAbstractImpl>(7);
		ASSERT_TRUE(static_cast<bool>(p));
		EXPECT_EQ(14, p->kind());
		EXPECT_EQ(1, PolyAbstractImpl::liveCount.load());

		p = nullptr;
		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyAbstractImpl::liveCount.load());
	}

	// --- Cross-type upcast ----------------------------------------------

	TEST_F(PolyPointerTest, CrossType_Owning_DerivedToBase) {
		PolyPtr<PolyDerived>::Owning d = PolyPtr<PolyDerived>::Owning::make(3, 5);
		EXPECT_EQ(1, PolyDerived::derivedLiveCount.load());
		EXPECT_EQ(1, PolyBase::liveCount.load());

		PolyPtr<PolyBase>::Owning b = std::move(d);
		EXPECT_FALSE(static_cast<bool>(d));
		ASSERT_TRUE(static_cast<bool>(b));
		// Virtual dispatch — must call PolyDerived::compute, not PolyBase::compute.
		EXPECT_EQ(8, b->compute());
	}

	TEST_F(PolyPointerTest, CrossType_Owning_DerivedDestructorRuns) {
		{
			PolyPtr<PolyBase>::Owning b = make_poly<PolyDerived>(10, 20);
			EXPECT_EQ(1, PolyDerived::derivedLiveCount.load());
			EXPECT_EQ(1, PolyBase::liveCount.load());
		}
		PolyPtr<PolyBase>::quiescentState();
		// Both counters must have decreased — confirms the type-erased deleter
		// invoked ~PolyDerived (which then chains ~PolyBase via virtual dtor).
		EXPECT_EQ(0, PolyDerived::derivedLiveCount.load());
		EXPECT_EQ(0, PolyBase::liveCount.load());
	}

	TEST_F(PolyPointerTest, CrossType_Borrowed_DerivedToBase) {
		auto d = PolyPtr<PolyDerived>::Owning::make(2, 3);
		PolyPtr<PolyDerived>::Borrowed db = d.borrow();
		PolyPtr<PolyBase>::Borrowed bb = db; // implicit upcast

		ASSERT_TRUE(static_cast<bool>(bb));
		EXPECT_EQ(5, bb->compute());
		// Refcount untouched by Borrowed copies.
		EXPECT_EQ(1u, d.share().useCount() - 1u); // -1 for the share() temporary
	}

	TEST_F(PolyPointerTest, CrossType_Shared_DerivedToBase_BumpsRefCount) {
		auto d = PolyPtr<PolyDerived>::Owning::make(1, 1);
		PolyPtr<PolyDerived>::Shared ds = d.share();
		EXPECT_EQ(2u, ds.useCount());

		PolyPtr<PolyBase>::Shared bs = ds;
		EXPECT_EQ(3u, ds.useCount());
		EXPECT_EQ(2, bs->compute());
	}

	// --- Borrowed semantics ---------------------------------------------

	TEST_F(PolyPointerTest, Borrowed_Copy_NoRefCountChange) {
		auto p = PolyPtr<PolyBase>::Owning::make(99);
		auto sp = p.share();
		const size_t before = sp.useCount();
		auto view = p.borrow();

		int sum = 0;
		for (int i = 0; i < 1000; ++i) {
			PolyPtr<PolyBase>::Borrowed copy = view;
			sum += copy->compute();
		}
		EXPECT_EQ(99 * 1000, sum);
		EXPECT_EQ(before, sp.useCount());
	}

	TEST_F(PolyPointerTest, Borrowed_ToShared_ExtendsLifetimePastOwning) {
		PolyPtr<PolyBase>::Shared escaped;
		{
			auto owner = PolyPtr<PolyBase>::Owning::make(123);
			auto v = owner.borrow();
			escaped = v;
		}
		PolyPtr<PolyBase>::quiescentState();

		ASSERT_TRUE(static_cast<bool>(escaped));
		EXPECT_EQ(123, escaped->base_value);
		EXPECT_EQ(1, PolyBase::liveCount.load());

		escaped = nullptr;
		// New deferred-destruction semantics: dropping the last strong ref
		// pushes the block to the retire list; the destructor runs at the
		// next quiescent state (multi-thread safe).
		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyBase::liveCount.load());
	}

	// --- QSBR semantics --------------------------------------------------

	TEST_F(PolyPointerTest, Owning_Destructor_DefersToQSBR) {
		const size_t before = pendingPolyQBSR();
		{
			auto p = PolyPtr<PolyBase>::Owning::make(7);
			EXPECT_EQ(1, PolyBase::liveCount.load());
			EXPECT_EQ(before, pendingPolyQBSR());
		}
		EXPECT_EQ(before + 1, pendingPolyQBSR());
		EXPECT_EQ(1, PolyBase::liveCount.load());

		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyBase::liveCount.load());
		EXPECT_EQ(before, pendingPolyQBSR());
	}

	TEST_F(PolyPointerTest, QuiescentState_GlobalDrainAcrossDifferentBases) {
		// Retiring objects of unrelated bases lands them on the SAME global
		// retire list. A single quiescentState() call drains everything.
		{
			auto a = PolyPtr<PolyBase>::Owning::make(1);
			auto b = make_poly<PolyAbstractImpl>(2);
		}
		EXPECT_EQ(1, PolyBase::liveCount.load());
		EXPECT_EQ(1, PolyAbstractImpl::liveCount.load());

		// Drain via PolyPtr<PolyBase> — must wipe out the PolyAbstractImpl too.
		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyBase::liveCount.load());
		EXPECT_EQ(0, PolyAbstractImpl::liveCount.load());
	}

	// --- Virtual / multiple inheritance -- the case WorldPtr<T> can't handle

	TEST_F(PolyPointerTest, VirtualInheritance_DiamondUpcastAndDestruction) {
		// VirtDiamond has virtual base VirtBase reached through VirtMid1 and
		// VirtMid2. static_cast<VirtBase*>(VirtDiamond*) is non-trivial — the
		// compiler emits the proper offset adjustment. The intrusive design's
		// reverse-cast trick can't do this; PolyPtr handles it correctly
		// because the deleter is type-erased to the concrete type.
		PolyPtr<VirtBase>::Owning b = make_poly<VirtDiamond>(4, 6);
		ASSERT_TRUE(static_cast<bool>(b));
		EXPECT_EQ(10, b->kind());
		EXPECT_EQ(1, VirtBase::liveCount.load());
		EXPECT_EQ(1, VirtDiamond::diamondLiveCount.load());

		b = nullptr;
		PolyPtr<VirtBase>::quiescentState();
		EXPECT_EQ(0, VirtBase::liveCount.load());
		EXPECT_EQ(0, VirtDiamond::diamondLiveCount.load());
	}

	// --- AnyPtr alias ----------------------------------------------------

	TEST_F(PolyPointerTest, AnyPtr_PicksWorldPtrForConcrete) {
		// Probe is non-polymorphic — AnyPtr<Probe> must alias WorldPtr<Probe>.
		static_assert(std::is_same_v<AnyPtr<Probe>, WorldPtr<Probe>>);
	}

	TEST_F(PolyPointerTest, AnyPtr_PicksPolyPtrForPolymorphic) {
		// PolyBase has virtuals — AnyPtr<PolyBase> must alias PolyPtr<PolyBase>.
		static_assert(std::is_same_v<AnyPtr<PolyBase>, PolyPtr<PolyBase>>);
	}

	// =====================================================================
	// enable_borrowed_from_this<T> mixin
	// =====================================================================

	struct ProbeWithMixin : public enable_borrowed_from_this<ProbeWithMixin> {
		int value;

		static inline std::atomic<int> liveCount { 0 };

		explicit ProbeWithMixin(int v) :
			value(v) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}

		ProbeWithMixin(const ProbeWithMixin &) = delete;
		ProbeWithMixin &operator=(const ProbeWithMixin &) = delete;

		virtual ~ProbeWithMixin() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}
	};

	struct ProbeBaseWithMixin : public enable_borrowed_from_this<ProbeBaseWithMixin> {
		int value;

		explicit ProbeBaseWithMixin(int v) :
			value(v) { }

		ProbeBaseWithMixin(const ProbeBaseWithMixin &) = delete;
		ProbeBaseWithMixin &operator=(const ProbeBaseWithMixin &) = delete;

		virtual ~ProbeBaseWithMixin() = default;
	};

	struct ProbeDerivedFromMixinBase final : public ProbeBaseWithMixin {
		int extra;

		ProbeDerivedFromMixinBase(int v, int e) :
			ProbeBaseWithMixin(v), extra(e) { }
	};

	class EnableBorrowedFromThisTest : public ::testing::Test {
	protected:
		void SetUp() override {
			PolyPtr<ProbeWithMixin>::quiescentState();
			ProbeWithMixin::liveCount.store(0, std::memory_order_relaxed);
		}

		void TearDown() override {
			PolyPtr<ProbeWithMixin>::quiescentState();
		}
	};

	TEST_F(EnableBorrowedFromThisTest, BorrowedFromThis_ReturnsValidBorrowedAfterMake) {
		auto owner = PolyPtr<ProbeWithMixin>::Owning::make(42);
		auto borrowed = owner->borrowedFromThis();
		ASSERT_TRUE(static_cast<bool>(borrowed));
		EXPECT_EQ(owner.get(), borrowed.get());
		EXPECT_EQ(42, borrowed->value);
	}

	TEST_F(EnableBorrowedFromThisTest, SharedFromThis_BumpsRefCount) {
		auto owner = PolyPtr<ProbeWithMixin>::Owning::make(7);
		auto s1 = owner.share();
		EXPECT_EQ(2u, s1.useCount());

		auto s2 = owner->sharedFromThis();
		EXPECT_EQ(3u, s2.useCount());
		EXPECT_EQ(owner.get(), s2.get());
	}

	TEST_F(EnableBorrowedFromThisTest, BorrowedFromThis_StackAllocated_ReturnsNull) {
		// Object not allocated via make_poly — `poly_header_` never wired.
		// Methods must return null pointer instead of crashing.
		ProbeWithMixin probe(99);
		auto borrowed = probe.borrowedFromThis();
		EXPECT_FALSE(static_cast<bool>(borrowed));
		auto shared = probe.sharedFromThis();
		EXPECT_FALSE(static_cast<bool>(shared));
	}

	TEST_F(EnableBorrowedFromThisTest, SubclassInheritsMixin_BorrowedTypedToBase) {
		// `make_poly<Derived>` returns Owning<Derived>; cross-type upcasts
		// to Owning<Base>. The mixin field lives in the Base subobject and is
		// wired automatically via the typedef inheritance.
		PolyPtr<ProbeBaseWithMixin>::Owning owner = make_poly<ProbeDerivedFromMixinBase>(1, 2);
		auto b = owner->borrowedFromThis();
		ASSERT_TRUE(static_cast<bool>(b));
		EXPECT_EQ(1, b->value);
		EXPECT_EQ(owner.get(), b.get());
	}

	TEST_F(EnableBorrowedFromThisTest, NonMixinTypeStillWorks_NoOpWiring) {
		// Sanity: existing PolyPtr tests with PolyBase (which does NOT use
		// the mixin) still compile and run — wireBorrowedFromThis<PolyBase>
		// is a no-op via SFINAE on the missing typedef.
		auto owner = PolyPtr<PolyBase>::Owning::make(123);
		ASSERT_TRUE(static_cast<bool>(owner));
		EXPECT_EQ(123, owner->base_value);
	}

	// =====================================================================
	// Typed downcast helpers (static_pointer_cast_poly / dynamic_pointer_cast_poly)
	// =====================================================================

	struct DowncastTest : public ::testing::Test {
		void SetUp() override {
			PolyPtr<PolyBase>::quiescentState();
			PolyBase::liveCount.store(0, std::memory_order_relaxed);
			PolyDerived::derivedLiveCount.store(0, std::memory_order_relaxed);
		}
		void TearDown() override {
			PolyPtr<PolyBase>::quiescentState();
		}
	};

	TEST_F(DowncastTest, StaticPointerCastPoly_Shared_RoundTrip) {
		PolyPtr<PolyBase>::Owning b = make_poly<PolyDerived>(2, 3);
		auto bs = b.share();
		EXPECT_EQ(2u, bs.useCount());

		auto ds = static_pointer_cast_poly<PolyDerived, PolyBase>(bs);
		ASSERT_TRUE(static_cast<bool>(ds));
		EXPECT_EQ(3u, bs.useCount()) << "downcast must bump the shared block";
		EXPECT_EQ(3, ds->derived_value);
		EXPECT_EQ(5, ds->compute());
	}

	TEST_F(DowncastTest, StaticPointerCastPoly_Borrowed_NoRefcountChange) {
		PolyPtr<PolyBase>::Owning b = make_poly<PolyDerived>(7, 11);
		auto sp = b.share();
		const auto before = sp.useCount();

		auto bv = b.borrow();
		auto dv = static_pointer_cast_poly<PolyDerived, PolyBase>(bv);
		ASSERT_TRUE(static_cast<bool>(dv));
		EXPECT_EQ(11, dv->derived_value);
		EXPECT_EQ(before, sp.useCount()) << "Borrowed downcast is zero-atomic";
	}

	TEST_F(DowncastTest, DynamicPointerCastPoly_Failure_ReturnsNull) {
		// PolyBase live, NOT PolyDerived → dynamic cast should fail.
		auto b = PolyPtr<PolyBase>::Owning::make(42);
		auto bs = b.share();
		auto ds = dynamic_pointer_cast_poly<PolyDerived, PolyBase>(bs);
		EXPECT_FALSE(static_cast<bool>(ds));
		EXPECT_EQ(2u, bs.useCount()) << "failed dynamic cast must NOT bump refcount";
	}

	TEST_F(DowncastTest, DynamicPointerCastPoly_NullSource_ReturnsNull) {
		PolyPtr<PolyBase>::Shared empty;
		auto ds = dynamic_pointer_cast_poly<PolyDerived, PolyBase>(empty);
		EXPECT_FALSE(static_cast<bool>(ds));
	}

	// =====================================================================
	// Transparent hash + equal — heterogeneous lookup keys
	// =====================================================================

	TEST_F(WorldPointerTest, TransparentHash_BorrowedAndSharedAgreeOnHash) {
		PolyPtrTransparentHash<PolyBase> hasher;
		PolyPtrTransparentEqual<PolyBase> eq;

		auto owner = PolyPtr<PolyBase>::Owning::make(7);
		auto shared = owner.share();
		auto borrowed = owner.borrow();

		EXPECT_EQ(hasher(shared), hasher(borrowed));
		EXPECT_EQ(hasher(shared), hasher(borrowed.get()));
		EXPECT_TRUE(eq(shared, borrowed));
		EXPECT_TRUE(eq(borrowed, shared));
		EXPECT_TRUE(eq(borrowed, borrowed.get()));
	}

	// =====================================================================
	// Concurrent setTile-like swap pattern — guards against the race that
	// would exist if Floor::setTile ran without an exclusive lock.
	// =====================================================================
	//
	// Models the production setup: many readers grab a Borrowed (under
	// shared_lock), one writer swaps the slot via swapTile (under exclusive
	// lock). What we check: no torn reads (every Borrowed seen has either
	// the original or the new value, never garbage from a half-updated
	// header_/value_ pair) and no use-after-free after a swap.

	struct CountedProbe {
		int value;
		static inline std::atomic<int> liveCount { 0 };

		explicit CountedProbe(int v) :
			value(v) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}
		~CountedProbe() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}
		CountedProbe(const CountedProbe &) = delete;
		CountedProbe &operator=(const CountedProbe &) = delete;
	};

	using CountedAlloc = WorldPtr<CountedProbe>::DefaultAllocator;
	using CountedOwning = WorldPtr<CountedProbe>::Owning<CountedAlloc>;
	using CountedBorrowed = WorldPtr<CountedProbe>::Borrowed<CountedAlloc>;

	// Mini-Floor: one slot, exclusive on write, shared on read.
	struct MiniFloor {
		mutable std::shared_mutex mutex;
		CountedOwning slot;

		[[nodiscard]] CountedBorrowed get() const {
			std::shared_lock<std::shared_mutex> sl(mutex);
			return slot;
		}

		[[nodiscard]] CountedOwning swap(CountedOwning newSlot) {
			std::scoped_lock<std::shared_mutex> sl(mutex);
			auto prev = std::move(slot);
			slot = std::move(newSlot);
			return prev;
		}
	};

	TEST(FloorRace, ReadersSeeConsistentValueWhileWriterSwaps) {
		// Drain whatever is pending so liveCount comparisons are clean.
		WorldPtr<CountedProbe>::quiescentState<CountedAlloc>();
		CountedProbe::liveCount.store(0, std::memory_order_relaxed);

		MiniFloor floor;
		floor.slot = CountedOwning::make(0);

		std::atomic<bool> stop { false };
		std::atomic<size_t> goodReads { 0 };
		std::atomic<size_t> badReads { 0 };

		constexpr int kReaders = 4;
		constexpr int kSwaps = 200;

		std::vector<std::jthread> readers;
		readers.reserve(kReaders);
		for (int t = 0; t < kReaders; ++t) {
			readers.emplace_back([&]() {
				while (!stop.load(std::memory_order_relaxed)) {
					auto b = floor.get();
					if (!b) {
						continue;
					}
					int v = b->value;
					// Allowed: any value the writer has set so far.
					// Disallowed: anything outside [0, kSwaps].
					if (v >= 0 && v <= kSwaps) {
						goodReads.fetch_add(1, std::memory_order_relaxed);
					} else {
						badReads.fetch_add(1, std::memory_order_relaxed);
					}
				}
			});
		}

		// Writer: swap kSwaps times. Old slots retire to QSBR (test does
		// NOT drain mid-loop so old blocks stay alive — readers may still
		// hold Borrowed views of them safely).
		for (int i = 1; i <= kSwaps; ++i) {
			(void)floor.swap(CountedOwning::make(i));
		}

		stop.store(true, std::memory_order_relaxed);
		readers.clear(); // join

		EXPECT_EQ(0u, badReads.load());
		EXPECT_GT(goodReads.load(), 0u);

		// Cleanup: drop the final slot, then drain.
		(void)floor.swap(CountedOwning {});
		WorldPtr<CountedProbe>::quiescentState<CountedAlloc>();
		EXPECT_EQ(0, CountedProbe::liveCount.load());
	}

	// =====================================================================
	// PolyPtr<T>::Weak — non-pinning observer (analog of std::weak_ptr)
	// =====================================================================

	struct WeakProbe {
		int value;
		static inline std::atomic<int> liveCount { 0 };

		explicit WeakProbe(int v) :
			value(v) {
			liveCount.fetch_add(1, std::memory_order_relaxed);
		}
		WeakProbe(const WeakProbe &) = delete;
		WeakProbe &operator=(const WeakProbe &) = delete;
		virtual ~WeakProbe() {
			liveCount.fetch_sub(1, std::memory_order_relaxed);
		}
	};

	class WeakPointerTest : public ::testing::Test {
	protected:
		void SetUp() override {
			PolyPtr<WeakProbe>::quiescentState();
			WeakProbe::liveCount.store(0, std::memory_order_relaxed);
		}
		void TearDown() override {
			PolyPtr<WeakProbe>::quiescentState();
		}
	};

	TEST_F(WeakPointerTest, Weak_Default_IsExpired) {
		PolyPtr<WeakProbe>::Weak w;
		EXPECT_TRUE(w.expired());
		EXPECT_FALSE(static_cast<bool>(w.lock()));
		EXPECT_FALSE(static_cast<bool>(w.borrowIfAlive()));
	}

	TEST_F(WeakPointerTest, Weak_FromShared_DoesNotPin) {
		auto owner = PolyPtr<WeakProbe>::Owning::make(42);
		PolyPtr<WeakProbe>::Weak w = owner.share();
		EXPECT_FALSE(w.expired());

		// Dropping owner should make w expire (after quiescent drain).
		owner = nullptr;
		PolyPtr<WeakProbe>::quiescentState();
		EXPECT_TRUE(w.expired());
		EXPECT_EQ(0, WeakProbe::liveCount.load()) << "value destroyed at strong→0 drain";
	}

	TEST_F(WeakPointerTest, Weak_BorrowIfAlive_FastPath) {
		auto owner = PolyPtr<WeakProbe>::Owning::make(7);
		PolyPtr<WeakProbe>::Weak w = owner.share();

		auto b = w.borrowIfAlive();
		ASSERT_TRUE(static_cast<bool>(b));
		EXPECT_EQ(7, b->value);
	}

	TEST_F(WeakPointerTest, Weak_BorrowIfAlive_NullAfterExpiration) {
		PolyPtr<WeakProbe>::Weak w;
		{
			auto owner = PolyPtr<WeakProbe>::Owning::make(5);
			w = owner.share();
			ASSERT_FALSE(w.expired());
		}
		// owner gone; drain to destroy value.
		PolyPtr<WeakProbe>::quiescentState();

		EXPECT_TRUE(w.expired());
		auto b = w.borrowIfAlive();
		EXPECT_FALSE(static_cast<bool>(b));
	}

	TEST_F(WeakPointerTest, Weak_Lock_ReturnsSharedWhenAlive) {
		auto owner = PolyPtr<WeakProbe>::Owning::make(11);
		PolyPtr<WeakProbe>::Weak w = owner.share();
		// `owner.share()` returned a temporary Shared that bumped strong
		// to 2, but the Weak ctor only retains the WEAK ref — when the
		// temporary dies at the end of the statement, strong drops back
		// to 1 (just `owner`).

		auto sp = w.lock();
		ASSERT_TRUE(static_cast<bool>(sp));
		EXPECT_EQ(11, sp->value);
		EXPECT_EQ(2u, sp.useCount()) << "owner(1) + sp from lock(1) = 2";
	}

	TEST_F(WeakPointerTest, Weak_Lock_NullAfterExpiration) {
		PolyPtr<WeakProbe>::Weak w;
		{
			auto owner = PolyPtr<WeakProbe>::Owning::make(9);
			w = owner.share();
		}
		PolyPtr<WeakProbe>::quiescentState();

		auto sp = w.lock();
		EXPECT_FALSE(static_cast<bool>(sp));
	}

	TEST_F(WeakPointerTest, Weak_OutlivesValue_BlockStillAllocated) {
		// Standard weak_ptr behavior: Weak keeps the control block alive
		// even after the value is destroyed. expired() returns true but
		// the Weak itself is still functional (no UAF on expired()).
		PolyPtr<WeakProbe>::Weak w;
		{
			auto owner = PolyPtr<WeakProbe>::Owning::make(99);
			w = owner.share();
		}
		PolyPtr<WeakProbe>::quiescentState();
		EXPECT_EQ(0, WeakProbe::liveCount.load());

		// Repeated calls on expired Weak — must NOT UAF.
		for (int i = 0; i < 100; ++i) {
			EXPECT_TRUE(w.expired());
			EXPECT_FALSE(static_cast<bool>(w.borrowIfAlive()));
			EXPECT_FALSE(static_cast<bool>(w.lock()));
		}
	}

	TEST_F(WeakPointerTest, Weak_CrossType_DerivedToBase) {
		struct DerivedProbe : public WeakProbe {
			int extra;
			DerivedProbe(int b, int d) :
				WeakProbe(b), extra(d) { }
		};

		PolyPtr<DerivedProbe>::Owning d = PolyPtr<DerivedProbe>::Owning::make(2, 5);
		PolyPtr<DerivedProbe>::Weak dw = d.share();
		PolyPtr<WeakProbe>::Weak bw = dw; // implicit upcast

		ASSERT_FALSE(bw.expired());
		auto sp = bw.lock();
		ASSERT_TRUE(static_cast<bool>(sp));
		EXPECT_EQ(2, sp->value);
	}

	TEST_F(WeakPointerTest, Weak_CycleBreaker_NoLeak) {
		// Simulates the Item↔Tile cycle scenario:
		//   Owner has a `value` field; "child" struct has a Weak pointing
		//   back to Owner. Even if children outlive normal references,
		//   Owner can still die because Weak doesn't pin.
		struct Parent : public WeakProbe {
			explicit Parent(int v) :
				WeakProbe(v) { }
		};

		struct Child {
			PolyPtr<Parent>::Weak parent;
		};

		std::vector<Child> children;
		{
			auto parent = PolyPtr<Parent>::Owning::make(123);
			for (int i = 0; i < 10; ++i) {
				children.push_back({ parent.share() });
			}
			// parent.share() returns a Shared which Children's Weak ctor
			// consumes. Children hold Weak (non-pinning).
		}
		PolyPtr<Parent>::quiescentState();

		// Parent owning dropped; no Shareds outside; only Weaks left.
		// Value destroyed at drain.
		EXPECT_EQ(0, WeakProbe::liveCount.load());
		for (auto &c : children) {
			EXPECT_TRUE(c.parent.expired());
		}
		// Block memory still alive (Weaks hold it). Will deallocate when
		// all Weaks die.
		children.clear();
		PolyPtr<Parent>::quiescentState();
	}

	TEST_F(WeakPointerTest, Weak_AssignFromShared) {
		PolyPtr<WeakProbe>::Weak w;
		auto owner = PolyPtr<WeakProbe>::Owning::make(1);
		w = owner.share();
		EXPECT_FALSE(w.expired());

		auto owner2 = PolyPtr<WeakProbe>::Owning::make(2);
		w = owner2.share();
		EXPECT_FALSE(w.expired());
		EXPECT_EQ(2, w.lock()->value);
	}

	TEST_F(WeakPointerTest, Shared_DeferredDestruction) {
		// New invariant: Shared.~Shared does NOT destroy inline when last.
		// Destruction is deferred to quiescentState (multi-thread safe).
		{
			auto owner = PolyPtr<WeakProbe>::Owning::make(50);
			EXPECT_EQ(1, WeakProbe::liveCount.load());
		}
		// Owning gone; strong=0 → pushed to retire list. Value still alive.
		EXPECT_EQ(1, WeakProbe::liveCount.load())
			<< "value must NOT be destroyed inline — defer to quiescent";

		PolyPtr<WeakProbe>::quiescentState();
		EXPECT_EQ(0, WeakProbe::liveCount.load());
	}

	// =====================================================================
	// Regression: CAS-loop in Borrowed→Shared and sharedFromThis
	//
	// Anti-regression for `fix(world-ptr): close UAF/double-free in
	// Borrowed->Shared resurrection`. PolyPtr's `Owning::~Owning` decrements
	// strong immediately (push to retire list at 0); a still-extant
	// `Borrowed` whose source has just been retired must NOT resurrect the
	// block via a bare `fetch_add`. The CAS-loop in
	// `tryIncrementStrong` enforces this — `share()` returns a null Shared
	// instead, matching `std::weak_ptr::lock()` semantics.
	// =====================================================================

	TEST_F(PolyPointerTest, Borrowed_Share_NullAfterStrongHitsZero) {
		PolyPtr<PolyBase>::Borrowed b;
		{
			auto owning = PolyPtr<PolyBase>::Owning::make(7);
			b = owning.borrow();
			// Owning drops at scope exit → strong: 1→0 → retire push.
		}
		EXPECT_TRUE(static_cast<bool>(b))
			<< "Borrowed's cached value pointer is still set (block memory "
			   "stays alive until weak→0)";
		auto s = b.share();
		EXPECT_FALSE(static_cast<bool>(s))
			<< "share() on a Borrowed whose strong group is gone must return "
			   "null, NOT resurrect a retired block";
		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyBase::liveCount.load());
	}

	TEST_F(PolyPointerTest, Borrowed_Share_SucceedsWhileOwnerAlive) {
		// Counterpart to the regression above — CAS must NOT reject when
		// strong > 0.
		auto owning = PolyPtr<PolyBase>::Owning::make(8);
		auto b = owning.borrow();
		auto s = b.share();
		ASSERT_TRUE(static_cast<bool>(s));
		EXPECT_EQ(2u, s.useCount()) << "owner(1) + share(1) = 2";
	}

	TEST_F(EnableBorrowedFromThisTest, SharedFromThis_NullAfterStrongHitsZero) {
		// Same regression via the mixin path. Capture `raw` from the Owning
		// before drop, then call `sharedFromThis` on it after retire. With
		// the bare-fetch_add bug, this would resurrect strong from 0→1.
		// Now it must return null.
		ProbeWithMixin* raw = nullptr;
		{
			auto owning = PolyPtr<ProbeWithMixin>::Owning::make(99);
			raw = owning.get();
			// Owning drops here → strong: 1→0 → retire push. Block memory
			// stays alive (weak group), so `raw->method()` reads valid
			// memory until the next quiescentState.
		}
		auto s = raw->sharedFromThis();
		EXPECT_FALSE(static_cast<bool>(s))
			<< "sharedFromThis on an object whose strong group is gone must "
			   "return null, NOT resurrect a retired block";
		PolyPtr<ProbeWithMixin>::quiescentState();
	}

	// =====================================================================
	// Self-assignment safety
	//
	// All four wrappers have an explicit `if (this != &other)` guard on the
	// assignment operators. Self-assignment must be a no-op — no double
	// free, no decrement-to-zero on a still-needed strong ref.
	// =====================================================================

	TEST_F(WorldPointerTest, Owning_SelfMoveAssign_PreservesState) {
		auto p = Owning::make(7);
		auto* raw = p.get();
		// `p = std::move(p)` triggers -Wself-move on GCC; route through a
		// same-typed reference to silence the warning while still
		// exercising the assignment-to-self path.
		auto &ref = p;
		p = std::move(ref);
		ASSERT_TRUE(static_cast<bool>(p));
		EXPECT_EQ(raw, p.get());
		EXPECT_EQ(7, p->value);
	}

	TEST_F(WorldPointerTest, Shared_SelfCopyAssign_PreservesRefCount) {
		auto owning = Owning::make(5);
		Shared s = owning.share();
		ASSERT_EQ(2u, s.useCount());
		auto &ref = s;
		s = ref;
		EXPECT_EQ(2u, s.useCount())
			<< "self-copy must not bump or drop the refcount";
	}

	TEST_F(WorldPointerTest, Shared_SelfMoveAssign_PreservesRefCount) {
		auto owning = Owning::make(5);
		Shared s = owning.share();
		ASSERT_EQ(2u, s.useCount());
		auto &ref = s;
		s = std::move(ref);
		EXPECT_EQ(2u, s.useCount())
			<< "self-move must not bump or drop the refcount";
	}

	TEST_F(PolyPointerTest, Weak_SelfCopyAssign_PreservesObservation) {
		auto owning = PolyPtr<PolyBase>::Owning::make(11);
		PolyPtr<PolyBase>::Weak w = owning.share();
		auto &ref = w;
		w = ref;
		EXPECT_FALSE(w.expired());
		EXPECT_EQ(11, w.lock()->base_value);
	}

	// =====================================================================
	// Default-constructed sanity
	// =====================================================================

	TEST_F(WorldPointerTest, DefaultConstructed_AllCompareNull) {
		Owning o;
		Borrowed b;
		Shared s;
		EXPECT_TRUE(o == nullptr);
		EXPECT_TRUE(b == nullptr);
		EXPECT_TRUE(s == nullptr);
		EXPECT_FALSE(static_cast<bool>(o));
		EXPECT_FALSE(static_cast<bool>(b));
		EXPECT_FALSE(static_cast<bool>(s));
	}

	TEST_F(WorldPointerTest, Owning_NullAndNonNull_NotEqual) {
		Owning empty;
		auto live = Owning::make(1);
		EXPECT_FALSE(empty == live);
	}

	TEST_F(WorldPointerTest, Owning_DistinctNonNullInstances_NeverEqual) {
		// Affine invariant — two Ownings can never coexist on the same
		// pointee. The operator== assert (debug-only) would fire if this
		// were violated; the equality check itself must return false.
		auto a = Owning::make(1);
		auto b = Owning::make(2);
		EXPECT_FALSE(a == b);
	}

	TEST_F(WeakPointerTest, Weak_DefaultConstructed_BorrowIfAliveReturnsEmpty) {
		PolyPtr<WeakProbe>::Weak w;
		auto b = w.borrowIfAlive();
		EXPECT_FALSE(static_cast<bool>(b));
	}

	TEST_F(WeakPointerTest, Weak_DefaultConstructed_LockReturnsEmpty) {
		PolyPtr<WeakProbe>::Weak w;
		auto s = w.lock();
		EXPECT_FALSE(static_cast<bool>(s));
	}

	// =====================================================================
	// Refcount semantics: Borrowed copies vs Shared move/copy
	// =====================================================================

	TEST_F(WorldPointerTest, Borrowed_Copy_DoesNotBumpRefCount) {
		auto owning = Owning::make(7);
		Borrowed b1 = owning.borrow();
		Borrowed b2 = b1;
		Borrowed b3 = b2;
		(void)b3;
		auto s = owning.share();
		EXPECT_EQ(2u, s.useCount())
			<< "owner(1) + share(1) = 2; Borrowed copies are non-bumping";
	}

	TEST_F(PolyPointerTest, Borrowed_Copy_DoesNotBumpStrong) {
		auto owning = PolyPtr<PolyBase>::Owning::make(7);
		auto b1 = owning.borrow();
		auto b2 = b1;
		auto b3 = b2;
		(void)b3;
		auto s = owning.share();
		EXPECT_EQ(2u, s.useCount())
			<< "owner(1) + share(1) = 2; Borrowed copies bump nothing";
	}

	TEST_F(WorldPointerTest, Shared_MoveCtor_TransfersWithoutBump) {
		auto owning = Owning::make(7);
		Shared s1 = owning.share();
		ASSERT_EQ(2u, s1.useCount());
		Shared s2 = std::move(s1);
		EXPECT_EQ(2u, s2.useCount()) << "move transfers — no bump";
		EXPECT_TRUE(s1 == nullptr) << "moved-from Shared is null";
	}

	// =====================================================================
	// QSBR drain under load
	// =====================================================================

	TEST_F(WorldPointerTest, QSBR_HundredCycles_LiveCountReturnsToZero) {
		for (int i = 0; i < 100; ++i) {
			auto p = Owning::make(i);
			(void)p;
		}
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0, Probe::liveCount.load())
			<< "100 make/destroy cycles + drain must leave no live Probes";
	}

	TEST_F(PolyPointerTest, QSBR_HundredCycles_LiveCountReturnsToZero) {
		for (int i = 0; i < 100; ++i) {
			auto p = PolyPtr<PolyBase>::Owning::make(i);
			(void)p;
		}
		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyBase::liveCount.load());
	}

	TEST_F(WorldPointerTest, QSBR_EmptyDrain_IsSafeNoOp) {
		ASSERT_EQ(0u, pendingQBSR());
		// Idempotent under any call count.
		for (int i = 0; i < 5; ++i) {
			WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		}
		EXPECT_EQ(0u, pendingQBSR());
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	TEST_F(WorldPointerTest, QSBR_PendingListGrowsAndDrains) {
		ASSERT_EQ(0u, pendingQBSR());
		{
			auto a = Owning::make(1);
			auto b = Owning::make(2);
			auto c = Owning::make(3);
			ASSERT_EQ(3, Probe::liveCount.load());
		}
		EXPECT_EQ(3u, pendingQBSR()) << "3 retires pending after scope exit";
		// WorldPtr's `retire()` does NOT decrement the strong refcount — the
		// value destructor is deferred until the next quiescent state.
		EXPECT_EQ(3, Probe::liveCount.load())
			<< "values must NOT be destroyed inline — retire only";
		WorldPtr<Probe>::quiescentState<ProbeAlloc>();
		EXPECT_EQ(0u, pendingQBSR());
		EXPECT_EQ(0, Probe::liveCount.load());
	}

	// =====================================================================
	// Cross-type up/downcast
	// =====================================================================

	TEST_F(DowncastTest, StaticPointerCastPoly_Borrowed_ProducesDerivedView) {
		auto owning = make_poly<PolyDerived>(10, 20);
		PolyPtr<PolyBase>::Borrowed asBase = owning.borrow();
		// Explicit `<Derived, Base>` — GCC can't deduce Base from the
		// nested type `typename PolyPtr<Base>::Borrowed` (non-deduced
		// context). Matches the pattern in existing downcast tests.
		auto asDerived = static_pointer_cast_poly<PolyDerived, PolyBase>(asBase);
		ASSERT_TRUE(static_cast<bool>(asDerived));
		EXPECT_EQ(10, asDerived->base_value);
		EXPECT_EQ(20, asDerived->derived_value);
	}

	TEST_F(DowncastTest, DynamicPointerCastPoly_Borrowed_FailureReturnsNull) {
		// Runtime type is PolyBase — `dynamic_cast<PolyDerived*>` rejects
		// and the downcast must yield an empty Borrowed.
		auto owning = PolyPtr<PolyBase>::Owning::make(0);
		PolyPtr<PolyBase>::Borrowed b = owning.borrow();
		auto failed = dynamic_pointer_cast_poly<PolyDerived, PolyBase>(b);
		EXPECT_FALSE(static_cast<bool>(failed));
	}

	TEST_F(DowncastTest, DynamicPointerCastPoly_Weak_RoundTrip) {
		// Cross-type via Owning<Base> from rvalue Owning<Derived> — gives a
		// `Weak<PolyBase>` directly from `.share()` without going through a
		// two-step implicit conversion (Shared<Derived> → Weak<Derived> →
		// Weak<Base>), which the language doesn't allow.
		PolyPtr<PolyBase>::Owning owning = make_poly<PolyDerived>(3, 4);
		PolyPtr<PolyBase>::Weak weakBase = owning.share();
		auto weakDerived = dynamic_pointer_cast_poly<PolyDerived, PolyBase>(weakBase);
		ASSERT_FALSE(weakDerived.expired());
		auto sp = weakDerived.lock();
		ASSERT_TRUE(static_cast<bool>(sp));
		EXPECT_EQ(3, sp->base_value);
		EXPECT_EQ(4, sp->derived_value);
	}

	TEST_F(DowncastTest, DynamicPointerCastPoly_Weak_FailureReturnsExpired) {
		auto owning = PolyPtr<PolyBase>::Owning::make(0);
		PolyPtr<PolyBase>::Weak wb = owning.share();
		auto wd = dynamic_pointer_cast_poly<PolyDerived, PolyBase>(wb);
		EXPECT_TRUE(wd.expired())
			<< "failed dynamic-cast must yield an expired Weak, NOT silently "
			   "downcast through";
	}

	TEST_F(PolyPointerTest, Owning_CrossTypeMove_PreservesStrong) {
		// `Owning<Base>` move-constructed from `Owning<Derived>` rvalue —
		// the affine invariant carries through; strong stays at 1.
		PolyPtr<PolyBase>::Owning asBase = make_poly<PolyDerived>(1, 2);
		ASSERT_TRUE(static_cast<bool>(asBase));
		auto s = asBase.share();
		EXPECT_EQ(2u, s.useCount());
		EXPECT_EQ(1, s->base_value);
	}

	TEST_F(PolyPointerTest, Weak_FromBorrowed_ExplicitCtor) {
		// Weak(Borrowed) is explicit (Borrowed is tick-bound; promoting to
		// Weak extends observability past the current tick, so caller must
		// opt in).
		auto owning = PolyPtr<PolyBase>::Owning::make(7);
		auto b = owning.borrow();
		PolyPtr<PolyBase>::Weak w(b);
		EXPECT_FALSE(w.expired());
		EXPECT_EQ(owning.get(), w.lock().get());
	}

	TEST_F(DowncastTest, WeakDowncast_FullLifecycle_DoesNotCrash) {
		// Smoke test for `fix(world-ptr): drop double weak_refcount bump in
		// Weak downcast`. With the original bug, weakDowncast_ added an
		// extra weak refcount per cast, but the bug surfaced as a block
		// leak (impossible to observe through liveCount alone). This test
		// only validates the full lifecycle still completes without
		// crashing — paired with the existing Weak-related coverage it
		// gives reasonable confidence.
		PolyPtr<PolyBase>::Owning owning = make_poly<PolyDerived>(1, 2);
		PolyPtr<PolyBase>::Weak weakBase = owning.share();
		{
			auto wd1 = dynamic_pointer_cast_poly<PolyDerived, PolyBase>(weakBase);
			auto wd2 = static_pointer_cast_poly<PolyDerived, PolyBase>(weakBase);
			(void)wd1;
			(void)wd2;
		}
		EXPECT_FALSE(weakBase.expired());
		owning = nullptr;
		PolyPtr<PolyBase>::quiescentState();
		EXPECT_EQ(0, PolyBase::liveCount.load());
	}

	// =====================================================================
	// Transparent hash/equal heterogeneous lookup
	// =====================================================================

	TEST_F(DowncastTest, TransparentEqual_OwningBorrowedSharedSameKey) {
		auto owning = PolyPtr<PolyBase>::Owning::make(1);
		auto b = owning.borrow();
		auto s = owning.share();
		PolyPtrTransparentEqual<PolyBase> eq;
		EXPECT_TRUE(eq(owning, b));
		EXPECT_TRUE(eq(owning, s));
		EXPECT_TRUE(eq(b, s));
		EXPECT_TRUE(eq(b, owning.get()));
	}

	TEST_F(DowncastTest, TransparentHash_AllRefTypesMatchOnSameValue) {
		auto owning = PolyPtr<PolyBase>::Owning::make(1);
		auto b = owning.borrow();
		auto s = owning.share();
		PolyPtrTransparentHash<PolyBase> h;
		EXPECT_EQ(h(owning), h(b));
		EXPECT_EQ(h(owning), h(s));
		EXPECT_EQ(h(b), h(s));
		EXPECT_EQ(h(b), h(owning.get()));
	}

	// =====================================================================
	// Mixed lifetimes (Owning + Shared + Weak coexisting)
	// =====================================================================

	TEST_F(PolyPointerTest, Shared_OutlivesOwning_AcrossDrain) {
		PolyPtr<PolyBase>::Shared survivor;
		{
			auto owning = PolyPtr<PolyBase>::Owning::make(33);
			survivor = owning.share();
		}
		// Owning dropped → strong: 2→1. survivor still pins.
		PolyPtr<PolyBase>::quiescentState();
		ASSERT_TRUE(static_cast<bool>(survivor));
		EXPECT_EQ(33, survivor->base_value);
		EXPECT_EQ(1, PolyBase::liveCount.load());
	}

	TEST_F(PolyPointerTest, OwnerAndBorrowedAndSharedAndWeak_AllObserveSameValue) {
		auto owning = PolyPtr<PolyBase>::Owning::make(77);
		auto b = owning.borrow();
		auto s = owning.share();
		PolyPtr<PolyBase>::Weak w = owning.share();
		EXPECT_EQ(owning.get(), b.get());
		EXPECT_EQ(owning.get(), s.get());
		EXPECT_EQ(owning.get(), w.lock().get());
	}

	TEST_F(WorldPointerTest, OverAlignedT_MoveChainPreservesValue) {
		// Exercise the offsetof recovery through a long move-assign chain
		// for an alignas(64) T. The intrusive layout's `getBlock()` must
		// keep recovery correct regardless of padding choices the compiler
		// makes.
		auto a = WideOwning::make(11);
		auto b = std::move(a);
		auto c = std::move(b);
		auto d = std::move(c);
		EXPECT_EQ(11, d->value);
		EXPECT_EQ(1, WideProbe::liveCount.load());
	}

	// =====================================================================
	// Compile-time guard tests — `static_assert` invariants that document
	// the affine ownership model and the "no resurrection via raw pointer"
	// boundary. If any of these regress, the API has silently relaxed
	// a guarantee that the rest of the codebase relies on.
	// =====================================================================

	TEST_F(WorldPointerTest, GuardStaticInvariants_OwningIsMoveOnly) {
		static_assert(!std::is_copy_constructible_v<Owning>, "WorldPtr<T>::Owning must be move-only (affine invariant)");
		static_assert(!std::is_copy_assignable_v<Owning>, "WorldPtr<T>::Owning must be move-only (affine invariant)");
		static_assert(std::is_move_constructible_v<Owning>);
		static_assert(std::is_move_assignable_v<Owning>);
	}

	TEST_F(WorldPointerTest, GuardStaticInvariants_BorrowedAndSharedCopyable) {
		static_assert(std::is_copy_constructible_v<Borrowed>);
		static_assert(std::is_copy_assignable_v<Borrowed>);
		static_assert(std::is_copy_constructible_v<Shared>);
		static_assert(std::is_copy_assignable_v<Shared>);
	}

	TEST_F(WorldPointerTest, GuardStaticInvariants_SharedHasNoPublicRawPointerCtor) {
		// A Shared can only be obtained by passing through an Owning (or
		// from another Shared/Borrowed via the friended internal ctor).
		// Constructing one directly from a raw `T*` would let user code
		// bypass the affine pipeline and break the "one Owning per object"
		// invariant.
		static_assert(!std::is_constructible_v<Shared, Probe*>);
		static_assert(!std::is_constructible_v<Borrowed, Probe*>);
		static_assert(!std::is_constructible_v<Owning, Probe*>);
	}

	TEST_F(WorldPointerTest, GuardStaticInvariants_NoConversionBackToOwning) {
		static_assert(!std::is_convertible_v<Shared, Owning>);
		static_assert(!std::is_convertible_v<Borrowed, Owning>);
		static_assert(!std::is_assignable_v<Owning &, const Shared &>);
		static_assert(!std::is_assignable_v<Owning &, const Borrowed &>);
	}

	TEST_F(WorldPointerTest, GuardStaticInvariants_StandardLayoutEquivalence) {
		// All four wrappers must share an identical bit-pattern layout
		// (one `T* inner_`). Required so the intrusive offsetof recovery
		// works the same regardless of which wrapper holds the source.
		static_assert(std::is_standard_layout_v<Owning>);
		static_assert(std::is_standard_layout_v<Borrowed>);
		static_assert(std::is_standard_layout_v<Shared>);
		static_assert(sizeof(Owning) == sizeof(Probe*), "WorldPtr wrappers are intended to be 1 pointer wide");
		static_assert(sizeof(Borrowed) == sizeof(Probe*));
		static_assert(sizeof(Shared) == sizeof(Probe*));
	}

	TEST_F(WorldPointerTest, GuardStaticInvariants_BlockForwardingCtorRejectsSelf) {
		// `requires` clause on Block's variadic forwarding ctor (added by
		// the SonarCloud cpp:S6458 fix). Without it, `Block(other_block)`
		// would silently outcompete the implicit copy/move ctors and try
		// to forward `other_block` as `value(other_block)` — which only
		// "works" if T is constructible from Block (and produces nonsense
		// when it is).
		using B = WorldPtr<Probe>::Block;
		static_assert(!std::is_constructible_v<B, B &>, "Block forwarding ctor must reject self-reference");
		static_assert(!std::is_constructible_v<B, const B &>, "Block forwarding ctor must reject const self-reference");
		static_assert(!std::is_constructible_v<B, B &&>, "Block forwarding ctor must reject self-rvalue");
	}

	TEST_F(WorldPointerTest, GuardStaticInvariants_OwningMakeReturnsOwning) {
		using Ret = decltype(Owning::make(0));
		static_assert(std::is_same_v<Ret, Owning>);
	}

	TEST_F(PolyPointerTest, GuardStaticInvariants_OwningIsMoveOnly) {
		using O = PolyPtr<PolyBase>::Owning;
		static_assert(!std::is_copy_constructible_v<O>, "PolyPtr<T>::Owning must be move-only");
		static_assert(!std::is_copy_assignable_v<O>, "PolyPtr<T>::Owning must be move-only");
		static_assert(std::is_move_constructible_v<O>);
		static_assert(std::is_move_assignable_v<O>);
	}

	TEST_F(PolyPointerTest, GuardStaticInvariants_BorrowedSharedWeakAreCopyable) {
		static_assert(std::is_copy_constructible_v<PolyPtr<PolyBase>::Borrowed>);
		static_assert(std::is_copy_constructible_v<PolyPtr<PolyBase>::Shared>);
		static_assert(std::is_copy_constructible_v<PolyPtr<PolyBase>::Weak>);
		static_assert(std::is_copy_assignable_v<PolyPtr<PolyBase>::Borrowed>);
		static_assert(std::is_copy_assignable_v<PolyPtr<PolyBase>::Shared>);
		static_assert(std::is_copy_assignable_v<PolyPtr<PolyBase>::Weak>);
	}

	TEST_F(PolyPointerTest, GuardStaticInvariants_NoSharedFromRawPointer) {
		static_assert(!std::is_constructible_v<PolyPtr<PolyBase>::Shared, PolyBase*>);
		static_assert(!std::is_constructible_v<PolyPtr<PolyBase>::Owning, PolyBase*>);
	}

	TEST_F(PolyPointerTest, GuardStaticInvariants_NoConversionBackToOwning) {
		using O = PolyPtr<PolyBase>::Owning;
		static_assert(!std::is_convertible_v<PolyPtr<PolyBase>::Shared, O>);
		static_assert(!std::is_convertible_v<PolyPtr<PolyBase>::Borrowed, O>);
		static_assert(!std::is_convertible_v<PolyPtr<PolyBase>::Weak, O>);
	}

	TEST_F(PolyPointerTest, GuardStaticInvariants_WeakFromBorrowedIsExplicit) {
		// `Weak(Borrowed)` is explicit — implicit conversion would let a
		// tick-bound Borrowed silently extend its observability across
		// the next QSBR drain. Callers must opt in via direct-init.
		static_assert(std::is_constructible_v<PolyPtr<PolyBase>::Weak, PolyPtr<PolyBase>::Borrowed>);
		static_assert(!std::is_convertible_v<PolyPtr<PolyBase>::Borrowed, PolyPtr<PolyBase>::Weak>, "Weak(Borrowed) must be explicit");
	}

	TEST_F(PolyPointerTest, GuardStaticInvariants_CrossTypeOwningRequiresRvalue) {
		// `Owning<Derived>` → `Owning<Base>` is allowed for rvalues
		// (move) but NOT for lvalues (would let two Ownings coexist on
		// the same pointee — breaks affine).
		static_assert(std::is_constructible_v<
					  PolyPtr<PolyBase>::Owning,
					  PolyPtr<PolyDerived>::Owning &&>);
		static_assert(!std::is_constructible_v<PolyPtr<PolyBase>::Owning, const PolyPtr<PolyDerived>::Owning &>, "Cross-type Owning copy would break the affine invariant");
	}

	// Note: there's no static_assert test for `poly_header_` being
	// inaccessible from outside `enable_borrowed_from_this`. The C++20
	// standard says `requires(T t) { t.poly_header_; }` should evaluate
	// to false when access fails, but GCC 13 emits a hard "protected
	// within this context" error instead of treating the requirement
	// as unsatisfied (MSVC accepts the same code). The protection is
	// still enforced by the `protected:` access specifier in
	// `enable_borrowed_from_this` itself — there's just no
	// SFINAE-style negative test we can portably write to document it.

	// =====================================================================
	// Death tests — verify the runtime guards (`assert(get() != nullptr)`
	// on dereference, etc.) actually abort instead of silently letting
	// the program walk off into UB.
	//
	// COMPILED OUT IN RELEASE (`NDEBUG`). The standard `assert()` macro
	// expands to a no-op when NDEBUG is defined, so a release build with
	// the test suite enabled would either:
	//   (a) optimize the dereference away — `(void)*p;` has no observable
	//       effect — and the test would fail (no death observed); or
	//   (b) segfault by chance, which counts as death but is fragile and
	//       depends on the compiler not eliding the load.
	// Compiling these out keeps the suite clean against `cmake
	// --preset windows-release -DBUILD_TESTING=ON` builds.
	//
	// `EXPECT_DEATH_IF_SUPPORTED` also quietly skips on platforms without
	// fork-based death testing.
	//
	// gtest convention: fixtures with the `DeathTest` suffix run BEFORE
	// non-death fixtures — death-test forks should happen while the
	// process is still single-threaded.
	// =====================================================================
#ifndef NDEBUG

	class WorldPointerDeathTest : public WorldPointerTest { };

	TEST_F(WorldPointerDeathTest, Owning_DerefNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			Owning p;
			(void)*p;
		},
		                          ".*");
	}

	TEST_F(WorldPointerDeathTest, Owning_ArrowNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			Owning p;
			(void)p->value;
		},
		                          ".*");
	}

	TEST_F(WorldPointerDeathTest, Borrowed_DerefNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			Borrowed b;
			(void)*b;
		},
		                          ".*");
	}

	TEST_F(WorldPointerDeathTest, Borrowed_ArrowNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			Borrowed b;
			(void)b->value;
		},
		                          ".*");
	}

	TEST_F(WorldPointerDeathTest, Shared_DerefNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			Shared s;
			(void)*s;
		},
		                          ".*");
	}

	TEST_F(WorldPointerDeathTest, Shared_ArrowNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			Shared s;
			(void)s->value;
		},
		                          ".*");
	}

	TEST_F(WorldPointerDeathTest, Shared_UseCountOnNullValue_Asserts) {
		// `useCount()` asserts non-null — reading the refcount through a
		// null `inner_` would compute `getBlock()` off of a null base and
		// dereference a wild pointer.
		EXPECT_DEATH_IF_SUPPORTED({
			Shared s;
			(void)s.useCount();
		},
		                          ".*");
	}

	class PolyPointerDeathTest : public PolyPointerTest { };

	TEST_F(PolyPointerDeathTest, Owning_DerefNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			PolyPtr<PolyBase>::Owning p;
			(void)*p;
		},
		                          ".*");
	}

	TEST_F(PolyPointerDeathTest, Owning_ArrowNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			PolyPtr<PolyBase>::Owning p;
			(void)p->base_value;
		},
		                          ".*");
	}

	TEST_F(PolyPointerDeathTest, Borrowed_DerefNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			PolyPtr<PolyBase>::Borrowed b;
			(void)*b;
		},
		                          ".*");
	}

	TEST_F(PolyPointerDeathTest, Shared_DerefNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			PolyPtr<PolyBase>::Shared s;
			(void)*s;
		},
		                          ".*");
	}

	TEST_F(PolyPointerDeathTest, Shared_UseCountOnNullValue_Asserts) {
		EXPECT_DEATH_IF_SUPPORTED({
			PolyPtr<PolyBase>::Shared s;
			(void)s.useCount();
		},
		                          ".*");
	}

#endif // !NDEBUG

} // namespace
