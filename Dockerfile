FROM golang:1.22.5 AS base
WORKDIR /app

#stores dependencies of golang (similar to requirement.txt for python or pom.xml file for java)
COPY go.mod . 
RUN go mod download

#copy all cloned files to container
COPY . . 


RUN go build -o main .

#final stage with Distroless image
FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

ENTRYPOINT [ "./main" ]