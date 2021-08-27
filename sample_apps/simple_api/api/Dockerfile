FROM python:3.6-jessie
RUN apt update
WORKDIR /app
ADD ./src/requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
ADD ./src /app/
ENV PORT 8080
CMD ["gunicorn", "autoapp:app"]
