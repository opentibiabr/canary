#include "pch.hpp"

#include <boost/ut.hpp>

#include "lib/logging/in_memory_logger.hpp"

#include "items/containers/container.hpp"

using namespace boost::ut;

suite<"ContainerIteratorTest"> containerIteratorTest = [] {
    di::extension::injector<> injector{};
    DI::setTestContainer(&InMemoryLogger::install(injector));
    auto& logger = dynamic_cast<InMemoryLogger&>(injector.create<Logger&>());

    auto createNestedContainers = [](size_t depth, size_t itemsPerContainer) -> std::shared_ptr<Container> {
        if (depth == 0) {
            return std::make_shared<Container>(ITEM_SHOPPING_BAG);
        }

        auto container = std::make_shared<Container>(ITEM_SHOPPING_BAG);
        for (size_t i = 0; i < itemsPerContainer; ++i) {
            auto item = Item::CreateItem(ITEM_GOLD_COIN, 1);
            container->addItem(item);
        }

        auto nestedContainer = createNestedContainers(depth - 1, itemsPerContainer);
        container->addItem(nestedContainer);

        return container;
    };

    test("ContainerIterator performance com contêineres profundamente aninhados") = [&]() {
        size_t depth = 100;
        size_t itemsPerContainer = 10;

        auto rootContainer = createNestedContainers(depth, itemsPerContainer);

        auto startTime = std::chrono::high_resolution_clock::now();

        size_t itemCount = 0;
        ContainerIterator iterator = rootContainer->iterator();
        while (iterator.hasNext()) {
            auto item = *iterator;
            ++itemCount;

            iterator.advance();
        }

        auto endTime = std::chrono::high_resolution_clock::now();

        auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime).count();

        logger.info("Percorridos {} itens em {} milissegundos.", itemCount, duration);

        size_t expectedItemCount = (itemsPerContainer + 1) * depth;

        expect(itemCount == expectedItemCount) << "Contagem de itens esperada: " << expectedItemCount << ", Obtida: " << itemCount;
    };
};
