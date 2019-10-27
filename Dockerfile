FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build-env
WORKDIR /app

ARG CONFIGURATION

VOLUME [ "/app/data" ]

COPY Build/MSBuild/* ./Build/MSBuild/
COPY Source/*.csproj ./Source/

WORKDIR /app/Source/

RUN dotnet restore

COPY Source/ ./
RUN dotnet publish -c $CONFIGURATION -o out


FROM mcr.microsoft.com/dotnet/core/runtime:3.0 as base

ARG CONFIGURATION=Release

RUN echo Configuration = $CONFIGURATION

RUN if [ "$CONFIGURATION" = "Debug" ] ; then apt-get update && \
    apt-get install -y --no-install-recommends unzip procps && \
    rm -rf /var/lib/apt/lists/* \
    ; fi

RUN if [ "$CONFIGURATION" = "debug" ] ; then curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l ~/vsdbg ; fi

WORKDIR /app
COPY --from=build-env /app/Source/out ./
COPY --from=build-env /app/Source/.dolittle ./.dolittle

ENTRYPOINT ["dotnet", "Server.dll"]