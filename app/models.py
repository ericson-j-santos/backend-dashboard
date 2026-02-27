from pydantic import BaseModel
from typing import List

class DashboardResponse(BaseModel):
    total: int
    sucesso: int
    falhas: int
    pendentes: int
    receita_mensal: List[int]
    categorias: List[str]