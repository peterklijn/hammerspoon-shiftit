FROM akorn/luarocks:lua5.4-alpine

RUN apk add gcc musl-dev
RUN luarocks install luacheck
