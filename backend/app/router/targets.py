"""Target router."""
import typing as tp

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import crud, schemas
from app.database.session import get_db

router = APIRouter()


@router.post("/targets", response_model=schemas.Target)
def create_target(target: schemas.TargetIn, db: Session = Depends(get_db)):
    """Create a target."""
    return crud.create_target(db, target)


@router.get("/targets", response_model=tp.List[schemas.Target])
def read_targets(db: Session = Depends(get_db)):
    """Get all targets."""
    return crud.get_targets(db)


@router.get("/targets/{target_id}", response_model=schemas.Target)
def read_target(target_id: int, db: Session = Depends(get_db)):
    """Get a specific target."""
    return crud.get_target(db, target_id)


@router.delete("/targets/{target_id}", response_model=schemas.Target)
def delete_target(target_id: int, db: Session = Depends(get_db)):
    """Delete a target."""
    return crud.delete_target(db, target_id)


@router.put("/targets/{target_id}", response_model=schemas.Target)
def edit_target(
    target_id: int, target: schemas.TargetIn, db: Session = Depends(get_db)
):
    """Edit a target."""
    return crud.edit_target(db, target_id, target)


@router.get("/pictures", response_model=tp.List[schemas.Picture])
def read_pictures(db: Session = Depends(get_db)):
    """Get all pictures."""
    return crud.get_pictures(db)


@router.post("/targets/{target_id}/pictures", response_model=schemas.Picture)
def create_picture_for_target(
    target_id: int, picture: schemas.PictureCreate, db: Session = Depends(get_db)
):
    """Create a picture belonging to a target."""
    return crud.create_target_picture(db, picture, target_id)
