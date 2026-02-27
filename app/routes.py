from fastapi import APIRouter, Request
from .models import DashboardResponse

router = APIRouter()

@router.get("/api/dashboard", response_model=DashboardResponse)
async def get_dashboard(request: Request):
    
    print({
        "event": "DASHBOARD_REQUEST",
        "correlation_id": request.state.correlation_id
    })
    
    return DashboardResponse(
        total=300,
        sucesso=280,
        falhas=10,
        pendentes=10,
        receita_mensal=[10,20,15,30,25,40],
        categorias=["Jan","Feb","Mar","Apr","May","Jun"]
    )