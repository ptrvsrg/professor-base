FROM python:3.9.18-alpine
ENV PYTHONUNBUFFERED 1
RUN mkdir /professor_base
WORKDIR /professor_base
COPY ./professor_base/ .
RUN apk add --no-cache --virtual .build-deps ca-certificates gcc postgresql-dev linux-headers musl-dev libffi-dev jpeg-dev zlib-dev \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && find /usr/local \( -type d -a -name test -o -name tests \) -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) -exec rm -rf '{}' + \
    && runDeps="$(scanelf --needed --nobanner --recursive /usr/local | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | sort -u | xargs -r apk info --installed | sort -u )" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps
EXPOSE 8000
ENTRYPOINT python manage.py makemigrations && python manage.py migrate && python manage.py createsuperuser --noinput && python manage.py runserver 0.0.0.0:8000