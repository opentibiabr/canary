/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

// Inclua as constantes necessárias do mapa
#include "map/map_const.hpp"

// Declarações antecipadas das classes utilizadas
class Creature;
class Tile;
struct BasicTile;

/**
 * @brief Representa um piso no mapa.
 */
struct Floor {
	/**
	 * @brief Construtor que inicializa o piso com um nível específico.
	 * @param z Nível do piso.
	 */
	explicit Floor(uint8_t z) :
		z(z) { }

	/**
	 * @brief Obtém o Tile em uma posição específica.
	 * @param x Coordenada x.
	 * @param y Coordenada y.
	 * @return Ponteiro compartilhado para o Tile.
	 */
	std::shared_ptr<Tile> getTile(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK].first;
	}

	/**
	 * @brief Define o Tile em uma posição específica.
	 * @param x Coordenada x.
	 * @param y Coordenada y.
	 * @param tile Novo Tile a ser definido.
	 */
	void setTile(uint16_t x, uint16_t y, std::shared_ptr<Tile> tile) {
		std::unique_lock<std::shared_mutex> ul(mutex);
		tiles[x & SECTOR_MASK][y & SECTOR_MASK].first = std::move(tile);
	}

	/**
	 * @brief Obtém o BasicTile cacheado em uma posição específica.
	 * @param x Coordenada x.
	 * @param y Coordenada y.
	 * @return Ponteiro compartilhado para o BasicTile.
	 */
	std::shared_ptr<BasicTile> getTileCache(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK].second;
	}

	/**
	 * @brief Define o BasicTile cacheado em uma posição específica.
	 * @param x Coordenada x.
	 * @param y Coordenada y.
	 * @param newTile Novo BasicTile a ser definido.
	 */
	void setTileCache(uint16_t x, uint16_t y, const std::shared_ptr<BasicTile> &newTile) {
		std::unique_lock<std::shared_mutex> ul(mutex);
		tiles[x & SECTOR_MASK][y & SECTOR_MASK].second = newTile;
	}

	/**
	 * @brief Obtém uma referência constante para a matriz de tiles.
	 * @return Referência constante para a matriz de tiles.
	 */
	const auto &getTiles() const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles;
	}

	/**
	 * @brief Obtém o nível do piso.
	 * @return Nível do piso.
	 */
	uint8_t getZ() const {
		return z;
	}

private:
	// Matriz de pares de ponteiros compartilhados para Tile e BasicTile
	std::pair<std::shared_ptr<Tile>, std::shared_ptr<BasicTile>> tiles[SECTOR_SIZE][SECTOR_SIZE] = {};

	// Mutex para proteger o acesso à matriz de tiles
	mutable std::shared_mutex mutex;

	// Nível do piso
	uint8_t z { 0 };
};

/**
 * @brief Representa uma seção do mapa contendo múltiplos pisos e criaturas.
 */
class MapSector {
public:
	/**
	 * @brief Construtor padrão.
	 */
	MapSector() = default;

	// Desabilita a cópia e a movimentação
	MapSector(const MapSector &) = delete;
	MapSector &operator=(const MapSector &) = delete;
	MapSector(const MapSector &&) = delete;
	MapSector &operator=(const MapSector &&) = delete;

	/**
	 * @brief Cria um piso em um nível específico, se ainda não existir.
	 * @param z Nível do piso a ser criado.
	 * @return Ponteiro compartilhado para o Floor criado ou existente.
	 * @throws std::out_of_range se o índice estiver fora dos limites.
	 */
	std::shared_ptr<Floor> createFloor(uint32_t z) {
		if (z >= MAP_MAX_LAYERS) {
			throw std::out_of_range("Índice de piso fora dos limites.");
		}
		std::lock_guard<std::mutex> lock(floors_mutex);
		if (!floors[z]) {
			floors[z] = std::make_shared<Floor>(static_cast<uint8_t>(z));
		}
		return floors[z];
	}

	/**
	 * @brief Obtém o piso em um nível específico.
	 * @param z Nível do piso a ser obtido.
	 * @return Ponteiro compartilhado para o Floor, ou nullptr se não existir.
	 * @throws std::out_of_range se o índice estiver fora dos limites.
	 */
	std::shared_ptr<Floor> getFloor(uint8_t z) const {
		if (z >= MAP_MAX_LAYERS) {
			throw std::out_of_range("Índice de piso fora dos limites.");
		}
		std::lock_guard<std::mutex> lock(floors_mutex);
		return floors[z];
	}

	/**
	 * @brief Adiciona uma criatura à lista de criaturas.
	 * @param c Ponteiro compartilhado para a criatura a ser adicionada.
	 */
	void addCreature(const std::shared_ptr<Creature> &c);

	/**
	 * @brief Remove uma criatura da lista de criaturas.
	 * @param c Ponteiro compartilhado para a criatura a ser removada.
	 */
	void removeCreature(const std::shared_ptr<Creature> &c);

private:
	// Variável estática que deve ser definida em um arquivo .cpp correspondente
	static bool newSector;

	// Ponteiros para setores adjacentes (podem ser gerenciados de forma mais segura, se necessário)
	MapSector* sectorS = nullptr;
	MapSector* sectorE = nullptr;

	// Listas de criaturas e jogadores presentes neste setor
	std::vector<std::shared_ptr<Creature>> creature_list;
	std::vector<std::shared_ptr<Creature>> player_list;

	// Mutex para proteger o acesso ao array de floors
	mutable std::mutex floors_mutex;

	// Array de ponteiros compartilhados para os pisos deste setor
	std::shared_ptr<Floor> floors[MAP_MAX_LAYERS] = {};

	// Bits representando quais pisos estão ativos
	uint32_t floorBits = 0;

	// Classes amigas que podem acessar membros privados
	friend class Spectators;
	friend class MapCache;
};
