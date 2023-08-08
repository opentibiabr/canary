#ifndef SRC_GAME_BANK_BANK_HPP_
#define SRC_GAME_BANK_BANK_HPP_

class Player;
class Guild;

class Bankable {
	public:
		virtual void setBankBalance(uint64_t amount) = 0;
		virtual uint64_t getBankBalance() const = 0;
		virtual ~Bankable() = default;
		virtual Player* getPlayer() {
			return nullptr;
		}
		virtual Guild* getGuild() {
			return nullptr;
		}
		virtual void setOnline(bool online) = 0;
		virtual bool isOnline() const = 0;
};

class Bank {
	public:
		explicit Bank(Bankable* bankable);
		~Bank();

		// Deleted copy constructor and assignment operator.
		Bank(const Bank &) = delete;
		Bank &operator=(const Bank &) = delete;

		// Bank functions by Bankable pointer; these are the only ones that should actually perform any logic.
		bool credit(uint64_t amount);
		bool debit(uint64_t amount);
		bool balance(uint64_t amount);
		uint64_t balance();
		bool hasBalance(uint64_t amount);
		bool transferTo(std::shared_ptr<Bank> &destination, uint64_t amount);
		bool withdraw(Player* player, uint64_t amount);
		bool deposit(std::shared_ptr<Bank> &destination);
		bool deposit(std::shared_ptr<Bank> &destination, uint64_t amount);

	private:
		Bankable* bankable;
};

#endif // SRC_GAME_BANK_BANK_HPP_
