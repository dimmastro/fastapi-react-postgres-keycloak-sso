
FROM python:3.8.0

WORKDIR /backend

RUN apt-get install libpq-dev

COPY ./ /backend

RUN python -m pip install --upgrade pip
RUN python -m pip install -r requirements.txt
ENTRYPOINT [ "./entrypoint.sh" ]
