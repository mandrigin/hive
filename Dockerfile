FROM docker.io/library/golang:1.18-alpine3.15 AS reqs
WORKDIR /app
RUN apk add --no-cache build-base
ADD go.mod .
ADD go.sum .
RUN go mod download

FROM reqs as builder
WORKDIR /app
ADD . .
RUN go build hive.go

FROM builder as runner
WORKDIR /app
COPY --from=builder /app/hive .
ENTRYPOINT ["/app/hive"]
