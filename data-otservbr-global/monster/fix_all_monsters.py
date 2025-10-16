import os
import re
import unicodedata
import xml.etree.ElementTree as ET
import requests
from bs4 import BeautifulSoup

# Diretório base e paths
BASE_DIR = os.getcwd()  # C:\Users\Leona\Documents\GitHub\canary\data-otservbr-global\monster
ITEMS_XML_PATH = os.path.join(BASE_DIR, "items.xml")
MONSTERS_DIR = BASE_DIR  # Aponta para a pasta monster

# Mapeamento de raridade para chance
RARITY_MAP = {
    'common': 80000,
    'uncommon': 23000,
    'semi-rare': 5000,
    'rare': 1000,
    'very rare': 260
}
DEFAULT_CHANCE = 80000

# Normalize nomes
def normalize_name(name: str) -> str:
    name = name.lower()
    name = unicodedata.normalize('NFD', name)
    name = ''.join(c for c in name if unicodedata.category(c) != 'Mn')
    name = re.sub(r'[^\w\s]', '', name)
    name = name.replace('_', ' ').strip()
    return name

# Carrega items.xml, priorizando itens com stopduration
def load_items_xml(path):
    try:
        tree = ET.parse(path)
        root = tree.getroot()
        items = {}
        transform_map = {}  # Mapeia IDs transformados para IDs originais

        # Primeiro passe: coletar todos os itens
        for item in root.findall('item'):
            name = item.get('name')
            item_id = item.get('id')
            if not (name and item_id):
                continue
            # Verifica se o item tem stopduration (não ativo)
            stopduration = any(attr.get('key') == 'stopduration' and attr.get('value') == '1' for attr in item.findall('attribute'))
            items[normalize_name(name)] = {'id': int(item_id), 'stopduration': stopduration}
            # Verifica transformações
            for attr in item.findall('attribute'):
                if attr.get('key') in ('transformequipto', 'transformdeequipto'):
                    transform_id = attr.get('value')
                    transform_map[transform_id] = item_id

        # Segundo passe: ajustar IDs para usar o item com stopduration
        for name, data in items.items():
            item_id = str(data['id'])
            # Se o item é um ID transformado, usar o ID original (com stopduration)
            if item_id in transform_map:
                original_id = transform_map[item_id]
                items[name] = {'id': int(original_id), 'stopduration': True}
            # Se o item já tem stopduration ou não tem transformação, manter o ID
            elif data['stopduration']:
                items[name] = {'id': data['id'], 'stopduration': True}
            else:
                items[name] = {'id': data['id'], 'stopduration': False}

        # Retornar apenas o mapeamento de nome para ID
        return {name: data['id'] for name, data in items.items()}
    except FileNotFoundError:
        print(f"Erro: Arquivo {path} não encontrado!")
        return {}

# Lê nome do monstro no Lua
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

# Pega loot do Fandom
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
        except requests.RequestException:
            continue
    return None

# Parse loot HTML
def parse_loot_html(html):
    loot_list = []
    for li in html.find_all("li"):
        if 'mw-empty-elt' in li.get('class', []):
            continue
        text = li.get_text(" ", strip=True)
        if not text:
            continue
        qty_match = re.match(r'(\d+)(?:-(\d+))?×?\s*', text)
        if qty_match:
            min_q = int(qty_match.group(1))
            max_q = int(qty_match.group(2)) if qty_match.group(2) else min_q
            item_text = text[qty_match.end():].strip()
        else:
            min_q = max_q = 1
            item_text = text
        rar_match = re.search(r'\(([^)]+)\)', item_text)
        rarity = rar_match.group(1).strip().lower() if rar_match else None
        a_tag = li.find("a")
        if a_tag:
            name = normalize_name(a_tag.get_text(strip=True))
        else:
            name = normalize_name(re.sub(r'\([^)]+\)', '', item_text).strip())
        chance = RARITY_MAP.get(rarity, DEFAULT_CHANCE)
        loot_list.append({
            "name": name,
            "chance": chance,
            "maxCount": max_q
        })
    return loot_list

# Atualiza Lua
def update_lua_file(path, loot_list, items_dict):
    try:
        with open(path, encoding="utf8") as f:
            data = f.read()
        if not loot_list:
            loot_block = "monster.loot = {\n\n}\n"
        else:
            loot_block = "monster.loot = {\n"
            for item in loot_list:
                name = item['name']
                item_id = items_dict.get(name)
                if not item_id:
                    continue
                chance = item['chance']
                max_count = item.get('maxCount')
                if max_count > 1 or max_count != item.get('minCount', 1):  # Evita maxCount para quantidades fixas de 1
                    loot_block += f'\t{{ id = {item_id}, chance = {chance}, maxCount = {max_count} }}, -- {name}\n'
                else:
                    loot_block += f'\t{{ id = {item_id}, chance = {chance} }}, -- {name}\n'
            loot_block += "}\n"
        # Substitui o bloco monster.loot existente, se houver
        if re.search(r'monster\.loot\s*=\s*\{.*?\}\s*(?=\n|$)', data, flags=re.S):
            new_data = re.sub(r'monster\.loot\s*=\s*\{.*?\}\s*(?=\n|$)', loot_block, data, flags=re.S)
        else:
            # Insere antes de 'return mType' ou no final do arquivo
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

# Main
def main():
    print("🧙‍♂️ Iniciando atualização de loots...")
    print(f"Verificando diretório: {MONSTERS_DIR}")
    if not os.path.exists(MONSTERS_DIR):
        print(f"Erro: Diretório {MONSTERS_DIR} não encontrado!")
        return
    print(f"Arquivos e subpastas encontrados: {os.listdir(MONSTERS_DIR)}")
    items_dict = load_items_xml(ITEMS_XML_PATH)
    if not items_dict:
        print("Erro: Não foi possível carregar items.xml. Encerrando.")
        return
    for root, dirs, files in os.walk(MONSTERS_DIR):
        print(f"Processando subdiretório: {root}")
        print(f"Arquivos .lua encontrados: {[f for f in files if f.endswith('.lua')]}")
        if not files:
            print(f"Nenhum arquivo encontrado em {root}")
            continue
        for file in files:
            if not file.endswith(".lua"):
                continue
            path = os.path.join(root, file)
            monster_name = get_monster_name_from_lua(path) or os.path.splitext(file)[0].capitalize()
            print(f"\n[BUSCANDO] {monster_name} ({os.path.relpath(path, BASE_DIR)})...")
            loot_html = get_loot_html_from_fandom(monster_name)
            if not loot_html:
                print("  ⚠️ Loot não encontrado no Fandom (pulando).")
                continue
            loot_list = parse_loot_html(loot_html)
            if not loot_list:
                print("  ⚠️ Nenhum item válido detectado — arquivo será deixado com loot vazio.")
            else:
                print(f"  → Itens detectados: {len(loot_list)} {[i['name'] for i in loot_list]}")
            update_lua_file(path, loot_list, items_dict)
            print(f"  ✅ {file} atualizado.")
    print("\n✨ Finalizado!")

if __name__ == "__main__":
    main()