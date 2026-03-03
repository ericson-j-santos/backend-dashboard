from fastapi import APIRouter, Request, HTTPException
from .models import DashboardResponse
import logging

logger = logging.getLogger(__name__)

router = APIRouter()

@router.get("/api/dashboard", response_model=DashboardResponse)
async def get_dashboard(request: Request):
    
    # correlation_id = request.headers.get("x-correlation-id")
    correlation_id = request.state.correlation_id
    
    logger.info(
        "DASHBOARD_REQUEST_RECEIVED",
        extra={"correlation_id": correlation_id},
    )
    
    # if not correlation_id:
    #     print({
    #         "event": "CORRELATION_ID_INVALID",
    #         "status": "FAILED"
    #     })
    #     raise HTTPException(status_code=400, detail="Correlation-ID ausente")
    
    # print({
    #     "event": "CORRELATION_ID_INVALID",
    #     # "correlation_id": request.state.correlation_id
    #     "correlation_id": correlation_id,
    #     "status": "SUCCESS"
    # })

    return DashboardResponse(
        total=300,
        sucesso=280,
        falhas=10,
        pendentes=10,
        receita_mensal=[10,20,15,30,25,40],
        categorias=["Jan","Feb","Mar","Apr","May","Jun"]
    )