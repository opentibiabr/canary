import os
import re
import json

BASE_DIR = os.getcwd()
MONSTERS_DIR = BASE_DIR
CACHE_PATH = os.path.join(BASE_DIR, "cache.json")

def load_cache():
    try:
        with open(CACHE_PATH, encoding="utf8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}

def save_cache(cache):
    with open(CACHE_PATH, "w", encoding="utf8") as f:
        json.dump(cache, f, ensure_ascii=False, indent=2)

def clean_lua_loot(path):
    """Remove loot vazio (id = 0, chance = 1000) do arquivo .lua"""
    try:
        with open(path, encoding="utf8") as f:
            data = f.read()

        # padrão de loot falso
        pattern = (
            r"monster\.loot\s*=\s*\{\s*\{\s*id\s*=\s*0\s*,\s*chance\s*=\s*1000\s*\}\s*,?\s*--\s*This creature drops no loot\.\s*\}"
        )

        if re.search(pattern, data, flags=re.S):
            # substitui pelo bloco vazio
            new_data = re.sub(pattern, "monster.loot = {\n\n}", data, flags=re.S)
            with open(path, "w", encoding="utf8") as f:
                f.write(new_data)
            print(f"🧽 Limpou loot vazio em: {os.path.basename(path)}")
            return True
        return False
    except Exception as e:
        print(f"⚠️ Erro ao limpar {path}: {e}")
        return False

def main():
    print("🧹 Limpando loots vazios em arquivos Lua e cache...\n")

    cache = load_cache()
    changed_lua = 0
    changed_cache = 0

    # Limpa arquivos Lua
    for root, dirs, files in os.walk(MONSTERS_DIR):
        for file in files:
            if not file.endswith(".lua"):
                continue
            path = os.path.join(root, file)
            if clean_lua_loot(path):
                changed_lua += 1

    # Limpa cache (zera entradas com apenas loot vazio)
    cleaned_monsters = []
    for monster, loots in list(cache.items()):
        if (
            isinstance(loots, list)
            and len(loots) == 1
            and loots[0].get("id") == "0"
            and loots[0].get("chance") == 1000
        ):
            cache[monster] = []
            cleaned_monsters.append(monster)

    if cleaned_monsters:
        changed_cache = len(cleaned_monsters)
        save_cache(cache)
        print(f"\n🧾 Cache atualizado: {changed_cache} monstros limpos ({', '.join(cleaned_monsters)})")

    # Resumo final
    print("\n📊 Resumo da limpeza:")
    print(f" • Arquivos Lua limpos: {changed_lua}")
    print(f" • Monstros limpos no cache: {changed_cache}")

    if changed_lua == 0 and changed_cache == 0:
        print("✅ Nenhum loot vazio encontrado.")
    else:
        print("✨ Limpeza concluída com sucesso!")

if __name__ == "__main__":
    main()
