/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_UTILS_LOCKFREE_H_
#define SRC_UTILS_LOCKFREE_H_

#if _MSC_FULL_VER >= 190023918 // Workaround for VS2015 Update 2. Boost.Lockfree is a header-only library, so this should be safe to do.
#define _ENABLE_ATOMIC_ALIGNMENT_FIX
#endif

#include <boost/lockfree/stack.hpp>

/*
 * we use this to avoid instantiating multiple free lists for objects of the
 * same size and it can be replaced by a variable template in C++14
 *
 * template <std::size_t TSize, size_t CAPACITY>
 * boost::lockfree::stack<void*, boost::lockfree::capacity<CAPACITY> lockfreeFreeList;
 */
template <std::size_t TSize, size_t CAPACITY>
struct LockfreeFreeList
{
	using FreeList = boost::lockfree::stack<void*, boost::lockfree::capacity<CAPACITY>>;
	static FreeList& get()
	{
		static FreeList freeList;
		return freeList;
	}
};

template <typename T, size_t CAPACITY>
class LockfreePoolingAllocator : public std::allocator<T>
{
	public:
		LockfreePoolingAllocator() = default;

		template <typename U, class = typename std::enable_if<!std::is_same<U, T>::value>::type>
		explicit constexpr LockfreePoolingAllocator(const U&) {}
		using value_type = T;

		T* allocate(size_t) const {
			auto& inst = LockfreeFreeList<sizeof(T), CAPACITY>::get();
			void* p; // NOTE: p doesn't have to be initialized
			if (!inst.pop(p)) {
				//Acquire memory without calling the constructor of T
				p = operator new (sizeof(T));
			}
			return static_cast<T*>(p);
		}

		void deallocate(T* p, size_t) const {
			auto& inst = LockfreeFreeList<sizeof(T), CAPACITY>::get();
			if (!inst.bounded_push(p)) {
				//Release memory without calling the destructor of T
				//(it has already been called at this point)
				operator delete(p);
			}
		}
};

#endif  // SRC_UTILS_LOCKFREE_H_
