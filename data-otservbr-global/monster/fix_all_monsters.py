import os
import re
import requests
import json
import difflib
from bs4 import BeautifulSoup
from collections import defaultdict

# Diretório base e paths
BASE_DIR = os.getcwd()
MONSTERS_DIR = BASE_DIR
CACHE_PATH = os.path.join(BASE_DIR, "cache.json")

# Caminho e cache do índice global de Item IDs
ITEM_INDEX_PATH = os.path.join(BASE_DIR, "item_ids_index.json")
ITEM_INDEX = {}

# Dicionário de itemid conhecidos
KNOWN_ITEM_IDS = {
    "Ironworker": {"id": "8025", "original_name": "The Ironworker"},
    "Rusty Armor": {"id": "8894", "original_name": "Rusted Armor"},
    "Zaoan Monk Robe": {"id": "50259", "original_name": "Zaoan Monk Robe"}
}

# Funções utilitárias
def load_cache():
    try:
        with open(CACHE_PATH, encoding="utf8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {}

def save_cache(cache):
    with open(CACHE_PATH, "w", encoding="utf8") as f:
        json.dump(cache, f, ensure_ascii=False, indent=2)

# Funções para índice Item_IDs
def load_item_index():
    """Carrega o índice local de item ids (se existir)."""
    global ITEM_INDEX
    try:
        with open(ITEM_INDEX_PATH, "r", encoding="utf8") as f:
            ITEM_INDEX = json.load(f)
            return ITEM_INDEX
    except (FileNotFoundError, json.JSONDecodeError):
        ITEM_INDEX = {}
        return ITEM_INDEX

def save_item_index(index):
    """Salva o índice localmente para evitar downloads repetidos."""
    try:
        with open(ITEM_INDEX_PATH, "w", encoding="utf8") as f:
            json.dump(index, f, ensure_ascii=False, indent=2)
    except Exception as e:
        print(f"⚠️ Erro ao salvar item index: {e}")

def build_item_index_from_fandom(force=False):
    """
    Tenta construir o índice a partir de https://tibia.fandom.com/wiki/Item_IDs
    Usa heurísticas robustas para extrair nome -> id.
    """
    global ITEM_INDEX
    if ITEM_INDEX and not force:
        return ITEM_INDEX

    idx = load_item_index()
    if idx and not force:
        ITEM_INDEX = idx
        return ITEM_INDEX

    url = "https://tibia.fandom.com/wiki/Item_IDs"
    print(f"📡 Baixando índice global de Item_IDs de {url} ...")
    try:
        r = requests.get(url, timeout=20)
        if r.status_code != 200:
            print(f"⚠️ Falha ao acessar Item_IDs: status {r.status_code}")
            return ITEM_INDEX
        soup = BeautifulSoup(r.text, "html.parser")

        tables = soup.find_all("table")
        found = {}
        for table in tables:
            headers = [th.get_text(" ", strip=True).lower() for th in table.find_all("th")]
            if not headers or not (any("item" in h for h in headers) and any("id" in h for h in headers)):
                continue

            for tr in table.find_all("tr"):
                cols = [td.get_text(" ", strip=True) for td in tr.find_all(["td", "th"])]
                if len(cols) < 2:
                    continue

                id_candidate = None
                name_candidate = None
                # Tenta encontrar o ID
                for c in cols:
                    m = re.search(r'\b(\d{3,6})\b', c)
                    if m:
                        id_candidate = m.group(1)
                        break

                # Tenta encontrar o nome
                a = tr.find("a")
                if a and a.get("title") and not a.get("title").lower().startswith("update"):
                    name_candidate = a.get("title").strip()
                elif a and a.get_text(strip=True):
                    name_candidate = a.get_text(" ", strip=True)
                else:
                    for c in cols:
                        if not re.search(r'^\d+$', c) and c.lower() not in ("item", "item id", "id", ""):
                            name_candidate = c.strip()
                            break

                if id_candidate and name_candidate:
                    found[name_candidate] = {"id": id_candidate, "original_name": name_candidate}
                else:
                    print(f"⚠️ Linha ignorada: ID={id_candidate}, Nome={name_candidate}")

        if found:
            ITEM_INDEX = found
            save_item_index(ITEM_INDEX)
            print(f"✅ Índice construído com {len(ITEM_INDEX)} entradas e salvo em {ITEM_INDEX_PATH}")
        else:
            print("⚠️ Não foi possível extrair entradas da página Item_IDs (estrutura inesperada).")
        return ITEM_INDEX

    except Exception as e:
        print(f"⚠️ Erro ao construir índice de Item_IDs: {e}")
        return ITEM_INDEX

def get_monster_name_from_lua(path):
    try:
        with open(path, encoding="utf8") as f:
            for line in f:
                match = re.search(r'Game\.createMonsterType\(["\'](.+?)["\']\)', line)
                if match:
                    return match.group(1)
        return None
    except FileNotFoundError:
        print(f"Erro: Arquivo {path} não encontrado!")
        return None

def resolve_item_local(orig_page):
    """Resolve nome e id localmente, sem acessar o site."""
    # 1️⃣ Checar overrides manuais
    if orig_page in KNOWN_ITEM_IDS:
        return KNOWN_ITEM_IDS[orig_page]['id'], KNOWN_ITEM_IDS[orig_page]['original_name']

    # 2️⃣ Checar item_ids_index.json
    if not ITEM_INDEX:
        load_item_index()

    # Match direto
    if orig_page in ITEM_INDEX:
        entry = ITEM_INDEX[orig_page]
        return entry["id"], entry["original_name"]

    # 3️⃣ Tentativa aproximada
    matches = difflib.get_close_matches(orig_page, ITEM_INDEX.keys(), n=1, cutoff=0.92)
    if matches:
        entry = ITEM_INDEX[matches[0]]
        print(f"🔧 Correspondência local aproximada: {orig_page} ≈ {entry['original_name']} ({entry['id']})")
        return entry["id"], entry["original_name"]

    # 4️⃣ Falhou, retorna id=0
    return "0", orig_page


def get_loot_statistics(monster_name):
    stats_url = f"https://tibia.fandom.com/wiki/Loot_Statistics:{monster_name.replace(' ', '_')}"
    try:
        r = requests.get(stats_url, timeout=15)
        if r.status_code != 200:
            print(f"⚠️ Falha ao acessar {stats_url}: Status {r.status_code}")
            return None
        soup = BeautifulSoup(r.text, "html.parser")
        tables = soup.find_all("table", class_="loot_list") or soup.find_all("table")
        if not tables:
            print(f"⚠️ Nenhuma tabela de loot encontrada para {monster_name}")
            return None

        chance_data = defaultdict(lambda: {'total_chance': 0, 'total_chests': 0, 'item_data': None, 'max_counts': [], 'total_amounts': 0, 'total_times': 0})

        for table in tables:
            caption_text = ""
            caption = table.find("caption")
            if caption:
                caption_text = caption.get_text(" ", strip=True).lower()
            else:
                prev_elem = table.previous_sibling
                while prev_elem:
                    if prev_elem.name == 'p':
                        caption_text = prev_elem.get_text(" ", strip=True).lower()
                        break
                    prev_elem = prev_elem.previous_sibling

            chests_match = re.search(r'(\d+)\s+(?:reward\s+)?(?:chests?|kills?)', caption_text) or re.search(r'(\d+)', caption_text)
            if not chests_match:
                continue
            num_chests = int(chests_match.group(1))

            headers = [th.get_text(strip=True).lower() for th in table.find_all("th")]
            times_idx = headers.index("times") if "times" in headers else None
            perc_idx = headers.index("percentage") if "percentage" in headers else None
            amount_idx = headers.index("amount") if "amount" in headers else None
            total_amount_idx = headers.index("total amount") if "total amount" in headers else None
            item_col = headers.index("item") if "item" in headers else 2

            rows = table.find_all("tr")[1:]
            for row in rows:
                cols = [c.get_text(strip=True) for c in row.find_all("td")]
                if len(cols) < 3:
                    continue

                item_title = None
                for c in row.find_all("a"):
                    title = c.get("title")
                    if title and not title.lower().startswith("update"):
                        item_title = title
                        break
                item_name = item_title or cols[item_col]

                if "soul core" in item_name.lower():
                    continue

                if "empty" in item_name.lower():
                    continue

                try:
                    perc_value = 0
                    if perc_idx is not None:
                        perc_text = cols[perc_idx].replace('%', '').strip()
                        perc_value = float(perc_text)
                        if perc_value > 100.0:
                            continue
                    elif times_idx is not None:
                        times_text = cols[times_idx].strip()
                        times_dropped = int(times_text) if times_text.isdigit() else 0
                        perc_value = (times_dropped / num_chests) * 100 if num_chests > 0 else 0
                        chance_data[item_name]['total_times'] += times_dropped

                    chance_data[item_name]['total_chance'] += perc_value * num_chests
                    chance_data[item_name]['total_chests'] += num_chests

                    if amount_idx is not None:
                        amount_text = cols[amount_idx].strip()
                        max_this = 1
                        if amount_text != '-':
                            range_match = re.match(r'(\d+)-(\d+)', amount_text)
                            if range_match:
                                max_this = int(range_match.group(2))
                            elif amount_text.isdigit():
                                max_this = int(amount_text)
                        chance_data[item_name]['max_counts'].append(max_this)

                    if total_amount_idx is not None and cols[total_amount_idx] != '-':
                        total_amt = int(cols[total_amount_idx])
                        chance_data[item_name]['total_amounts'] += total_amt

                    chance_data[item_name]['item_data'] = {
                        "original_page": item_name
                    }
                except (ValueError, IndexError) as e:
                    print(f"⚠️ Erro ao processar linha para {item_name}: {e}")
                    continue

        if not chance_data:
            print(f"⚠️ Nenhum dado de loot válido encontrado para {monster_name}")
            return None

        item_data = {}
        for name, data in chance_data.items():
            if data['total_chests'] > 0:
                avg_chance = data['total_chance'] / data['total_chests']
                max_count = max(data['max_counts']) if data['max_counts'] else 1
                item_data[name] = {
                    "chance": int(avg_chance * 1000),
                    "original_page": data['item_data']['original_page'],
                    "max_count": max_count
                }
        return item_data
    except Exception as e:
        print(f"⚠️ Erro ao processar estatísticas de loot para {monster_name}: {e}")
        return None

def get_loot_html_from_fandom(monster_name):
    url_name = monster_name.replace(" ", "_")
    urls = [
        f"https://tibia.fandom.com/wiki/{url_name}",
        f"https://tibia.fandom.com/wiki/{url_name}_(Creature)"
    ]
    for url in urls:
        try:
            r = requests.get(url, timeout=10)
            if r.status_code == 200:
                soup = BeautifulSoup(r.text, "html.parser")
                loot_div = soup.find("div", class_="loot-table")
                if loot_div:
                    return loot_div
                loot_ul = soup.find("ul", class_="loot")
                if loot_ul:
                    return loot_ul
                print(f"⚠️ Nenhuma loot-table ou ul.loot encontrada em {url}")
            else:
                print(f"⚠️ Falha ao acessar {url}: Status {r.status_code}")
        except requests.RequestException as e:
            print(f"⚠️ Erro ao acessar {url}: {e}")
            continue
    return None

def parse_loot_html(html, loot_stats):
    loot_list = []
    elements = html.find_all("li") if html.name == 'ul' else html.find_all("li")
    for li in elements:
        if 'mw-empty-elt' in li.get('class', []):
            continue
        text = li.get_text(" ", strip=True)
        if not text:
            continue
        qty_match = re.match(r'(\d*)(?:-(\d*))?×?\s*', text)
        if qty_match:
            min_q_str = qty_match.group(1)
            max_q_str = qty_match.group(2)
            min_q = int(min_q_str) if min_q_str else 1
            max_q = int(max_q_str) if max_q_str else min_q
            item_text = text[qty_match.end():].strip()
        else:
            min_q = max_q = 1
            item_text = text
        a_tag = li.find("a")
        img_tag = li.find("img")
        if img_tag and img_tag.get("alt") and "Missing File" not in img_tag.get("alt"):
            page_title = img_tag.get("alt").strip()
        elif a_tag and a_tag.get("title") and not a_tag.get("title").lower().startswith("update"):
            page_title = a_tag.get("title").strip()
        else:
            page_title = item_text.strip()

        if "empty" in page_title.lower() or "missing file" in page_title.lower() or "soul core" in page_title.lower():
            continue

        chance = loot_stats.get(page_title, {}).get("chance", 1000) if loot_stats else 1000
        max_count = max_q

        loot_list.append({
            "chance": chance,
            "maxCount": max_count,
            "original_page": page_title
        })
    return loot_list

def update_lua_file(path, loot_list):
    try:
        with open(path, encoding="utf8") as f:
            data = f.read()
        if not loot_list:
            loot_block = "monster.loot = {\n\n}\n"
        else:
            loot_block = "monster.loot = {\n"
            for item in loot_list:
                item_id = item['id']
                chance = item['chance']
                max_count = item.get('maxCount', 1)
                original_name = item['original_name']
                if max_count > 1:
                    loot_block += f'\t{{ id = {item_id}, chance = {chance}, maxCount = {max_count} }}, -- {original_name}\n'
                else:
                    loot_block += f'\t{{ id = {item_id}, chance = {chance} }}, -- {original_name}\n'
            loot_block += "}\n"

        if re.search(r'monster\.loot\s*=\s*\{.*?\}\s*(?=\n|$)', data, flags=re.S):
            new_data = re.sub(r'monster\.loot\s*=\s*\{.*?\}\s*(?=\n|$)', loot_block, data, flags=re.S)
        else:
            m = re.search(r'\breturn\s+mType\b', data)
            if m:
                insert_pos = m.start()
                new_data = data[:insert_pos] + loot_block + "\n" + data[insert_pos:]
            else:
                new_data = data.rstrip() + "\n\n" + loot_block

        with open(path, "w", encoding="utf8") as f:
            f.write(new_data)

    except Exception as e:
        print(f"Erro ao atualizar {path}: {e}")

def main():
    print("🧙‍♂️ Iniciando atualização de loots...\n")

    cache = load_cache()
    load_item_index()

    # ⚔️ Lista de loots a serem desconsiderados (parciais ou exatos)
    IGNORE_LOOT_NAMES = {
        "Crystal Pedestal",     # ignora o sem cor
        "Music Sheet",          # entradas genéricas sem tipo
        "Watermelon Tourmaline" # caso apareça sem itemid válido
    }

    def resolve_item_local(orig_page):
        """Resolve nome e id localmente, sem acessar o site."""
        if orig_page in KNOWN_ITEM_IDS:
            return KNOWN_ITEM_IDS[orig_page]['id'], KNOWN_ITEM_IDS[orig_page]['original_name']

        if not ITEM_INDEX:
            load_item_index()

        if orig_page in ITEM_INDEX:
            entry = ITEM_INDEX[orig_page]
            return entry["id"], entry["original_name"]

        matches = difflib.get_close_matches(orig_page, ITEM_INDEX.keys(), n=1, cutoff=0.92)
        if matches:
            entry = ITEM_INDEX[matches[0]]
            print(f"🔧 Correspondência local aproximada: {orig_page} ≈ {entry['original_name']} ({entry['id']})")
            return entry["id"], entry["original_name"]

        return "0", orig_page

    for root, dirs, files in os.walk(MONSTERS_DIR):
        for file in files:
            if not file.endswith(".lua"):
                continue
            path = os.path.join(root, file)
            monster_name = get_monster_name_from_lua(path) or os.path.splitext(file)[0].capitalize()
            print(f"\n[BUSCANDO] {monster_name}...")

            loot_html = get_loot_html_from_fandom(monster_name)
            if not loot_html:
                print("⚠️ Nenhum loot HTML encontrado na página principal — loot vazio.")
                loot_list = []
            else:
                principal_loot = parse_loot_html(loot_html, None)
                principal_pages = {item['original_page'] for item in principal_loot}
                loot_stats = get_loot_statistics(monster_name)

                loot_list = []
                for item in principal_loot:
                    orig_page = item['original_page']

                    # 🧹 Ignorar loots inválidos (Crystal Pedestal, Music Sheet etc.)
                    if any(bad_name.lower() == orig_page.lower() for bad_name in IGNORE_LOOT_NAMES):
                        print(f"🚫 Ignorado loot inválido: {orig_page}")
                        continue

                    if loot_stats and orig_page in loot_stats:
                        item['chance'] = loot_stats[orig_page]['chance']
                    else:
                        item['chance'] = 1000
                    loot_list.append(item)

            # 🔄 Resolver IDs localmente (sem chamadas externas)
            if monster_name in cache:
                old_loot = cache[monster_name]
                old_by_page = {item.get('original_page'): item for item in old_loot}

                for item in loot_list:
                    orig_page = item['original_page']
                    if orig_page in old_by_page and old_by_page[orig_page].get("id") != "0":
                        old_item = old_by_page[orig_page]
                        item['id'] = old_item['id']
                        item['original_name'] = old_item['original_name']
                    else:
                        id_, name_ = resolve_item_local(orig_page)
                        item['id'] = id_
                        item['original_name'] = name_
                print(f"📦 Cache corrigido/localizado para {monster_name}: {len(loot_list)} itens.")
            else:
                for item in loot_list:
                    id_, name_ = resolve_item_local(item['original_page'])
                    item['id'] = id_
                    item['original_name'] = name_
                print(f"📦 Novo cache local para {monster_name}: {len(loot_list)} itens.")

            # 🧾 Salvar cache e atualizar Lua
            cache[monster_name] = loot_list
            cache[monster_name] = [
                i for i in loot_list
                if not any(bad_name.lower() == i['original_page'].lower() for bad_name in IGNORE_LOOT_NAMES)
            ]
            save_cache(cache)
            update_lua_file(path, loot_list)
            print(f"✅ {file} atualizado.")

    print("\n✨ Finalizado!")

if __name__ == "__main__":
    main()