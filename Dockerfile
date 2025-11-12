# Use official .NET SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /app

# Copy project definition and restore dependencies
COPY ULTRAKILL_FULL_GAME.csproj .
RUN dotnet restore

# Copy the rest of your source code
COPY . .

# Build the project
RUN dotnet build -c Release -o /app/build

# Runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
WORKDIR /app

# Copy build output from previous stage
COPY --from=build /app/build .

# Optional: copy native libs or extra files
# COPY libs/ /app/libs/
# ENV LD_LIBRARY_PATH=/app/libs:$LD_LIBRARY_PATH

# Start your app
ENTRYPOINT ["dotnet", "ULTRAKILL_FULL_GAME.dll"]
