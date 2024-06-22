FROM golang:1.18 AS builder 

WORKDIR /app

RUN go mod init golang-rocks
RUN go mod tidy

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o main .

FROM scratch

COPY --from=builder /app/main /app/main

ENTRYPOINT ["/app/main"]