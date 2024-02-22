FROM python:3.11.5-slim-bullseye

ARG USER=test
ARG UID=1001

ENV PATH="/root/.local/bin:$PATH" \
    POETRY_VIRTUALENVS_CREATE=false
ENV PYTHONUNBUFFERED=1

WORKDIR /tmp

COPY ["pyproject.toml", "poetry.lock", "./"]
COPY ["dist/*.tar.gz", "./"]

RUN apt update &&\
    apt install -yq --no-install-recommends curl  && \
    apt-get clean && apt-get autoremove -y && \
    useradd -m -b /sdk --shell /bin/bash --uid ${UID} ${USER} && \
    curl https://install.python-poetry.org -o poetry-install.py && \
    python poetry-install.py --version 1.5.1

RUN poetry install --only main --no-interaction --no-ansi
RUN poetry add ./*.tar.gz

WORKDIR /app

RUN chown -R ${USER}:0 /app \
    && chmod -R g+w /app \
    && mkdir /var/log/app -p \
    && chown -R ${USER}:0 /var/log/app \
    && chmod -R g+w /var/log/app

USER ${USER}

COPY main.py process/main.py

CMD ["sh", "-c", "/usr/local/bin/python /app/process/main.py 2>&1 | tee -a /var/log/app/app.log"]