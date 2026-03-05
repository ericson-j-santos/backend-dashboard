from fastapi import APIRouter, Depends, Request, HTTPException
from .models import DashboardResponse
from .auth import create_access_token, get_current_user, hash_password, verify_password
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

@router.post("/login")
async def login(username: str, password: str):
    
    # usuário mockado
    faker_user = {
        "username": "admin",
        "hash_password": hash_password("admin123")
    }
    
    if username != faker_user["username"]:
        raise HTTPException(status_code=401, detail="Usuário inválido")
    
    if not verify_password(password, faker_user["hash_password"]):
        raise HTTPException(status_code=401, detail="Senha inválida")
    
    access_token = create_access_token(data={"sub": username})
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/api/dashboard", response_model=DashboardResponse)
async def get_dashboard(
    request: Request,
    user: str = Depends(get_current_user)
    ):
    
    # correlation_id = request.headers.get("x-correlation-id")
    correlation_id = request.state.correlation_id
    
    logger.info(
        "DASHBOARD_REQUEST_RECEIVED",
        extra={"correlation_id": correlation_id},
    )

    return {
        "user": user,
        "metricas": {
            "vendas": 120,
            "usuarios": 50,
            "tickets": 12
        }
    }