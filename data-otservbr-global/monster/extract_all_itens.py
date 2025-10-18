#!/usr/bin/env python3
# extract_all_itens.py
import os
import re
import json
import time
import requests
from bs4 import BeautifulSoup

BASE = "https://tibia.fandom.com"
HEADERS = {"User-Agent": "Mozilla/5.0 (compatible; AbyssoriaBot/1.0)"}
TIMEOUT = 15
OUTPUT_FILE = "item_ids.json"
SAVE_EVERY = 50  # salva incrementalmente a cada N itens

# Categoria padrão — troque por "Amulets_and_Necklaces" ou por argumento CLI se preferir
DEFAULT_CATEGORY = "Amulets_and_Necklaces"
CATEGORYS = [
    "Amulets_and_Necklaces",
    "Helmets",
    "Armors",
    "Legs",
    "Boots",
    "Shields",
    "Spellbooks",
    "Quivers",
    "Axe_Weapons",
    "Club_Weapons",
    "Sword_Weapons",
    "Rods",
    "Wands",
    "Distance_Weapons",
    "Books",
    "Floor_Decorations",
    "Containers",
    "Contest_Prizes",
    "Fansite_Items",
    "Decorations",
    "Documents_and_Papers",
    "Dolls_and_Bears",
    "Furniture",
    "Kitchen_Tools",
    "Musical_Instruments",
    "Trophies",
    "Creature_Products",
    "Food",
    "Liquids",
    "Plants_and_Herbs",
    "Keys",
    "Light_Sources",
    "Painting_Equipment",
    "Rings",
    "Tools",
    "Taming_Items",
    "Diving_Equipment",
    "Clothing_Accessories",
    "Enchanted_Items",
    "Game_Tokens",
    "Valuables",
    "Magical_Items",
    "Metals",
    "Party_Items",
    "Blessing_Charms",
    "Quest_Items",
    "Rubbish",
    "Runes"
]

# --- util
def safe_get(url, retries=2):
    for i in range(retries + 1):
        try:
            r = requests.get(url, headers=HEADERS, timeout=TIMEOUT)
            r.raise_for_status()
            return r
        except Exception as e:
            if i == retries:
                raise
            time.sleep(1 + i * 1.5)

def load_existing():
    if os.path.exists(OUTPUT_FILE):
        try:
            with open(OUTPUT_FILE, "r", encoding="utf8") as f:
                data = json.load(f)
            if "items" in data:
                return data["items"], data.get("processed_categories", [])
            else:
                return data, []  # Legado: JSON direto com itens
        except Exception:
            return {}, []
    return {}, []

def save(items, processed_categories):
    data = {"items": items, "processed_categories": processed_categories}
    with open(OUTPUT_FILE, "w", encoding="utf8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def page_to_url(page_title):
    # page_title pode ser "Amethyst_Necklace" ou "Amethyst Necklace"
    s = page_title.replace(" ", "_")
    return f"{BASE}/wiki/{s}"

def edit_url_for_page_title(page_title):
    return page_to_url(page_title) + "?action=edit"

# --- extrai lista de itens da categoria (apenas coluna "Name")
def extract_item_names_from_category(category_name):
    url = f"{BASE}/wiki/{category_name}"
    print(f"▶ Baixando categoria: {url}")
    r = safe_get(url)
    soup = BeautifulSoup(r.text, "html.parser")
    content = soup.select_one("div.mw-parser-output") or soup

    names = []

    # percorre todas as tabelas
    for table in content.find_all("table"):
        # pega todas as linhas <tr>
        for tr in table.find_all("tr"):
            tds = tr.find_all("td")
            if not tds:
                continue
            first_td = tds[0]

            # tenta extrair todos os links válidos da célula
            for a in first_td.find_all("a", href=True):
                href = a['href']
                title = a.get("title") or a.get_text(" ", strip=True)
                if not title:
                    continue
                # ignora links de ação/history e namespaces
                if "?action=" in href or any(ns in href for ns in (":", "Special", "Template", "Help", "File", "Talk", "Category")):
                    continue
                names.append(title.strip())

            # fallback: se não houver links, pega texto puro da célula
            if not first_td.find("a"):
                text = first_td.get_text(" ", strip=True)
                if text and len(text) < 120 and not any(x in text for x in ("Vocation", "Paladins", "Sorcerers", "Knights", "Monks", "Rookgaard")):
                    names.append(text.split("\n")[0].strip())

    # remove duplicados mantendo ordem
    seen = set()
    out = []
    for n in names:
        n = n.strip()
        if n and n not in seen:
            seen.add(n)
            out.append(n)

    print(f"▶ Total de itens extraídos: {len(out)}")
    return out

# --- extrai itemid do ?action=edit
def extract_itemid_from_edit(page_title):
    url = edit_url_for_page_title(page_title)
    try:
        r = safe_get(url)
    except Exception as e:
        # tentativa com versão sanitizada (underscores)
        try:
            url2 = edit_url_for_page_title(page_title.replace(" ", "_"))
            r = safe_get(url2)
        except Exception:
            print(f"    ⚠️ Erro ao baixar edit page para {page_title}: {e}")
            return None, None

    soup = BeautifulSoup(r.text, "html.parser")
    textarea = soup.find("textarea", id="wpTextbox1")
    if not textarea:
        # às vezes a página é redirecionada ou usa template; tenta extrair via regex do HTML bruto
        raw = r.text
        m = re.search(r'<textarea[^>]*>(.*?)</textarea>', raw, re.S)
        if m:
            wiki = m.group(1)
        else:
            return None, None
    else:
        wiki = textarea.get_text()

    # extrai itemid — pode ser "itemid" ou "item_id" (cobre variantes)
    m_id = re.search(r'\|\s*itemid\s*=\s*([0-9]{1,6})', wiki, re.I)
    if not m_id:
        m_id = re.search(r'\|\s*item_id\s*=\s*([0-9]{1,6})', wiki, re.I)
    # extrai name (se presente)
    m_name = re.search(r'\|\s*name\s*=\s*(.+)', wiki, re.I)

    itemid = m_id.group(1).strip() if m_id else None
    name = m_name.group(1).strip() if m_name else None
    # cleanup name: some templates may have trailing pipes; remove after first '|' if present
    if name:
        name = name.split("|")[0].strip()
    return itemid, name

# --- MAIN
def main(category=DEFAULT_CATEGORY):
    all_items, processed_categories = load_existing()

    # Verificar se a categoria já foi processada
    if category in processed_categories:
        print(f"▶ Categoria {category} já processada, pulando.")
        return

    names = extract_item_names_from_category(category)
    print(f"▶ Detectados {len(names)} nomes na categoria {category}")

    processed = 0
    for i, name in enumerate(names, start=1):
        key = name
        if key in all_items:
            print(f"[{i}/{len(names)}] {key} ... já existe, pulando")
            continue

        print(f"[{i}/{len(names)}] {key} ...", end=" ", flush=True)
        itemid, original_name = extract_itemid_from_edit(name)
        if itemid:
            orig = original_name or name
            all_items[key] = {"id": str(itemid), "original_name": orig}
            print(f"OK (id={itemid})")
        else:
            alt = f"{name} (Item)"
            itemid2, orig2 = extract_itemid_from_edit(alt)
            if itemid2:
                all_items[key] = {"id": str(itemid2), "original_name": orig2 or name}
                print(f"OK fallback (id={itemid2})")
            else:
                print("NO-ID")

        processed += 1
        if processed % SAVE_EVERY == 0:
            save(all_items, processed_categories)
            print(f"  💾 Salvo (parcial) {len(all_items)} itens.")

        time.sleep(0.25)

    # Adicionar categoria à lista de processadas
    processed_categories.append(category)
    save(all_items, processed_categories)
    print(f"\n✨ Finalizado. Total coletado: {len(all_items)} itens. Salvo em {OUTPUT_FILE}")

# Para processar múltiplas categorias
if __name__ == "__main__":
    for category in CATEGORYS:  # Iterar sobre a lista de categorias
        main(category)