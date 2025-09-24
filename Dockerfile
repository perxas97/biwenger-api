# Etapa de build usando una versión de Go compatible con GOPATH
FROM golang:1.16-buster AS build
ENV GO111MODULE=off

WORKDIR /go/src/github.com/pablopb3/biwenger-api
COPY . .

# Instala dependencias (estilo GOPATH)
RUN go get gopkg.in/mgo.v2/bson \
 && go get gopkg.in/mgo.v2 \
 && go get github.com/tidwall/gjson \
 && go get github.com/gorilla/mux \
 && go get github.com/magiconair/properties \
 && go get github.com/dghubble/go-twitter/twitter \
 && go get github.com/dghubble/oauth1

# Compila el binario (ajusta ./main.go si el entrypoint tiene otro nombre)
RUN go build -o /app ./main.go

# Imagen final mínima
FROM gcr.io/distroless/base-debian10
COPY --from=build /app /app
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/app"]
