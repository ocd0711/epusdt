FROM golang:1.22 AS builder

ENV CGO_ENABLED=0
ENV GOOS=linux

WORKDIR /go/app

COPY src/go.mod src/go.sum ./
RUN go mod download

COPY src/ .
RUN go build -o epusdt ./main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app/bin
COPY --from=builder /go/app/epusdt /app/bin/epusdt

ENTRYPOINT ["/app/bin/epusdt"]