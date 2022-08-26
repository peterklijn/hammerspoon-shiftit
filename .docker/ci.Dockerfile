FROM akorn/luarocks:lua5.4-alpine

RUN apk add gcc musl-dev make

RUN luarocks install luacheck \
    && luarocks install luaunit

WORKDIR shiftit
