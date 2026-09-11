#include "lua/docgen/lua_api_doc_generator.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <chrono>
	#include <fstream>
	#include <gtest/gtest.h>
#endif

TEST(LuaBindingScannerTest, TypedRegistrationUsesTraitNameAndConstructorDocumentationAcrossFiles) {
	const auto root = std::filesystem::temp_directory_path() / ("canary-docgen-typed-" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
	ASSERT_TRUE(std::filesystem::create_directory(root));
	struct Cleanup {
		std::filesystem::path root;
		~Cleanup() {
			std::error_code error;
			std::filesystem::remove_all(root, error);
		}
	} cleanup { root };
	std::filesystem::create_directory(root / "src");
	{
		std::ofstream source(root / "src/a_binding.cpp");
		source << R"cpp(
		void init(lua_State* L) {
			Lua::registerSharedClass<ServerObject>(L, "", Functions::create);
			Lua::registerMethod(L, "EditorObject", "name", Functions::name);
		}
		/***
		 * @class EditorObject
		 * @overload fun(id: string): EditorObject
		 */
		int Functions::create(lua_State* L) { return 1; }
		/***
		 * @function EditorObject:name
		 * @return string
		 */
		int Functions::name(lua_State* L) { return 1; }
		)cpp";
		ASSERT_TRUE(source.good());
	}
	{
		std::ofstream traits(root / "src/z_traits.hpp");
		traits << R"cpp(template <> struct LuaUserdataTraits<ServerObject> { static constexpr std::string_view name = "EditorObject"; };)cpp";
		ASSERT_TRUE(traits.good());
	}
	const auto scanned = LuaBindingScanner(root).scan();
	EXPECT_TRUE(scanned.classes.contains("EditorObject"));
	EXPECT_FALSE(scanned.classes.contains("ServerObject"));
	ASSERT_TRUE(scanned.classOverloads.contains("EditorObject"));
	EXPECT_EQ(scanned.classOverloads.at("EditorObject"), (std::vector<std::string> { "fun(id: string): EditorObject" }));
	ASSERT_EQ(scanned.functions.size(), 1);
	EXPECT_EQ(scanned.functions.front().className, "EditorObject");
	EXPECT_EQ(scanned.functions.front().sourceFile, "src/a_binding.cpp");
	EXPECT_TRUE(scanned.functions.front().hasExplicitDocumentation);
}
