#include <filesystem>
#include <iostream>

void runWorldFileTests(const std::filesystem::path &scratch);
void runWorldV2Tests(const std::filesystem::path &scratch);

int main(int argc, char** argv) {
	try {
		if (argc != 2) {
			return 2;
		}
		const auto root = std::filesystem::absolute(argv[1]);
		std::filesystem::create_directories(root);
		runWorldFileTests(root);
		runWorldV2Tests(root);
		std::cout << "World file publication, concurrency and recovery contracts passed\n";
		return 0;
	} catch (const std::exception &error) {
		std::cerr << error.what() << '\n';
		return 1;
	}
}
