import pandas as pd
from datetime import datetime
import ast

# simulação
payload = {
    "email": "acolhida.exemplo@gmail.com",
    "nome": "Acolhida Exemplo",
    "data_de_nascimento": "01/01/1990",
    "telefone": "(00) 00000-0000",
    "cep": "0000-000",
    "bairro": "Sé",
    "cidade": "São Paulo",
    "uf": "SP",
    "possui_deficiencia": "não",
    "genero": "mulher cis",
    "cor": "parda",
    "latitude": -23.551447,
    "longitude": -46.634321,
    "timestamp_cadastro": "2025-04-10T18:31:41+00:00",
    "pode_receber_atendimento_online": "sim",
    "violencia": {
        "tipos_de_violencia": "['psicológica', 'patrimonial', 'física']",
        "quanto_tempo_esta_sofrendo_violencia": "menos de 1 ano",
        "ja_procurou_ajuda": "não",
        "e_a_primeira_vez_que_sofre_violencia": "sim",
        "onde_ocorreu_a_violencia": "ambiente domestico",
        "realizou_registro_da_violencia": "não"
    }
}

# IDs fictícios
acolhida_id = 1
endereco_id = 1
atendimento_id = 1

acolhidas_df = pd.DataFrame([{
    "acolhida_id": acolhida_id,
    "nome": payload["nome"],
    "data_de_nascimento": pd.to_datetime(payload["data_de_nascimento"], dayfirst=True),
    "possui_deficiencia": payload["possui_deficiencia"],
    "genero": payload["genero"],
    "cor": payload["cor"],
    "pode_receber_atendimento_online": payload["pode_receber_atendimento_online"],
    "timestamp_cadastro": pd.to_datetime(payload["timestamp_cadastro"])
}])

enderecos_df = pd.DataFrame([{
    "endereco_id": endereco_id,
    "acolhida_id": acolhida_id,
    "email": payload.get("email"),
    "telefone": payload["telefone"],
    "cep": payload["cep"],
    "bairro": payload["bairro"],
    "cidade": payload["cidade"],
    "uf": payload["uf"],
    "latitude": payload["latitude"],
    "longitude": payload["longitude"]
}])

violencia = payload["violencia"]
atendimentos_df = pd.DataFrame([{
    "atendimento_id": atendimento_id,
    "acolhida_id": acolhida_id,
    "quanto_tempo_esta_sofrendo_violencia": violencia["quanto_tempo_esta_sofrendo_violencia"],
    "ja_procurou_ajuda": violencia["ja_procurou_ajuda"],
    "e_a_primeira_vez_que_sofre_violencia": violencia["e_a_primeira_vez_que_sofre_violencia"],
    "onde_ocorreu_a_violencia": violencia["onde_ocorreu_a_violencia"],
    "realizou_registro_da_violencia": violencia["realizou_registro_da_violencia"],
    "timestamp_atendimento": pd.to_datetime(payload["timestamp_cadastro"])
}])

tipos_de_violencia = ast.literal_eval(violencia["tipos_de_violencia"])
violencias_tipos_df = pd.DataFrame([
    {"tipo_id": i + 1, "tipo": tipo}
    for i, tipo in enumerate(tipos_de_violencia)
])

violencias_df = pd.DataFrame([
    {"atendimento_id": atendimento_id, "tipo_id": i + 1}
    for i in range(len(tipos_de_violencia))
])

print("Acolhidas:")
print(acolhidas_df, "\n")
print("Endereços:")
print(enderecos_df, "\n")
print("Atendimentos:")
print(atendimentos_df, "\n")
print("Tipos de Violência:")
print(violencias_tipos_df, "\n")
print("Violências:")
print(violencias_df)
