import os

def inserir_function_no_safe_convert(linha):
    inicio_safe_convert = linha.find('safe_convert<')
    while inicio_safe_convert != -1:
        if '__FUNCTION__' in linha[inicio_safe_convert:]:
            # Pula para a próxima ocorrência se __FUNCTION__ já estiver presente
            inicio_safe_convert = linha.find('safe_convert<', inicio_safe_convert + 1)
            continue

        inicio_parenteses = linha.find('(', inicio_safe_convert)
        if inicio_parenteses == -1:
            break  # Não encontrou o parêntese de abertura, encerra o loop

        contador_parenteses = 1
        i = inicio_parenteses + 1
        while i < len(linha) and contador_parenteses > 0:
            if linha[i] == '(':
                contador_parenteses += 1
            elif linha[i] == ')':
                contador_parenteses -= 1
                if contador_parenteses == 0:
                    # Encontrou o fechamento do último parêntese de safe_convert
                    linha = linha[:i] + ', __FUNCTION__' + linha[i:]
                    break  # Sai do loop e procura a próxima ocorrência
            i += 1

        inicio_safe_convert = linha.find('safe_convert<', i)  # Procura a próxima ocorrência

    return linha

def modificar_arquivo(caminho):
    modificacoes = 0
    with open(caminho, 'r+', encoding='utf-8') as arquivo:
        linhas = arquivo.readlines()
        linhas_modificadas = [inserir_function_no_safe_convert(linha) for linha in linhas]
        if linhas_modificadas != linhas:
            arquivo.seek(0)
            arquivo.writelines(linhas_modificadas)
            arquivo.truncate()
            modificacoes = 1  # Indica que houve modificação
    return modificacoes

def percorrer_diretorios(diretorio_raiz):
    total_modificacoes = 0
    for raiz, dirs, arquivos in os.walk(diretorio_raiz):
        for nome_arquivo in arquivos:
            if nome_arquivo.endswith('.cpp'):
                caminho_completo = os.path.join(raiz, nome_arquivo)
                print(f"Processando arquivo: {caminho_completo}")
                modificacoes = modificar_arquivo(caminho_completo)
                total_modificacoes += modificacoes
                if modificacoes:
                    print(f"Modificações feitas em: {caminho_completo}")
                else:
                    print(f"Nenhuma modificação em: {caminho_completo}")
    print(f"Total de arquivos modificados: {total_modificacoes}")

# Substitua 'caminho_para_raiz' pelo caminho do diretório raiz
percorrer_diretorios('src')
