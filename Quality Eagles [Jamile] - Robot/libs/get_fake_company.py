from faker import Faker
import unicodedata
import re

faker = Faker('pt-BR')

from faker import Faker
import unicodedata
import re

faker = Faker('pt-BR')

def remover_acentos(texto):
    """Remove acentos e caracteres especiais do texto."""
    texto_sem_acentos = unicodedata.normalize('NFKD', texto)
    texto_limpo = re.sub(r'[^\w\s]', '', texto_sem_acentos)
    return texto_limpo

def remover_titulos(nome):
    """Remove títulos como sr, sra, srta do nome."""
    titulos = ('sr', 'sra', 'srta')
    nome_lower = nome.lower()
    for titulo in titulos:
        if nome_lower.startswith(titulo + ' '):
            return nome[len(titulo) + 1:]
    return nome

def limpar_ponto_nome(nome):
    """Remove pontos e caracteres especiais de uma string de nome."""
    nome_sem_titulos = remover_titulos(nome)
    nome_sem_acentos = remover_acentos(nome_sem_titulos)
    # Substitui underscore por espaço
    return nome_sem_acentos.replace('_', ' ')

def limpar_cnpj(cnpj):
    """Remove pontos e traços de uma string de CPF."""
    cnpj_sem_acentos = remover_acentos(cnpj)
    return cnpj_sem_acentos.replace('.', '').replace('-', '')

def get_fake_company():
    """Gera dados de empresa fictícia com formatação adequada."""
    return {
        "corporateName": limpar_ponto_nome(faker.company()),
        "corporateEmail": faker.email(),
        "cnpj": limpar_cnpj(faker.cnpj())
           } 