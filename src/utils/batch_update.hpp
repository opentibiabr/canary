#pragma once

class Player;
class Container;

class BatchUpdate : public SharedObject {
public:
	explicit BatchUpdate(Player* actor);
	bool add(Container* rawContainer);
	void addContainers(const std::vector<Container*> &containerVector);
	~BatchUpdate();

private:
	Player* m_actor;
	std::vector<Container*> m_cached;
};
