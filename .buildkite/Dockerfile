ARG VERSION
FROM crystallang/crystal:${VERSION}-alpine as base

RUN mkdir -p /ci
WORKDIR /ci

FROM base as shards

COPY shard.yml /ci/

RUN shards install

FROM base as runner

ADD . /ci
COPY --from=shards /ci/lib /ci/lib
COPY --from=shards /ci/bin /ci/bin

