FROM python:alpine

WORKDIR /app

COPY . /app/

RUN pip install redis

CMD [ "python", "db.py" ]