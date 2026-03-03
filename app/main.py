from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routes import router
from .middleware import CorrelationMiddleware
from .logging_config import setup_logging
from .database import get_connection

setup_logging()
app = FastAPI()
app.add_middleware(CorrelationMiddleware)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:4200",
        "https://ericson-j-santos.github.io"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
def startup():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            correlation_id TEXT,
            message TEXT
            )
        """)
    conn.commit()
    conn.close()

app.include_router(router)